@class CLPlacemark;
@class Temperature;

@import Foundation;

@interface TRWeatherUpdate : NSObject <NSCoding>

@property (nonatomic, copy, readonly) NSString *city;
@property (nonatomic, copy, readonly) NSString *state;
@property (nonatomic, copy, readonly) NSString *conditionsDescription;
@property (nonatomic, copy, readonly) NSString *precipitationType;
@property (nonatomic, readonly) Temperature *currentTemperature;
@property (nonatomic, readonly) Temperature *currentHigh;
@property (nonatomic, readonly) Temperature *currentLow;
@property (nonatomic, readonly) Temperature *yesterdaysTemperature;
@property (nonatomic, readonly) CGFloat precipitationPercentage;
@property (nonatomic, readonly) CGFloat windSpeed;
@property (nonatomic, readonly) CGFloat windBearing;
@property (nonatomic, readonly) NSDate *date;
@property (nonatomic, copy, readonly) NSArray *dailyForecasts;

- (instancetype)initWithPlacemark:(CLPlacemark *)placemark currentConditionsJSON:(id)currentConditionsJSON yesterdaysConditionsJSON:(id)yesterdaysConditionsJSON;
- (instancetype)initWithPlacemark:(CLPlacemark *)placemark currentConditionsJSON:(NSDictionary *)currentConditionsJSON yesterdaysConditionsJSON:(NSDictionary *)yesterdaysConditionsJSON date:(NSDate *)date;

@end

#import "TRAnalyticsEvent.h"

@interface TRWeatherUpdate (TRAnalytics) <TRAnalyticsEvent>

@end
