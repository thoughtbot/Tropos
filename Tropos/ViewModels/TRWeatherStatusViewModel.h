typedef NS_ENUM(NSUInteger, TRWeatherStatus) {
    TRWeatherStatusLocating,
    TRWeatherStatusUpdating,
    TRWeatherStatusUpdated,
    TRWeatherStatusFailed
};

@class TRWeatherLocation;

@interface TRWeatherStatusViewModel : NSObject

@property (nonatomic, copy, readonly) NSString *location;
@property (nonatomic, copy, readonly) NSString *status;

+ (instancetype)viewModelForStatus:(TRWeatherStatus)status weatherLocation:(TRWeatherLocation *)weatherLocation;

@end
