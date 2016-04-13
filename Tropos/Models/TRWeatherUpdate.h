#import <UIKit/UIKit.h>

@class CLPlacemark;
@class TRTemperature;

@interface TRWeatherUpdate : NSObject <NSCoding>

@property (nonatomic, copy, readonly) NSString *city;
@property (nonatomic, copy, readonly) NSString *state;
@property (nonatomic, copy, readonly) NSString *conditionsDescription;
@property (nonatomic, copy, readonly) NSString *precipitationType;
@property (nonatomic, readonly) TRTemperature *currentTemperature;
@property (nonatomic, readonly) TRTemperature *currentHigh;
@property (nonatomic, readonly) TRTemperature *currentLow;
@property (nonatomic, readonly) TRTemperature *yesterdaysTemperature;
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
