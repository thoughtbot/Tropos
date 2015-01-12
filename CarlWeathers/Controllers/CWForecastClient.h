@class CWCurrentConditions;
@class CWHistoricalConditions;

@interface CWForecastClient : NSObject

- (RACSignal *)fetchConditionsAtLatitude:(double)latitude
                               longitude:(double)longitude;
- (RACSignal *)fetchHistoricalConditionsAtLatitude:(double)latitude
                                         longitude:(double)longitude;

@end
