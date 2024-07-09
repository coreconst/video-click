//
//  ActionHandler.swift
//  video-click
//
//  Created by constantine on 08.07.2024.
//

import Foundation
import WebKit
import Cocoa

struct ActionHandler
{
    private let webView: WKWebView
    private let data: (action: String, url: String, name:String)
    
    init(webView: WKWebView, data: (action: String, url: String, name:String)) {
        self.webView = webView
        self.data = data
    }
    
    func syncUrls(){
        let urls = getUserDefaults("sharedMessage") as! Array<String>;

        if !urls.isEmpty {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: urls, options: [])
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    let jsCode = "receiveUrls(\(jsonString));"
                    webView.evaluateJavaScript(jsCode, completionHandler: { (result, error) in
                        if let error = error {
                            print("Error executing JavaScript: \(error)")
                        }
                    })
                }
            } catch {
                print("Error serializing JSON: \(error)")
            }
        }
    }
    
    func download(){
        if(!checkIfBrewAndFfmpegInstalled().ffmpeg) {return}
        
        let fileName = data.name;
        let url = data.url;
       
        let path = getUserDefaults("savedDirectoryPath") as! String
        
        if(!path.isEmpty && !url.isEmpty){
            startDownload(path: path, url: url, fileName: fileName, webView: self.webView)
            startMonitoringFileSize(filePath: "\(path)/\(fileName).mp4", url: url, webView: self.webView)
            
//            print("This will print immediately without waiting for the shell command to finish")
        }
    }
    
    func openDirectoryPicker() {
        let dialog = NSOpenPanel()
        dialog.title = "Choose a directory"
        dialog.canChooseDirectories = true
        dialog.canChooseFiles = false
        dialog.allowsMultipleSelection = false
        
        if dialog.runModal() == .OK {
            if let url = dialog.url {
                let path = url.path
                setUserDefaults(data: path, forKey: "savedDirectoryPath")
                ActionHandler.sendDirectoryPathToJS(path: path, webView: self.webView)
            }
        }
    }
    
    static func sendDirectoryPathToJS(path: String, webView: WKWebView) {
        let dir = path.split(separator: "/")
        webView.evaluateJavaScript("showPath('\(dir[dir.count - 1])')")
    }
}
