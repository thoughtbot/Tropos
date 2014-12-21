#import "NSError+CWErrors.h"

@implementation NSError (CWErrors)

+ (instancetype)locationUnauthorizedError
{
    return [NSError errorWithDomain:CWErrorDomain code:CWErrorLocationUnauthorized userInfo:nil];
}

@end
