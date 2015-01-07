#import "NSBundle+CWBundleInfo.h"

@implementation NSBundle (CWBundleInfo)

- (NSString *)versionNumber
{
    return [self objectForInfoDictionaryKey:kCFBundleVersionKey];
}

@end
