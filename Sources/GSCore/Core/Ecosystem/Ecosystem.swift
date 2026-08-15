//
//  Ecosystem.swift
//  GSCore
//
//  Created by Noah Little on 19/3/2023.
//

import Foundation
import libroot

// MARK: - Public

public struct Ecosystem {
    public enum JailbreakType {
        case rootless
        case root

        /// Keeps the historical `rawValue` call shape while resolving the path
        /// at runtime. RootHide therefore never receives a fixed `/var/jb` value.
        public var rawValue: String {
            switch self {
            case .rootless: return jbRootPath("/")
            case .root: return "/"
            }
        }

        /// Compatibility initializer for callers that previously used the
        /// String raw-value form. Only the current dynamic jailbreak root is
        /// accepted as a rootless value.
        public init?(rawValue: String) {
            if rawValue == "/" {
                self = .root
            } else if rawValue == jbRootPath("/") {
                self = .rootless
            } else {
                return nil
            }
        }
    }
    
    /// Returns the scheme category, not a literal bootstrap path. `jbRootPath("/")`
    /// is randomized by RootHide, therefore any non-root result is rootless.
    public static var jailbreakType: JailbreakType {
        jbRootPath("/") == "/" ? .root : .rootless
    }

    /// Runtime-resolved jailbreak root. Callers that access jailbreak files must
    /// use this or `rootify`, never a literal bootstrap prefix.
    public static var jailbreakRootPath: String {
        jbRootPath("/")
    }
    
    public static func isInstalled(tweak: Tweak) -> Bool {
        FileManager.default.fileExists(atPath: tweak.dylibPath)
    }
}
