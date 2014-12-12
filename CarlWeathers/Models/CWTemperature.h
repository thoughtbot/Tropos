@interface CWTemperature : NSObject

typedef NS_ENUM(NSUInteger, CWTemperatureComparison) {
    CWTemperatureComparisonSame,
    CWTemperatureComparisonHotter,
    CWTemperatureComparisonWarmer,
    CWTemperatureComparisonCooler,
    CWTemperatureComparisonColder,
};

@property (nonatomic, readonly) NSNumber *temperature;

+ (instancetype)temperatureFromNumber:(NSNumber *)number;

- (NSString *)stringValue;
- (CWTemperatureComparison)compare:(CWTemperature *)comparedTemperature;

@end
