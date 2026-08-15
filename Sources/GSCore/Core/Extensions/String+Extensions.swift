//
//  String+Rootless.swift
//  GSCore
//
//  Created by Noah Little on 19/3/2023.
//

import Foundation
import GSCoreC
import libroot

extension String {
    
    public var rootify: Self {
        #if ROOTHIDE
        return GSCoreJailbreakPath(self)
        #else
        return jbRootPath(self)
        #endif
    }
    
    public func localize(bundle: Bundle) -> Self {
        String(NSLocalizedString(self, bundle: bundle, comment: ""))
    }
}

internal extension String {
    
    var localized: Self {
        localize(bundle: .gsCore)
    }
}
