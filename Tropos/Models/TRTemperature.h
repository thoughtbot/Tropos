@interface TRTemperature : NSObject

typedef NS_ENUM(NSUInteger, TRTemperatureComparison) {
    TRTemperatureComparisonSame,
    TRTemperatureComparisonHotter,
    TRTemperatureComparisonWarmer,
    TRTemperatureComparisonCooler,
    TRTemperatureComparisonColder,
};

@property (nonatomic, readonly) NSInteger fahrenheitValue;
@property (nonatomic, readonly) NSInteger celsiusValue;

+ (instancetype)temperatureFromFahrenheit:(NSNumber *)number;
- (TRTemperatureComparison)comparedTo:(TRTemperature *)comparedTemperature;

@end
