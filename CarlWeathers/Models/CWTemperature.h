@interface CWTemperature : NSObject

typedef NS_ENUM(NSUInteger, CWTemperatureComparison) {
    CWTemperatureComparisonSame,
    CWTemperatureComparisonHotter,
    CWTemperatureComparisonWarmer,
    CWTemperatureComparisonCooler,
    CWTemperatureComparisonColder,
};

@property (nonatomic, readonly) NSInteger fahrenheitValue;
@property (nonatomic, readonly) NSInteger celsiusValue;

+ (instancetype)temperatureFromFahrenheit:(NSNumber *)number;

- (CWTemperatureComparison)comparedTo:(CWTemperature *)comparedTemperature;
- (NSInteger)differenceFromTemperature:(CWTemperature *)comparedTemperature;

@end
