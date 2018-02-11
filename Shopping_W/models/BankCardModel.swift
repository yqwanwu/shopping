//
//  BankCardModel.swift
//  Shopping_W
//
//  Created by wanwu on 2018/2/6.
//  Copyright © 2018年 wanwu. All rights reserved.
//

import UIKit

class BankCardModel: CustomTableViewCellItem {
    var fFinanceid = 0 //226,//ID
    var fName = "" //"张三",//开户名
    var fBankid = 0 //18,//银行ID
    var fAccount = "" //"21412412412412",//卡号
    var fMaskaccount = "" //"2141******2412",//加密卡号，用于页面上显示
    var fMaskphone = "" //"1333***3333",//加密银行预留电话，用于页面上显示
    var fBankname = "" //"民生银行",//银行名称
    var fTypename = "" //"储蓄卡",//卡类型名称
    var fOrder = 0 //0,//排序（暂不使用）
    var fType = 0 //0,//卡类型 0储蓄卡 1信用卡
    var fAccountid = 0 //10,//用户ID
    var fPhone = "" //"13333333333",//银行预留电话
    var fProvinceid = 0 //320000,//开户行所在省ID
    var fProvince = "" //"江苏",//省名
    var fCity = "" //"盐城",//市名
    var fCityid = 0 //320900,//开户行所在市ID
    var fFlag = 0 //0,//账户类型 0对私 1对公
    var fFlagname = "" //"对私"//账户类型名称
}
