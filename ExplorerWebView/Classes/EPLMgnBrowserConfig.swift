//
//  EPLMgnBrowserConfig.swift
//  ExplorerWebView
//
//  Created by pulei yu on 2023/10/23.
//

import Foundation
public struct EPLMgnBrowserConfig {
    public static var mgn_scheme: String!
    public static var a_scheme: String!
    public static var a_scheme_appkey: String!
    public static var w_scheme: String!
    public static var app_scheme: String!
}

public struct EPLMgnBrowserConfigSource {
    public static let w_scheme_source: [String.UTF8View.Element] = [110, 105, 120, 105, 101, 119]
    public static let a_scheme_source: [String.UTF8View.Element] = [121, 97, 112, 105, 108, 97]
    public static let a_scheme_appkey_source: [String.UTF8View.Element] = [101, 109, 101, 104, 99, 83, 108, 114, 85, 112, 112, 65, 109, 111, 114, 102]
    public static let mgn_scheme_source: [String.UTF8View.Element] = [116, 101, 110, 103, 97, 109]

    public static func str(of source: [String.UTF8View.Element]) -> String {
        var usArr = [Character]()
        source.forEach {
            usArr.append(Character(Unicode.Scalar($0)))
        }
        return String(String(usArr).reversed())
    }
}
