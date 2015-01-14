@class TRCurrentConditions;
@class TRHistoricalConditions;

typedef void (^TRCurrentConditionsResult)(TRCurrentConditions *currentConditions,
                                          TRHistoricalConditions *yesterdaysConditions);

@interface TRForecastClient : NSObject

- (void)fetchConditionsAtLatitude:(double)latitude
                        longitude:(double)longitude
                       completion:(TRCurrentConditionsResult)completion;

@end
