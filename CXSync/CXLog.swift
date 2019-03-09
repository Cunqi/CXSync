//
//  CXLog.swift
//  CXSync
//
//  Created by Cunqi Xiao on 3/8/19.
//  Copyright © 2019 Cunqi Xiao. All rights reserved.
//

import Foundation

enum CXLogLevel: Int, Comparable {
    static func < (lhs: CXLogLevel, rhs: CXLogLevel) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
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
        guard logLevel >= CXLogLevel.error else {
            return
        }
        log(logLevel.tag, message)
    }
    
    static func W(_ message: String) {
        guard logLevel >= CXLogLevel.warn else {
            return
        }
        log(logLevel.tag, message)
    }

    static func I(_ message: String) {
        guard logLevel >= CXLogLevel.info else {
            return
        }
        log(logLevel.tag, message)
    }

    static func D(_ message: String) {
        guard logLevel >= CXLogLevel.debug else {
            return
        }
        log(logLevel.tag, message)
    }

    static func A(_ message: String) {
        guard logLevel >= CXLogLevel.all else {
            return
        }
        log(logLevel.tag, message)
    }
    
    private static func log(_ tag: String, _ message: String) {
        print("\(tag): \(message)")
    }
}
