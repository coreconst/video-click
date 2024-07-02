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
                print(path)
                
                if !(path.isEmpty){
                    self.sendDirectoryPathToJS(path)
                }
            }
        }
    }


    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        let data = (message.body as! String)
        if(data == "browse"){
            openDirectoryPicker()
        }
            
        var urls = getUserDefaults("sharedMessage") as! Array<String>
        
        if(data.contains("remove")){
            let urlArrayIndex = Int(data.split(separator: ":")[1]);
            
            if(urlArrayIndex != nil && !urls.isEmpty){
                urls.remove(at: urlArrayIndex!)
                setUserDefaults(data: urls, forKey: "sharedMessage")
            }
        }
        
        if(data.contains("download")){
            let arr = data.split(separator: ":");
            let urlArrayIndex = Int(arr[1]);
            
            let fileName = String(arr[2])
            let url = (urls[urlArrayIndex!]).dropFirst().dropLast();
    
            let path = getUserDefaults("savedDirectoryPath") as! String
            
            if(!path.isEmpty && !url.isEmpty){
//                print(shell("cd \(path) && ffmpeg -i '\(url)' -c copy '\(fileName)'.mp4"))
            }
        }
        
        if (data == "sync") {
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

}
