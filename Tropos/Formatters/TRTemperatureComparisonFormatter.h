#import "TRTemperature.h"

@interface TRTemperatureComparisonFormatter : NSObject

+ (NSString *)localizedStringFromComparison:(TRTemperatureComparison)comparison adjective:(NSString *__autoreleasing *)adjective precipitation:(NSString *)precipitation;

@end
