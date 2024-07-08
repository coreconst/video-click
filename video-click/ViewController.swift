//
//  ViewController.swift
//  video-click
//
//  Created by constantine on 14.06.2024.
//

import Cocoa
import SafariServices
import WebKit
import SwiftUI

let extensionBundleIdentifier = "com.pk.video-click.Extension"

class ViewController: NSViewController, WKNavigationDelegate, WKScriptMessageHandler {

    @IBOutlet var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView.navigationDelegate = self

        self.webView.configuration.userContentController.add(self, name: "controller")

        self.webView.loadFileURL(Bundle.main.url(forResource: "Main", withExtension: "html")!, allowingReadAccessTo: Bundle.main.resourceURL!)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SFSafariExtensionManager.getStateOfSafariExtension(withIdentifier: extensionBundleIdentifier) { (state, error) in
            guard let state = state, error == nil else {
                // Insert code to inform the user that something went wrong.
                return
            }
            
            DispatchQueue.main.async {
                let path = (getUserDefaults("savedDirectoryPath") as! String);
//                let urls = getUserDefaults("sharedMessage") as! Array<String>;
                
                if !(path.isEmpty){
                    self.sendDirectoryPathToJS(path)
                }
            }
        }
    }


    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        let data = parseJsonData(jsonData: (message.body as! String))
        let action = data.action;
        
        if(action == "browse"){
            openDirectoryPicker()
            return;
        }
            
        var urls = getUserDefaults("sharedMessage") as! Array<String>
        
        if(action == "remove"){
            let url = data.url
            
            removeUrlFromUserDefaults(url);
            return;
        }
        
        if(action == "download"){
            let fileName = data.name;
            let url = data.url;
           
            let path = getUserDefaults("savedDirectoryPath") as! String
            
            if(!path.isEmpty && !url.isEmpty){
                
                startDownload(path: path, url: url, fileName: fileName)
                startMonitoringFileSize(filePath: "\(path)/\(fileName).mp4", url: url)
                
                print("This will print immediately without waiting for the shell command to finish")
            }
            return;
        }
        
        if (action == "sync") {
            syncUrls();
        }
    }
    
    private func syncUrls(){
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
    
    private func openDirectoryPicker() {
            let dialog = NSOpenPanel()
            dialog.title = "Choose a directory"
            dialog.canChooseDirectories = true
            dialog.canChooseFiles = false
            dialog.allowsMultipleSelection = false
            
            if dialog.runModal() == .OK {
                if let url = dialog.url {
                    let path = url.path
                    setUserDefaults(data: path, forKey: "savedDirectoryPath")
                    sendDirectoryPathToJS(path)
                }
            }
        }
        
    private func sendDirectoryPathToJS(_ path: String) {
        let dir = path.split(separator: "/")
        webView.evaluateJavaScript("showPath('\(dir[dir.count - 1])')")
    }
    
    func startMonitoringFileSize(filePath: String, url: String) {
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            if let fileSize = getFileSize(atPath: filePath) {
                let formattedSize = formatFileSize(fileSize)
                self.webView.evaluateJavaScript("updateSize('\(formattedSize)', '\(url)')")
                print("Current file size: \(fileSize) bytes")
            } else {
                print("File not found or unable to get size.")
            }
        }
    }
    
    func startDownload(path: String, url: String, fileName: String) {
        shell("cd \(path) && ffmpeg -i '\(url)' -c copy '\(fileName)'.mp4") { output in
            self.webView.evaluateJavaScript("stopDownload('\(url)')")
            timer?.invalidate()
            timer = nil
            print("Download completed.")
            
            removeUrlFromUserDefaults(url);
        }
    }


}
