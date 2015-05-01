@import CoreLocation;
#import "TRWeatherUpdate.h"
#import "TRTemperature.h"
#import "TRDailyForecast.h"

@interface TRWeatherUpdate ()

@property (nonatomic, copy, readwrite) NSString *city;
@property (nonatomic, copy, readwrite) NSString *state;
@property (nonatomic, copy, readwrite) NSString *conditionsDescription;
@property (nonatomic, copy, readwrite) NSString *precipitationType;
@property (nonatomic, readwrite) TRTemperature *currentTemperature;
@property (nonatomic, readwrite) TRTemperature *currentLow;
@property (nonatomic, readwrite) TRTemperature *currentHigh;
@property (nonatomic, readwrite) TRTemperature *yesterdaysTemperature;
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

    NSDictionary *todaysConditions = currentConditionsJSON[@"currently"];
    NSDictionary *yesterdaysConditions = yesterdaysConditionsJSON[@"currently"];
    NSDictionary *todaysForecast = [currentConditionsJSON[@"daily"][@"data"] firstObject];

    self.precipitationPercentage = [todaysForecast[@"precipProbability"] floatValue];
    self.precipitationType = todaysForecast[@"precipType"] ? todaysForecast[@"precipType"] : @"rain";
    self.conditionsDescription = todaysConditions[@"icon"];
    [self updateCurrentTemperaturesWithConditions:todaysConditions withForecast:todaysForecast];
    self.yesterdaysTemperature = [TRTemperature temperatureFromFahrenheit:yesterdaysConditions[@"temperature"]];
    self.windBearing = [todaysConditions[@"windBearing"] floatValue];
    self.windSpeed = [todaysConditions[@"windSpeed"] floatValue];
    self.date = [NSDate date];

    NSMutableArray *dailyForecasts = [NSMutableArray array];

    for (NSUInteger index = 1; index < 4; index++) {
        TRDailyForecast *dailyForecast = [[TRDailyForecast alloc] initWithJSON:currentConditionsJSON[@"daily"][@"data"][index]];
        [dailyForecasts addObject:dailyForecast];
    }

    self.dailyForecasts = [dailyForecasts copy];
    
    return self;
}

- (void)updateCurrentTemperaturesWithConditions:(NSDictionary *)conditions withForecast:(NSDictionary *)forecast
{
    self.currentTemperature = [TRTemperature temperatureFromFahrenheit:conditions[@"temperature"]];
    self.currentLow = [TRTemperature temperatureFromFahrenheit:forecast[@"temperatureMin"]];
    self.currentHigh = [TRTemperature temperatureFromFahrenheit:forecast[@"temperatureMax"]];
    
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

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.currentConditions forKey:TRCurrentConditionsKey];
    [coder encodeObject:self.yesterdaysConditions forKey:TRYesterdaysConditionsKey];
    [coder encodeObject:self.placemark forKey:TRPlacemarkKey];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    CLPlacemark *placemark = [coder decodeObjectForKey:TRPlacemarkKey];
    NSDictionary *currentConditions = [coder decodeObjectForKey:TRCurrentConditionsKey];
    NSDictionary *yesterdaysConditions = [coder decodeObjectForKey:TRYesterdaysConditionsKey];

    return [self initWithPlacemark:placemark currentConditionsJSON:currentConditions yesterdaysConditionsJSON:yesterdaysConditions];
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
