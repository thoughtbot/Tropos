#import <ReactiveObjC/ReactiveObjC.h>
#import <UIKit/UIKit.h>

@interface UIApplication (TRReactiveBackgroundTask)

- (RACSignal *)tr_backgroundTaskWithSignal:(RACSignal *(^)(void))signalBlock;

@end
