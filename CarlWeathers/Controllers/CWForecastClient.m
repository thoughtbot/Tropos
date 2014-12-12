#import "CWCurrentConditions.h"
#import "CWForecastClient.h"
#import "CWHistoricalConditions.h"
#import "NSDate+CWRelativeDate.h"

static NSString *const CWForecastAPIBaseURL = @"https://api.forecast.io/forecast/3df031c1b15c324d69d9f4ea8931e740/";

@interface CWForecastClient ()

@property (nonatomic) NSURLSession *session;

@end

@implementation CWForecastClient


- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPAdditionalHeaders = @{@"Accept": @"application/json"};
    self.session = [NSURLSession sessionWithConfiguration:configuration];

    return self;
}

- (void)fetchConditionsAtLatitude:(double)latitude
                        longitude:(double)longitude
                       completion:(CWCurrentConditionsResult)completion
{
    NSParameterAssert(completion);

    NSURL *URL = [self URLForCurrentConditionsAtLatitude:latitude longitude:longitude yesterday:NO];
    [[self.session dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        id JSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

        [self fetchHistoricalConditionsAtLatitude:latitude longitude:longitude completionBlock:^(id JSONObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!JSON) {
                    completion(nil, nil);
                    return;
                }

                CWHistoricalConditions *historicalConditions;
                if (JSONObject) {
                    historicalConditions = [CWHistoricalConditions historicalConditionsFromJSON:JSONObject];
                }

                completion([CWCurrentConditions currentConditionsFromJSON:JSON], historicalConditions);
            });
        }];
    }] resume];
}

- (void)fetchHistoricalConditionsAtLatitude:(double)latitude
                                  longitude:(double)longitude
                            completionBlock:(void (^)(id JSONObject))completionBlock
{
    NSParameterAssert(completionBlock);
    NSURL *yesterdayURL = [self URLForCurrentConditionsAtLatitude:latitude longitude:longitude yesterday:YES];
    [[self.session dataTaskWithURL:yesterdayURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        id JSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        completionBlock(JSON);
    }] resume];
}

#pragma mark - Private Helpers

- (NSURL *)URLForCurrentConditionsAtLatitude:(double)latitude longitude:(double)longitude yesterday:(BOOL)yesterday
{
    NSString *URLString = [CWForecastAPIBaseURL stringByAppendingFormat:@"%f,%f", latitude, longitude];
    if (yesterday) {
        NSTimeInterval timestamp = [[NSDate yesterday] timeIntervalSince1970];
        URLString = [URLString stringByAppendingString:[NSString stringWithFormat:@",%.0f", timestamp]];
    }
    
    return [NSURL URLWithString:URLString];
}

@end
