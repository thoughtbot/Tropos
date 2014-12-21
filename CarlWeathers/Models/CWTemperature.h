@interface CWTemperature : NSObject

typedef NS_ENUM(NSUInteger, CWTemperatureComparison) {
    CWTemperatureComparisonSame,
    CWTemperatureComparisonHotter,
    CWTemperatureComparisonWarmer,
    CWTemperatureComparisonCooler,
    CWTemperatureComparisonColder,
};

@property (nonatomic, readonly) NSNumber *temperatureNumber;

+ (instancetype)temperatureFromNumber:(NSNumber *)number;
- (CWTemperatureComparison)comparedTo:(CWTemperature *)comparedTemperature;
- (NSInteger)differenceFromTemperature:(CWTemperature *)comparedTemperature;

@end
