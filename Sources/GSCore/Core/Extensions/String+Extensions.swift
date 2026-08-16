//
//  String+Rootless.swift
//  GSCore
//
//  Created by Noah Little on 19/3/2023.
//

import Foundation
import libroot

#if ROOTHIDE
@_silgen_name("jbroot")
func gsCoreJBRoot(_ path: NSString) -> NSString
#endif

extension String {
    
    public var rootify: Self {
        #if ROOTHIDE
        return gsCoreJBRoot(self as NSString) as String
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
