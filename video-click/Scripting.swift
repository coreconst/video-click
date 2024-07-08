//
//  Scripting.swift
//  video-click
//
//  Created by constantine on 25.06.2024.
//

import Foundation
import WebKit


func shell(_ command: String, completion: @escaping (String) -> Void) {
    DispatchQueue.global(qos: .background).async {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/zsh"
        task.standardInput = nil
        task.environment = ["PATH": "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin"]
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        DispatchQueue.main.async {
            completion(output)
        }
    }
}

var timer: Timer?

// Функція для перевірки розміру файлу кожні 10 секунд

func getFileSize(atPath path: String) -> UInt64? {
    do {
        let attributes = try FileManager.default.attributesOfItem(atPath: path)
        return attributes[FileAttributeKey.size] as? UInt64
    } catch {
        print("Error: \(error)")
        return nil
    }
}

func formatFileSize(_ size: UInt64) -> String {
    let mb = Double(size) / (1024 * 1024)
    if mb > 1000 {
        let gb = mb / 1024
        return String(format: "%.2f GB", gb)
    } else {
        return String(format: "%.2f MB", mb)
    }
}
