typedef NS_ENUM(NSUInteger, CWWeatherStatus) {
    CWWeatherStatusLocating,
    CWWeatherStatusUpdating,
    CWWeatherStatusUpdated,
    CWWeatherStatusFailed
};

@class CWWeatherLocation;

@interface CWWeatherStatusViewModel : NSObject

@property (nonatomic, copy, readonly) NSString *location;
@property (nonatomic, copy, readonly) NSString *status;

+ (instancetype)viewModelForStatus:(CWWeatherStatus)status weatherLocation:(CWWeatherLocation *)weatherLocation;

@end
