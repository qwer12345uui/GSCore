#import <Foundation/Foundation.h>

#if defined(ROOTHIDE)
#import <roothide/roothide.h>
#elif defined(ROOTLESS)
#import <rootless.h>
#endif

/// Resolves an absolute path in the jailbreak bootstrap for the active package
/// scheme. RootHide never receives a fixed `/var/jb` prefix because jbroot is
/// randomized by the jailbreak at runtime.
NSString *GSCoreJailbreakPath(NSString *path) {
    if (path.length == 0 || ![path hasPrefix:@"/"]) {
        return path;
    }

#if defined(ROOTHIDE)
    return jbroot(path);
#elif defined(ROOTLESS)
    return ROOT_PATH_NS_VAR(path);
#else
    return path;
#endif
}
