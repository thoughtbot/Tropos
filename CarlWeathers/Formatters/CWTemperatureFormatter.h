@class CWTemperature;

@interface CWTemperatureFormatter : NSObject

@property (nonatomic) BOOL usesMetricSystem;

- (NSString *)stringFromTemperature:(CWTemperature *)temperature;

@end
