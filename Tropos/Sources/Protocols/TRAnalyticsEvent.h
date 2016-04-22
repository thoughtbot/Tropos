@protocol TRAnalyticsEvent <NSObject>

@property (nonatomic, readonly) NSString *eventName;
@property (nonatomic, readonly) NSDictionary *eventProperties;

@end
