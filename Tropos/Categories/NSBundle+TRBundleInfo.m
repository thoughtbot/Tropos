#import "NSBundle+TRBundleInfo.h"

@implementation NSBundle (TRBundleInfo)

- (NSString *)versionNumber
{
    return [self objectForInfoDictionaryKey:(id)kCFBundleVersionKey];
}

@end
