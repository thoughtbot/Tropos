#import "TRCurrentConditions.h"
#import "TRForecastClient.h"
#import "TRHistoricalConditions.h"
#import "NSDate+TRRelativeDate.h"

static NSString *const TRForecastAPIBaseURL = @"https://api.forecast.io/forecast/3df031c1b15c324d69d9f4ea8931e740/";
static NSString *const TRForecastAPIExclusions = @"minutely,hourly,alerts,flags";

@interface TRForecastClient ()

@property (nonatomic) NSURLSession *session;

@end

@implementation TRForecastClient


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
                       completion:(TRCurrentConditionsResult)completion
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

                TRHistoricalConditions *historicalConditions;
                if (JSONObject) {
                    historicalConditions = [TRHistoricalConditions historicalConditionsFromJSON:JSONObject];
                }

                completion([TRCurrentConditions currentConditionsFromJSON:JSON], historicalConditions);
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
    NSString *URLString = [TRForecastAPIBaseURL stringByAppendingFormat:@"%f,%f", latitude, longitude];
    if (yesterday) {
        NSTimeInterval timestamp = [[NSDate yesterday] timeIntervalSince1970];
        URLString = [URLString stringByAppendingString:[NSString stringWithFormat:@",%.0f", timestamp]];
    }

    NSURLComponents *components = [NSURLComponents componentsWithString:URLString];
    NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:@"exclude" value:TRForecastAPIExclusions];
    components.queryItems = @[item];

    return components.URL;
}

@end
