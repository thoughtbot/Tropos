#import "NSBundle+CWBundleInfo.h"

@implementation NSBundle (CWBundleInfo)

- (NSString *)versionNumber
{
    return [self objectForInfoDictionaryKey:(id)kCFBundleVersionKey];
}

@end
