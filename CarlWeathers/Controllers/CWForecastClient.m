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

- (RACSignal *)fetchConditionsAtLatitude:(double)latitude
                               longitude:(double)longitude
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURL *URL = [self URLForCurrentConditionsAtLatitude:latitude longitude:longitude yesterday:NO];
        NSURLSessionDataTask *task = [self.session dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            } else {
                id JSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

                if (!JSON) {
                    [subscriber sendError:error];
                } else {
                    CWCurrentConditions *conditions = [CWCurrentConditions currentConditionsFromJSON:JSON];
                    [subscriber sendNext:conditions];
                    [subscriber sendCompleted];
                }
            }
        }];

        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

- (RACSignal *)fetchHistoricalConditionsAtLatitude:(double)latitude
                                         longitude:(double)longitude
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURL *yesterdayURL = [self URLForCurrentConditionsAtLatitude:latitude longitude:longitude yesterday:YES];
        NSURLSessionDataTask *task = [self.session dataTaskWithURL:yesterdayURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            } else {
                id JSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

                if (!JSON) {
                    [subscriber sendError:error];
                } else {
                    CWHistoricalConditions *conditions = [CWHistoricalConditions historicalConditionsFromJSON:JSON];
                    [subscriber sendNext:conditions];
                    [subscriber sendCompleted];
                }
            }
        }];

        [task resume];

        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
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
