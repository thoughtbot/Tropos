@import CoreLocation;
#import "TRForecastController.h"
#import "TRWeatherUpdate.h"
#import "NSDate+TRRelativeDate.h"

static NSString *const TRForecastAPIBaseURL = @"https://api.forecast.io/forecast/3df031c1b15c324d69d9f4ea8931e740/";
static NSString *const TRForecastAPIExclusions = @"minutely,hourly,alerts,flags";

@interface TRForecastController ()

@property (nonatomic) NSURLSession *session;

@end

@implementation TRForecastController

#pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPAdditionalHeaders = @{@"Accept": @"application/json"};
    configuration.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    self.session = [NSURLSession sessionWithConfiguration:configuration];

    return self;
}

#pragma mark - API

- (RACSignal *)fetchWeatherUpdateForPlacemark:(CLPlacemark *)placemark
{
    CLLocationCoordinate2D coordinate = placemark.location.coordinate;
    RACSignal *currentConditions = [self fetchConditionsFromURL:[self URLForCurrentConditionsAtLatitude:coordinate.latitude longitude:coordinate.longitude yesterday:NO]];
    RACSignal *yesterdaysConditions = [self fetchConditionsFromURL:[self URLForCurrentConditionsAtLatitude:coordinate.latitude longitude:coordinate.longitude yesterday:YES]];

    return [[RACSignal combineLatest:@[currentConditions, yesterdaysConditions] reduce:^id(id currentConditionsJSON, id yesterdaysConditionsJSON) {
        return [[TRWeatherUpdate alloc] initWithPlacemark:placemark currentConditionsJSON:currentConditionsJSON yesterdaysConditionsJSON:yesterdaysConditionsJSON];
    }] deliverOnMainThread];
}

#pragma mark - Private Helpers

- (RACSignal *)fetchConditionsFromURL:(NSURL *)URL
{
    return [[self fetchDataFromURL:URL] flattenMap:^RACStream *(NSData *data) {
        return [self parseJSONFromData:data];
    }];
}

- (RACSignal *)fetchDataFromURL:(NSURL *)URL
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionTask *task = [self.session dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                [subscriber sendError:error];
                return;
            }

            if (![self responseContainsSuccessfulStatusCode:response]) {
                [subscriber sendError:[NSError errorWithDomain:TRErrorDomain code:200 userInfo:nil]];
                return;
            }

            [subscriber sendNext:data];
            [subscriber sendCompleted];
        }];
        [task resume];

        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

- (RACSignal *)parseJSONFromData:(NSData *)data
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSError *error;
        id JSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

        if (!JSON) {
            [subscriber sendError:error];
        } else {
            [subscriber sendNext:JSON];
            [subscriber sendCompleted];
        }

        return nil;
    }];
}

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

- (BOOL)responseContainsSuccessfulStatusCode:(NSURLResponse *)response
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 99)];
    NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
    return [indexSet containsIndex:(NSUInteger)statusCode];
}

@end
