typedef void (^CWLocationCompletionBlock)(double latitude,
                                          double longitude);

typedef void (^CWLocationErrorBlock)(NSError *error);

@interface CWLocationController : NSObject

+ (NSString *)coordinateStringFromLatitude:(double)latitude
                                 longitude:(double)longitude;

- (void)updateLocationWithCompletion:(CWLocationCompletionBlock)completionBlock
                          errorBlock:(CWLocationErrorBlock)errorBlock;

@end
