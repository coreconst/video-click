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
                if #available(macOS 13, *) {
                    webView.evaluateJavaScript("show(\(state.isEnabled), true)")
                } else {
                    webView.evaluateJavaScript("show(\(state.isEnabled), false)")
                }
            }
        }
    }


    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        let data = (message.body as! String)
        if(data.contains("remove")){
            let urlArrayIndex = Int(data.split(separator: ":")[1]);
            let defaults = UserDefaults(suiteName: "com.pk.video-click.group")
            var urls = (defaults?.array(forKey:"sharedMessage")) ?? [];
            if(urlArrayIndex != nil && !urls.isEmpty){
                urls.remove(at: urlArrayIndex!)
                defaults?.set(urls, forKey: "sharedMessage")
            }
        }
        
        if (data == "sync") {
            syncUrls();
    //        print(urls)
    //        print(shell("cd \(NSHomeDirectory())/Downloads && /usr/local/bin/ffmpeg -i '\(url.dropFirst().dropLast())' -c copy 'check'.mp4"))
        }
    }
    
    private func syncUrls(){
        let defaults = UserDefaults(suiteName: "com.pk.video-click.group")
        let urls = (defaults?.array(forKey:"sharedMessage")) ?? [];

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

}
