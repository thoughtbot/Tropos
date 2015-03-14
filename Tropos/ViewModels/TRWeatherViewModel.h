@class TRWeatherUpdate;

@interface TRWeatherViewModel : NSObject

@property (nonatomic, readonly) NSString *locationName;
@property (nonatomic, readonly) NSString *updatedDateString;
@property (nonatomic, readonly) UIImage *conditionsImage;
@property (nonatomic, readonly) NSAttributedString *conditionsDescription;
@property (nonatomic, readonly) NSString *windDescription;
@property (nonatomic, readonly) NSAttributedString *temperatureDescription;
@property (nonatomic, readonly) NSArray *dailyForecasts;

- (instancetype)initWithWeatherUpdate:(TRWeatherUpdate *)weatherUpdate;

@end
