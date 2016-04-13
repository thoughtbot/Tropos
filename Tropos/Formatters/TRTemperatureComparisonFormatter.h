@interface TRTemperatureComparisonFormatter : NSObject

+ (NSString *)localizedStringFromComparison:(TRTemperatureComparison)comparison adjective:(NSString *__autoreleasing *)adjective precipitation:(NSString *)precipitation date:(NSDate *)date;

@end
