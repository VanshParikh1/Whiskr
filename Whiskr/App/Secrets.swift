//
//  Secrets.swift
//  Whiskr
//
//  Created by Vansh Parikh on 2025-11-01.
//
import Foundation

enum Secrets {
    static var gptApiKey: String{
        guard let key = Bundle.main.object(forInfoDictionaryKey: "GPTApiKey") as? String else{
            fatalError("Missing GPT API key - check Secrets.xcconfig and info.plist")
        }
        return key
    }
}
