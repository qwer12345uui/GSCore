//
//  Ecosystem.swift
//  GSCore
//
//  Created by Noah Little on 19/3/2023.
//

import Foundation
import GSCoreC

// MARK: - Public

public struct Ecosystem {
    public enum JailbreakType {
        case rootless
        case root

        /// Retains the previous string-facing API while computing the actual
        /// bootstrap root at runtime. RootHide therefore never embeds `/var/jb`.
        public var rawValue: String {
            switch self {
            case .rootless:
                return Ecosystem.jailbreakRootPath
            case .root:
                return "/"
            }
        }

        public init?(rawValue: String) {
            if rawValue == "/" {
                self = .root
            } else if rawValue == Ecosystem.jailbreakRootPath {
                self = .rootless
            } else {
                return nil
            }
        }
    }

    /// Resolves an absolute jailbreak path through the selected scheme's
    /// runtime API. On RootHide this is `jbroot()`; on standard rootless it is
    /// Theos/libroot's root-path macro.
    public static var jailbreakRootPath: String {
        GSCoreJailbreakPath("/")
    }

    public static var jailbreakType: JailbreakType {
        jailbreakRootPath == "/" ? .root : .rootless
    }
    
    public static func isInstalled(tweak: Tweak) -> Bool {
        FileManager.default.fileExists(atPath: tweak.dylibPath)
    }
}
