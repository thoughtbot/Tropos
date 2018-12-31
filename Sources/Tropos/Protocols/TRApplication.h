@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@protocol TRApplication <NSObject>
- (void)setMinimumBackgroundFetchInterval:(NSTimeInterval)minimumBackgroundFetchInterval;
@end

@interface UIApplication (TRApplication) <TRApplication>
@end

NS_ASSUME_NONNULL_END
