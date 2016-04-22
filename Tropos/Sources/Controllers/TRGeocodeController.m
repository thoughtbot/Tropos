@import CoreLocation;
#import "TRGeocodeController.h"

@interface TRGeocodeController ()

@property (nonatomic) CLGeocoder *geocoder;

@end

@implementation TRGeocodeController

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    self.geocoder = [CLGeocoder new];

    return self;
}

- (RACSignal *)reverseGeocodeLocation:(CLLocation *)location
{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)

        [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            if (!placemarks) {
                [subscriber sendError:error];
            } else {
                [subscriber sendNext:[placemarks firstObject]];
                [subscriber sendCompleted];
            }
        }];

        return nil;
    }];
}

@end
