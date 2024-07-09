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
                let tools = checkIfBrewAndFfmpegInstalled()
                if(!tools.brew || !tools.ffmpeg){
                    webView.evaluateJavaScript("suggestInstallTools(\(tools.brew), \(tools.ffmpeg))")
                }
                
                let path = (getUserDefaults("savedDirectoryPath") as! String);
                
                if !(path.isEmpty){
                    ActionHandler.sendDirectoryPathToJS(path: path, webView: webView)
                }
            }
        }
    }


    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        let data = parseJsonData(jsonData: (message.body as! String))
        let actionType = data.action;
        
        let action: ActionHandler = ActionHandler(webView: self.webView, data: data);
        
        switch actionType {
        case "browse":
            action.openDirectoryPicker()
            break
        case "sync":
            action.syncUrls();
            break
        case "remove":
            removeUrlFromUserDefaults(data.url)
            break
        case "download":
            action.download()
            break
        default:
            break
        }
    }
}

