@class CWCurrentConditions;
@class CWHistoricalConditions;

typedef void (^CWCurrentConditionsResult)(CWCurrentConditions *currentConditions,
                                          CWHistoricalConditions *yesterdaysConditions);

@interface CWForecastClient : NSObject

- (void)fetchConditionsAtLatitude:(double)latitude
                        longitude:(double)longitude
                       completion:(CWCurrentConditionsResult)completion;

@end
