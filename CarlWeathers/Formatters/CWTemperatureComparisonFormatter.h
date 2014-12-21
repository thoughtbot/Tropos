#import "CWTemperature.h"

@interface CWTemperatureComparisonFormatter : NSObject

+ (NSString *)localizedStringFromComparison:(CWTemperatureComparison)comparison adjective:(NSString *__autoreleasing *)adjective;

@end
