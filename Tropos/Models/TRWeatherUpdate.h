@class CLPlacemark;
@class TRTemperature;

@interface TRWeatherUpdate : NSObject <NSCoding>

@property (nonatomic, copy, readonly) NSString *city;
@property (nonatomic, copy, readonly) NSString *state;
@property (nonatomic, copy, readonly) NSString *conditionsDescription;
@property (nonatomic, readonly) TRTemperature *currentTemperature;
@property (nonatomic, readonly) TRTemperature *currentHigh;
@property (nonatomic, readonly) TRTemperature *currentLow;
@property (nonatomic, readonly) TRTemperature *yesterdaysTemperature;
@property (nonatomic, readonly) CGFloat windSpeed;
@property (nonatomic, readonly) CGFloat windBearing;
@property (nonatomic, readonly) NSDate *date;
@property (nonatomic, copy, readonly) NSArray *dailyForecasts;

- (instancetype)initWithPlacemark:(CLPlacemark *)placemark currentConditionsJSON:(id)currentConditionsJSON yesterdaysConditionsJSON:(id)yesterdaysConditionsJSON;

@end

#import "TRAnalyticsEvent.h"

@interface TRWeatherUpdate (TRAnalytics) <TRAnalyticsEvent>

@end
