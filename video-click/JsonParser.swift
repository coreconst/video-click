//
//  JsonParser.swift
//  video-click
//
//  Created by constantine on 05.07.2024.
//

import Foundation

struct Data: Decodable
{
    let action: String
    let url: String
    let name: String
}

func parseJsonData(jsonData: String)-> (action: String, url: String, name:String)
{
    do {
        let data = try JSONDecoder().decode(Data.self, from: jsonData.data(using: .utf8)!)
        return (data.action, data.url, data.name)
    } catch {
        return ("", "", "")
        
    }
}
