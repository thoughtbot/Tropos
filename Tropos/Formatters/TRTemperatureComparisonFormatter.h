#import "Tropos-Swift.h"

@interface TRTemperatureComparisonFormatter : NSObject

+ (NSString *)localizedStringFromComparison:(TemperatureComparison)comparison adjective:(NSString *__autoreleasing *)adjective precipitation:(NSString *)precipitation;

@end
