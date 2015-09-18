@import CoreLocation;
#import "Tropos-Swift.h"
#import "TRWeatherUpdate.h"
#import "TRDailyForecast.h"

@interface TRWeatherUpdate ()

@property (nonatomic, copy, readwrite) NSString *city;
@property (nonatomic, copy, readwrite) NSString *state;
@property (nonatomic, copy, readwrite) NSString *conditionsDescription;
@property (nonatomic, copy, readwrite) NSString *precipitationType;
@property (nonatomic, readwrite) Temperature *currentTemperature;
@property (nonatomic, readwrite) Temperature *currentLow;
@property (nonatomic, readwrite) Temperature *currentHigh;
@property (nonatomic, readwrite) Temperature *yesterdaysTemperature;
@property (nonatomic, readwrite) CGFloat precipitationPercentage;
@property (nonatomic, readwrite) CGFloat windSpeed;
@property (nonatomic, readwrite) CGFloat windBearing;
@property (nonatomic, readwrite) NSDate *date;
@property (nonatomic, copy, readwrite) NSArray *dailyForecasts;

@property (nonatomic) CLPlacemark *placemark;
@property (nonatomic) NSDictionary *currentConditions;
@property (nonatomic) NSDictionary *yesterdaysConditions;

@end

@implementation TRWeatherUpdate

- (instancetype)initWithPlacemark:(CLPlacemark *)placemark currentConditionsJSON:(NSDictionary *)currentConditionsJSON yesterdaysConditionsJSON:(NSDictionary *)yesterdaysConditionsJSON
{
    self = [super init];
    if (!self) return nil;

    self.currentConditions = currentConditionsJSON;
    self.yesterdaysConditions = yesterdaysConditionsJSON;
    self.placemark = placemark;
    self.city = placemark.locality;
    self.state = placemark.administrativeArea;

    NSDictionary *currentConditions = currentConditionsJSON[@"currently"];
    NSDictionary *yesterdaysConditions = yesterdaysConditionsJSON[@"currently"];
    NSDictionary *todaysForecast = [currentConditionsJSON[@"daily"][@"data"] firstObject];

    self.precipitationPercentage = [todaysForecast[@"precipProbability"] floatValue];
    self.precipitationType = todaysForecast[@"precipType"] ? todaysForecast[@"precipType"] : @"rain";
    self.conditionsDescription = currentConditions[@"icon"];
    [self updateCurrentTemperaturesWithConditions:currentConditions withForecast:todaysForecast];
    self.yesterdaysTemperature = [[Temperature alloc] initWithFahrenheitValue:[yesterdaysConditions[@"temperature"] integerValue]];
    self.windBearing = [currentConditions[@"windBearing"] floatValue];
    self.windSpeed = [currentConditions[@"windSpeed"] floatValue];
    self.date = [NSDate date];

    NSMutableArray *dailyForecasts = [NSMutableArray array];

    for (NSUInteger index = 1; index < 4; index++) {
        TRDailyForecast *dailyForecast = [[TRDailyForecast alloc] initWithJSON:currentConditionsJSON[@"daily"][@"data"][index]];
        [dailyForecasts addObject:dailyForecast];
    }

    self.dailyForecasts = [dailyForecasts copy];
    
    return self;
}

- (instancetype)initWithPlacemark:(CLPlacemark *)placemark currentConditionsJSON:(NSDictionary *)currentConditionsJSON yesterdaysConditionsJSON:(NSDictionary *)yesterdaysConditionsJSON date:(NSDate *)date
{
    self = [self initWithPlacemark:placemark currentConditionsJSON:currentConditionsJSON yesterdaysConditionsJSON:yesterdaysConditionsJSON];
    if (!self) return nil;

    self.date = date;

    return self;
}

- (void)updateCurrentTemperaturesWithConditions:(NSDictionary *)conditions withForecast:(NSDictionary *)forecast
{
    self.currentTemperature = [[Temperature alloc] initWithFahrenheitValue:[conditions[@"temperature"] integerValue]];
    self.currentLow = [[Temperature alloc] initWithFahrenheitValue:[forecast[@"temperatureMin"] integerValue]];
    self.currentHigh = [[Temperature alloc] initWithFahrenheitValue:[forecast[@"temperatureMax"] integerValue]];
    if (self.currentTemperature.fahrenheitValue < self.currentLow.fahrenheitValue) {
        self.currentLow = self.currentTemperature;
    } else if (self.currentTemperature.fahrenheitValue > self.currentHigh.fahrenheitValue) {
        self.currentHigh = self.currentTemperature;
    }
}

#pragma mark - NSCoding

static NSString *const TRCurrentConditionsKey = @"TRCurrentConditions";
static NSString *const TRYesterdaysConditionsKey = @"TRYesterdaysConditionsConditions";
static NSString *const TRPlacemarkKey = @"TRPlacemark";
static NSString *const TRDateKey = @"TRDateAt";

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.currentConditions forKey:TRCurrentConditionsKey];
    [coder encodeObject:self.yesterdaysConditions forKey:TRYesterdaysConditionsKey];
    [coder encodeObject:self.placemark forKey:TRPlacemarkKey];
    [coder encodeObject:self.date forKey:TRDateKey];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    CLPlacemark *placemark = [coder decodeObjectForKey:TRPlacemarkKey];
    NSDictionary *currentConditions = [coder decodeObjectForKey:TRCurrentConditionsKey];
    NSDictionary *yesterdaysConditions = [coder decodeObjectForKey:TRYesterdaysConditionsKey];
    NSDate *date = [coder decodeObjectForKey:TRDateKey];

    return [self initWithPlacemark:placemark currentConditionsJSON:currentConditions yesterdaysConditionsJSON:yesterdaysConditions date:date];
}

@end

@implementation TRWeatherUpdate (TRAnalytics)

- (NSString *)eventName
{
    return @"Weather Update";
}

- (NSDictionary *)eventProperties
{
    return (@{
              @"Latitude": [self analyticsLatitude],
              @"Longitude": [self analyticsLongitude],
              @"City": self.city,
              @"State": self.state,
              @"Temperature": @(self.currentTemperature.fahrenheitValue),
              @"Low Temperature": @(self.currentLow.fahrenheitValue),
              @"High Temperature": @(self.currentHigh.fahrenheitValue),
              @"Wind Speed": @(self.windSpeed),
              @"Wind Bearing": @(self.windBearing),
              @"Update Date": self.date
              });
}

#pragma mark - Analytics Formatters

- (NSNumber *)analyticsLatitude
{
    return [self anonymizeLocationDegrees:self.placemark.location.coordinate.latitude];
}

- (NSNumber *)analyticsLongitude
{
    return [self anonymizeLocationDegrees:self.placemark.location.coordinate.longitude];
}

- (NSNumber *)anonymizeLocationDegrees:(double)degrees
{
    return @(round(degrees * 100) / 100);
}

@end
