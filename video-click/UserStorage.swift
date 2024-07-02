//
//  UserStorage.swift
//  video-click
//
//  Created by constantine on 02.07.2024.
//

import Foundation

let defaults = UserDefaults(suiteName: "com.pk.video-click.group")

func getUserDefaults(_ forKey: String) -> Any?
{
    switch forKey{
        case "savedDirectoryPath": return (defaults?.string(forKey: "savedDirectoryPath") ?? "")
        case "sharedMessage": return defaults?.array(forKey:"sharedMessage") ?? []
        default: return nil
    }
}

func setUserDefaults(data: Any, forKey: String) -> Void
{
    defaults?.set(data, forKey: forKey)
}

func removeUserDefaults(_ forKey: String) -> Void
{
    defaults?.removeObject(forKey: forKey)
}
