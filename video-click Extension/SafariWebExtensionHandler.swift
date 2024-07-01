//
//  SafariWebExtensionHandler.swift
//  video-click Extension
//
//  Created by constantine on 14.06.2024.
//

import SafariServices
import os.log

let extensionBundleIdentifier = "com.pk.video-click.Extension"

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {
    
//    var urls: Array<String> = []
    
    func beginRequest(with context: NSExtensionContext) {
            guard let item = context.inputItems.first as? NSExtensionItem,
                  let userInfo = item.userInfo as? [String: Any],
                  let message = userInfo[SFExtensionMessageKey] else {
                context.completeRequest(returningItems: nil, completionHandler: nil)
                return
            }


            if let profileIdentifier = userInfo[SFExtensionProfileKey] as? UUID {
                // Perform profile specific tasks.
            } else {
                // Perform normal browsing tasks.
            }
            
            let sharedDefaults = UserDefaults(suiteName: "com.pk.video-click.group");
            
            var urls: Array<String> = (sharedDefaults?.array(forKey:"sharedMessage") as? [String]) ?? []
            if !(urls.contains(message as! String)){
                urls.append(message as! String)
                    sharedDefaults?.set(urls, forKey: "sharedMessage")
            }
        
            let response = NSExtensionItem()
        
            response.userInfo = [ SFExtensionMessageKey: [ "Response to": "Saved"] ]
    
            context.completeRequest(returningItems: [response], completionHandler: nil)
    }
}
