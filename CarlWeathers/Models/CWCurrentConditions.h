@interface CWCurrentConditions : NSObject

@property (nonatomic, copy, readonly) NSString *conditionsDescription;
@property (nonatomic, readonly) CGFloat highTemperature;
@property (nonatomic, readonly) CGFloat lowTemperature;

+ (instancetype)currentConditionsFromJSON:(NSDictionary *)JSON;

@end
