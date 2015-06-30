#import "TRTemperature.h"

@interface TRTemperatureComparisonFormatter : NSObject

- (instancetype)initWithDate:(NSDate *)date;
- (NSString *)localizedStringFromComparison:(TRTemperatureComparison)comparison adjective:(NSString *__autoreleasing *)adjective precipitation:(NSString *)precipitation;

@end
