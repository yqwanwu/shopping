//
//  FileDownloader.swift
//  server
//
//  Created by wanwu on 16/7/13.
//  Copyright © 2016年 wanwu. All rights reserved.
//

import UIKit


/**
 //    let fd = FileDownloader(urlStr: "http://dlsw.baidu.com/sw-search-sp/soft/9d/25765/sogou_mac_32c_V3.2.0.1437101586.dmg", savePath: "/Users/xxapp/Desktop/lala.dmg")
 let fd = FileDownloader(urlStr: "http://192.168.1.67:8080/test/test.zip", savePath: "/Users/xxapp/Desktop/lala.zip", process: { (process) in
 print("下载了：\(process)")
 }, complete: {
 print("ok!!!!")
 }) { (error) in
 
 }
 //    fd.start()
 */


class FileDownloader: NSObject, URLSessionDelegate, URLSessionDataDelegate {
    fileprivate let suffixName = "tmp"
    fileprivate var temporaryPath = ""
    
    var dataTask: URLSessionDataTask?
    let url: URL
    let savePath: String
    var fileHandle: FileHandle = FileHandle()
    
    var currentLenth: Int = 0
    var totalLenth: Int = 0
    
    var headerFiles: [String:String]?
    
    var request: NSMutableURLRequest = NSMutableURLRequest()
    
    typealias downloadProcess = (_ process: Double) -> Void
    typealias downloadComplete = (_ session: URLSession, _ task: URLSessionTask, _ error: Error?) -> Void
    typealias downloadFailure = (_ error: NSError) -> Void
    
    var process: downloadProcess?
    var complete: downloadComplete?
    var failure: downloadFailure?
    

    init(url: URL, savePath: String) {
        self.savePath = savePath
        self.url = url
    }
    
    init(url: URL, savePath: String, process: downloadProcess?, complete: downloadComplete?, failure: downloadFailure?) {
        self.savePath = savePath
        self.url = url
        self.process = process
        self.complete = complete
        self.failure = failure
    }
 
    func start() {
        var tmpPath = NSTemporaryDirectory()
        tmpPath = (tmpPath as NSString).appendingPathComponent("tmpFiles")
        temporaryPath = (tmpPath as NSString).appendingPathComponent((savePath as NSString).lastPathComponent) + suffixName

        let path = temporaryPath as String
        
        createFile(path, placehodelFile: true)
        
        fileHandle = FileHandle(forWritingAtPath: path)!
        fileHandle.seekToEndOfFile()
        let cfg = URLSessionConfiguration.default
        let session = Foundation.URLSession(configuration: cfg, delegate: self, delegateQueue: OperationQueue())
        
        let data = try? Data(contentsOf: URL(fileURLWithPath: path))
        
        currentLenth = data!.count
        
        request = NSMutableURLRequest(url: url)
        
        if let h = headerFiles {
            for (k, v) in h {
                request.setValue(v, forHTTPHeaderField: k)
            }
        }
        
        if data != nil {
            request.setValue("bytes=\(data!.count)-", forHTTPHeaderField: "Range")
        }
        
        dataTask = session.dataTask(with: request as URLRequest)
        dataTask?.resume()
    }
    
    func createFile(_ path: String, placehodelFile: Bool) {
        let fileMgr = FileManager.default
        let wholePath = path as NSString
        if !fileMgr.fileExists(atPath: path) {
            do {
                let dir = wholePath.deletingLastPathComponent
                if !fileMgr.fileExists(atPath: dir) {
                    try fileMgr.createDirectory(atPath: dir, withIntermediateDirectories: true, attributes: nil)
                }
                if placehodelFile {
                    fileMgr.createFile(atPath: path, contents: nil, attributes: nil)
                }
                
            } catch {
                
            }
        }
    }
    
    func cancel() {
        dataTask?.cancel()
        dataTask = nil
    }
    
    //代理
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        fileHandle.write(data)
        currentLenth += data.count
        if let process = process {
            process(Double(currentLenth) / Double(totalLenth))
        }
    }
    
    private func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: (URLSession.ResponseDisposition) -> Void) {
        completionHandler(Foundation.URLSession.ResponseDisposition.allow)
        totalLenth = Int(response.expectedContentLength) + currentLenth
    }
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        if let failure = failure {
            failure(error! as NSError)
        }
        dataTask?.cancel()
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        let fileMgr = FileManager.default
        createFile(savePath, placehodelFile: false)
        
        do {
            if fileMgr.fileExists(atPath: savePath) {
                try fileMgr.removeItem(atPath: savePath)
            }
            try fileMgr.moveItem(atPath: temporaryPath, toPath: savePath)
        } catch let err {
            print(err)
        }
        
        if let complete = complete {
            complete(session, task, error)
        }
    }
    
}
