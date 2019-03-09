//
//  CXLog.swift
//  CXSync
//
//  Created by Cunqi Xiao on 3/8/19.
//  Copyright © 2019 Cunqi Xiao. All rights reserved.
//

import Foundation

enum CXLogLevel: Int {
    case error = 0, warn, info, debug, all, off

    var tag: String {
        switch self {
        case .error:
            return "[Error]"
        case .warn:
            return "[Warn]"
        case .info:
            return "[Info]"
        case .debug:
            return "[Debug]"
        case .all:
            return "[All]"
        case .off:
            return ""
        }
    }
}

class CXLog {
    static var logLevel: CXLogLevel = .debug

    static func E(_ message: String) {
        guard logLevel.rawValue >= CXLogLevel.error.rawValue else {
            return
        }
    }

    static func I(_ message) {

    }

    static func D(_ message) {

    }

    static func A(_ message) {

    }

    static func E(_ message) {

    }
}
