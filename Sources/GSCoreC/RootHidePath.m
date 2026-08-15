#import <Foundation/Foundation.h>

#if __has_include(<roothide.h>)
#import <roothide.h>
#define GSCORE_HAS_ROOTHIDE 1
#else
#define GSCORE_HAS_ROOTHIDE 0
#endif

NSString *GSCoreJailbreakPath(NSString *path) {
    if (path.length == 0 || ![path hasPrefix:@"/"]) {
        return path;
    }

#if GSCORE_HAS_ROOTHIDE && defined(ROOTHIDE)
    return jbroot(path);
#else
    return path;
#endif
}
