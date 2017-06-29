//
//  BaseModelExtension.swift
//  coreTextTest
//
//  Created by wanwu on 16/8/9.
//  Copyright © 2016年 wanwu. All rights reserved.
//

import UIKit

protocol ParseModelProtocol: NSObjectProtocol {
    ///Array 类型已经处理， NSArray需要自己传入 泛型类型  如， array ： xxx.Preson,
    ///Warning: 数组中如果是 非自定义 类型，只处理 基本的 String， Int， Double， Float， 如Int64这种不处理
    func getArrayClassType() -> [String:String]
    
    func deal(withSpecialPropertyName name: String!) -> String!
    
    func parse(dic: NSDictionary)
    
    ///特殊字段，自己处理
    ///:returns  返回 true，表示自己处理该字段， false交给 代码处理
    func isDealSpecialPropertyByUser(name: String, value: AnyObject?) -> Bool
    
    func filterPropertysForCoding() -> [String]?
    
    func autoEncode(coder: NSCoder)
    
    func autoDecode(coder: NSCoder)
    
}

extension ParseModelProtocol where Self: NSObject {
    func getArrayClassType() -> [String:String] {
        return [String:String]()
    }
    
    func deal(withSpecialPropertyName name: String!) -> String! {
        return name;
    }
    
    func parse(dic: NSDictionary) {
        let _ = ModelParser.parse(dic: dic, model: self, originalModel: self)
    }
    
    func isDealSpecialPropertyByUser(name: String, value: AnyObject?) -> Bool {
        return false
    }
    
    func filterPropertysForCoding() -> [String]? {
        return nil
    }
    
    func autoEncode(coder: NSCoder) {
        ModelParser.encode(model: self, coder: coder)
    }
    
    func autoDecode(coder: NSCoder) {
        ModelParser.decode(model: self, coder: coder)
    }
    
    static func parseArr(object: NSArray?) -> [Self] {
        var result = [Self]()
        if object != nil {
            for item in object! {
                if item is NSDictionary {
                    let model = Self()
                    model.parse(dic: item as! NSDictionary)
                    result.append(model)
                }
            }
        }
    
        return result
        
    }
}



class ModelParser: NSObject {
    
    ///暂时不想处理日期
    class func parse(dic: NSDictionary, model: NSObject, originalModel: NSObject) -> AnyObject {
        var m = Mirror(reflecting: model)
        let header = NSStringFromClass(self.self).components(separatedBy: ".")[0]
        
        var dicValueName = ""
        var typeDic = [String:String]()
        if let om = originalModel as? ParseModelProtocol {
            typeDic = om.getArrayClassType()
        }
        
        while m.superclassMirror != nil {
            var subjectTypeStr = String(describing: m.subjectType).replacingOccurrences(of: "Optional<", with: "").replacingOccurrences(of: ">", with: "")
            if !subjectTypeStr.hasPrefix(header) && !subjectTypeStr.hasPrefix("Swift") {
                subjectTypeStr = header + "." + subjectTypeStr
            }
            
            if NSClassFromString(subjectTypeStr) == nil {
                break
            }
            
            for child in m.children {
                guard child.label != nil else {
                    continue
                }
                
                dicValueName = child.label!
                ///处理特殊字段
                if let om = originalModel as? ParseModelProtocol {
                    dicValueName = om.deal(withSpecialPropertyName: child.label!)
                    if om.isDealSpecialPropertyByUser(name: child.label!, value: dic.value(forKey: dicValueName) as AnyObject?) {
                        continue
                    }
                }
                
                do {
                    ///强制处理异常
                    try ObjC.catchException({
                        if let val = dic[dicValueName], !(val is NSNull) {
                            let modelObj = model
                            
                            ///判断属性的类型
                            let m1 = Mirror(reflecting: child.value)
                            let type = m1.subjectType
                            let str = String(describing: type).replacingOccurrences(of: "Optional<", with: "").replacingOccurrences(of: ">", with: "")
                            var typeStr = ""
                            
                            //若为数组
                            if let clazzType = typeDic[child.label!], val is NSArray {
                                let list = getModelList(dicVal: val as! NSArray, typeStr: clazzType, originalModel: originalModel)
                                if list.count > 0 {
                                    modelObj.setValue(list, forKey: child.label!)
                                }
                            } else if "\(m1.subjectType)".contains("Array<") && val is NSArray {
                                let rang = str.range(of: "Array<")
                                if let r = rang {
                                    typeStr = str.substring(from: r.upperBound)
                                    if !typeStr.hasPrefix(header) && !typeStr.hasPrefix("Swift") {
                                        typeStr = header + "." + typeStr
                                    }
                                    
                                    let list = getModelList(dicVal: val as! NSArray, typeStr: typeStr, originalModel: originalModel)
                                    if list.count > 0 {
                                        modelObj.setValue(list, forKey: child.label!)
                                    }
                                }
                            } else {//非数组的情况
                                //可转换的对象
                                typeStr = str
                                if !typeStr.hasPrefix(header) && !typeStr.hasPrefix("Swift") {
                                    typeStr = header + "." + typeStr
                                }
                                
                                if let clazz = NSClassFromString(typeStr), let v = val as? NSDictionary {
                                    let obj = clazz.alloc()
                                    let _ = parse(dic: v , model: obj as! NSObject, originalModel: originalModel)
                                    modelObj.setValue(obj, forKey: child.label!)
                                } else {
                                    modelObj.setValue(val, forKey: child.label!)
                                }
                            }
                        }
                    })
                    
                } catch {
                    continue
                }
            }
            
            //处理父类属性
            if m.superclassMirror == nil {
                return model
            } else {
                m = m.superclassMirror!
            }
        }
        
        return model
    }
    
    private class func getModelList(dicVal: NSArray, typeStr: String, originalModel: NSObject) -> NSArray {
        let modelList = NSMutableArray()
        let last = (typeStr as NSString).pathExtension
        if let clazz = NSClassFromString(typeStr) {
            for v in dicVal {
                //是字典就转
                if let v = v as? NSDictionary {
                    let obj = clazz.alloc()
                    let model = parse(dic: v, model: obj as! NSObject, originalModel: originalModel)
                    modelList.add(model)
                }
            }
        } else {
            for v in dicVal {
                if typeStr.contains("String") {
                    modelList.add(String(describing: v))
                } else if last == "Int" {
                    if let v = v as? NSNumber {
                        modelList.add(v)
                    } else if let v = v as? NSString {
                        modelList.add(NSNumber(value: v.longLongValue))
                    }
                } else if last == "Double" {
                    if let v = v as? NSNumber {
                        modelList.add(v)
                    } else if let v = v as? NSString {
                        modelList.add(NSNumber(value: v.doubleValue))
                    }
                } else if last == "Float" {
                    if let v = v as? NSNumber {
                        modelList.add(v)
                    } else if let v = v as? NSString {
                        modelList.add(NSNumber(value: v.floatValue))
                    }
                } else {
                    let m = Mirror(reflecting: v)
                    let type = String(describing: m.subjectType).replacingOccurrences(of: "Optional<", with: "").replacingOccurrences(of: ">", with: "")
                    
                    if type == last {
                        return dicVal
                    }
                }
            }
        }
        return modelList
    }
    
    // MARK: 归档
    class func encode(model: ParseModelProtocol, coder: NSCoder) {
        var m = Mirror(reflecting: model)
        let filterArray = model.filterPropertysForCoding()
        while m.superclassMirror != nil {
            for c in m.children {
                if let label = c.label {
                    if let arr = filterArray, arr.contains(label) {
                        continue
                    }
                    
                    do {
                        try ObjC.catchException({
                            coder.encode((model as! NSObject).value(forKey: label), forKey: label)
                        })
                    } catch let e as NSError {
                        print(e)
                    }
                }
            }
            m = m.superclassMirror!
        }
    }
    
    class func decode(model: ParseModelProtocol, coder: NSCoder) {
        var m = Mirror(reflecting: model)
        let filterArray = model.filterPropertysForCoding()
        while m.superclassMirror != nil {
            for c in m.children {
                if let label = c.label {
                    if let arr = filterArray, arr.contains(label) {
                        continue
                    }
                    
                    do {
                        try ObjC.catchException({
                            let obj = coder.decodeObject(forKey: label)
                            if let val = obj {
                                (model as! NSObject).setValue(val, forKey: label)
                            }
                        })
                    } catch let e as NSError {
                        print(e)
                    }
                }
            }
            
            m = m.superclassMirror!
        }
    }
    
}



