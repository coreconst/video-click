//
//  Station.swift
//  video-click
//
//  Created by constantine on 28.06.2024.
//

import Foundation
import Combine

extension UserDefaults {
    @objc dynamic var sharedMessage: String {
       get { string(forKey: "sharedMessage") ?? "" }
       set { setValue(newValue, forKey: "sharedMessage") }
   }
}

@available(macOS 10.15, *)
class SharedData: ObservableObject {
    @Published var sharedMessage: String = UserDefaults(suiteName: "group.com.pk.video-click")?.sharedMessage ?? "" {
        didSet {
            UserDefaults(suiteName: "com.pk.video-click.group")?.sharedMessage = sharedMessage
        }
    }

    private var cancelable: AnyCancellable?
    
    init() {
        cancelable = UserDefaults(suiteName: "com.pk.video-click.group")?.publisher(for: \.sharedMessage)
            .sink(receiveValue: { [weak self] newValue in
                guard let self = self else { return }
                if newValue != self.sharedMessage {
                    self.sharedMessage = newValue
                }
            })
    }
}
