@class TRTemperature;

@interface TRTemperatureFormatter : NSObject

@property (nonatomic) BOOL usesMetricSystem;

- (NSString *)stringFromTemperature:(TRTemperature *)temperature;

@end
