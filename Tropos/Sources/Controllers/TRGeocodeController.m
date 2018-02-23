#import "Tropos-Swift.h"
#import "TRGeocodeController.h"

@interface TRGeocodeController ()

@property (nonatomic) id<TRGeocoder> geocoder;

@end

@implementation TRGeocodeController

- (instancetype)initWithGeocoder:(id<TRGeocoder>)geocoder
{
    self = [super init];
    if (!self) return nil;

    self.geocoder = geocoder;

    return self;
}

- (instancetype)init
{
    return [self initWithGeocoder:[CLGeocoder new]];
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
