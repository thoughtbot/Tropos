#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface UIApplication (TRReactiveBackgroundTask)

- (RACSignal *)tr_backgroundTaskWithSignal:(RACSignal *(^)(void))signalBlock;

@end
