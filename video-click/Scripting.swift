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

func startMonitoringFileSize(filePath: String, url: String, webView: WKWebView) {
    timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
        if let fileSize = getFileSize(atPath: filePath) {
            let formattedSize = formatFileSize(fileSize)
            webView.evaluateJavaScript("updateSize('\(formattedSize)', '\(url)')")
            print("Current file size: \(fileSize) bytes")
        } else {
            print("File not found or unable to get size.")
        }
    }
}

func startDownload(path: String, url: String, fileName: String, webView: WKWebView) {
    shell("cd \(path) && ffmpeg -i '\(url)' -c copy '\(fileName)'.mp4") { output in
        webView.evaluateJavaScript("stopDownload('\(url)')")
        timer?.invalidate()
        timer = nil
        print("Download completed.")
        
        removeUrlFromUserDefaults(url);
    }
}

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
