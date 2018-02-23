#import "TRErrors.h"
#import "UIApplication+TRReactiveBackgroundTask.h"

@implementation UIApplication (TRReactiveBackgroundTask)

- (RACSignal *)tr_backgroundTaskWithSignal:(RACSignal *(^)(void))signalBlock
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        __block RACDisposable *disposable;

        UIBackgroundTaskIdentifier taskIdentifier = [self beginBackgroundTaskWithExpirationHandler:^{
            [disposable dispose];
        }];

        if (taskIdentifier == UIBackgroundTaskInvalid) {
            NSDictionary *userInfo = @{
                NSLocalizedDescriptionKey: @"Running in the background is not possible."
            };
            NSError *error = [NSError errorWithDomain:TRErrorDomain
                                                 code:0
                                             userInfo: userInfo];
            [subscriber sendError:error];
        }

        RACSignal *signal = signalBlock();
        disposable = [[signal
            finally:^{
                [self endBackgroundTask:taskIdentifier];
            }]
            subscribe: subscriber];

        return disposable;
    }];
}

@end
