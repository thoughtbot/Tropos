//
//  CWForecastClient.m
//  CarlWeathers
//
//  Created by Mark Adams on 12/11/14.
//  Copyright (c) 2014 thoughtbot. All rights reserved.
//

#import "CWForecastClient.h"

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
    _session = [NSURLSession sessionWithConfiguration:configuration];

    return self;
}

- (void)fetchCurrentConditionsAtLatitude:(double)latitude longitude:(double)longitude completion:(CWCurrentConditionsResult)completion
{
    NSURL *URL = [self URLForCurrentConditionsAtLatitude:latitude longitude:longitude];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        id JSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

        if (completion) {
            completion(JSON);
        }
    }];
    [dataTask resume];
}

#pragma mark - Private Helpers

- (NSURL *)URLForCurrentConditionsAtLatitude:(double)latitude longitude:(double)longitude
{
    NSString *URLString = [CWForecastAPIBaseURL stringByAppendingFormat:@"%f,%f", latitude, longitude];
    return [NSURL URLWithString:URLString];
}

- (NSURL *)URLForConditionsAtLatitude:(double)latitude longitude:(double)longitude time:(NSTimeInterval)time
{
    NSString *URLString = [CWForecastAPIBaseURL stringByAppendingFormat:@"%f,%f,%f", latitude, longitude, time];
    return [NSURL URLWithString:URLString];
}

@end
