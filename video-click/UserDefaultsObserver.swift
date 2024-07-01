//
//  UserDefaultsObserver.swift
//  video-click
//
//  Created by constantine on 27.06.2024.
//

import Foundation

class UserDefaultsObserver {
    static let shared = UserDefaultsObserver()
        
        private let sharedDefaults = UserDefaults(suiteName: "com.pk.video-click.group")

        init() {
            NotificationCenter.default.addObserver(self, selector: #selector(userDefaultsDidChange), name: UserDefaults.didChangeNotification, object: sharedDefaults)
        }

        @objc private func userDefaultsDidChange(notification: NSNotification) {
            if let message = sharedDefaults?.string(forKey: "extensionMessage") {
                print("Received message in main app: \(message)")
                // Обробка повідомлення
            }
        }
}
