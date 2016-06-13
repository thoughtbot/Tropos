@import CoreLocation;
@import Quick;
@import Nimble;
#import <OCMock/OCMock.h>
#import "TRApplicationController.h"
#import "TRWeatherController.h"
#import "TRLocationController.h"
#import "UnitTests-Swift.h"

@interface TRApplicationController (Tests)

@property (nonatomic) TRWeatherController *weatherController;
@property (nonatomic) TRLocationController *locationController;

@end

@interface TRWeatherController (Tests)

@property (nonatomic) RACCommand *updateWeatherCommand;

@end

void inTimeZone(NSTimeZone *timeZone, void (^callback)(void)) {
    NSTimeZone *defaultTimeZone = [NSTimeZone defaultTimeZone];
    [NSTimeZone setDefaultTimeZone:timeZone];
    callback();
    [NSTimeZone setDefaultTimeZone:defaultTimeZone];
}

QuickSpecBegin(TRApplicationControllerSpec)

TRLocationController* (^locationControllerWithAuthorizationStatusAuthorizedAlwaysEqualTo) (BOOL) = ^TRLocationController* (BOOL enabled){
    TRLocationController *locationController = OCMPartialMock([[TRLocationController alloc] init]);
    OCMStub([locationController authorizationStatusEqualTo:kCLAuthorizationStatusAuthorizedAlways]).andReturn(enabled);
    return locationController;
};

describe(@"TRApplicationController", ^{
    describe(@"setMinimimBackgroundFetchIntervalForApplication:", ^{
        it(@"sets the interval to minimum when authorization is always", ^{
            UIApplication *application = OCMClassMock([UIApplication class]);
            TRApplicationController *applicationController = [TRApplicationController new];
            applicationController.locationController = locationControllerWithAuthorizationStatusAuthorizedAlwaysEqualTo(YES);

            [applicationController setMinimumBackgroundFetchIntervalForApplication:application];

            OCMVerify([application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum]);
        });

        it(@"sets the interval to never when authorization is not always", ^{
            UIApplication *application = OCMClassMock([UIApplication class]);
            TRApplicationController *applicationController = [TRApplicationController new];
            applicationController.locationController = locationControllerWithAuthorizationStatusAuthorizedAlwaysEqualTo(NO);

            [applicationController setMinimumBackgroundFetchIntervalForApplication:application];

            OCMVerify([application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalNever]);
        });
    });

    describe(@"performBackgroundFetch:", ^{
        it(@"executes the weatherControllers's updateWeatherCommand", ^{
            RACCommand *updateWeatherCommand = OCMClassMock([RACCommand class]);
            TRApplicationController *applicationController = [TRApplicationController new];
            applicationController.weatherController.updateWeatherCommand = updateWeatherCommand;

            [applicationController updateWeather];

            OCMVerify([updateWeatherCommand execute:applicationController]);
        });
    });

    describe(@"subscribeForNotificationsWithDeviceToken:", ^{
        it(@"subscribes to notifications on the channel corresponding to the device's time zone", ^{
            TRCourierClient *courier = OCMClassMock([TRCourierClient class]);
            TRApplicationController *applicationController = [TRApplicationController new];
            applicationController.courier = courier;

            NSData *deviceToken = [NSData new];
            [applicationController subscribeToNotificationsWithDeviceToken:deviceToken];

            NSString *channel = [TRCourierClient channelNameForTimeZone:[NSTimeZone localTimeZone]];
            OCMVerify([courier subscribeToChannel:channel withToken:deviceToken]);
        });

        it(@"unsubscribes from notifications if the device's time zone has changed", ^{
            TRCourierClient *courier = OCMClassMock([TRCourierClient class]);
            TRApplicationController *applicationController = [TRApplicationController new];
            applicationController.courier = courier;
            NSTimeZone *initialTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"CEST"];
            NSString *expectedChannel = [TRCourierClient channelNameForTimeZone: initialTimeZone];
            NSData *deviceToken = [NSData new];

            inTimeZone(initialTimeZone, ^{
                [applicationController subscribeToNotificationsWithDeviceToken:deviceToken];
            });
            inTimeZone([NSTimeZone timeZoneWithAbbreviation:@"HKT"], ^{
                [applicationController subscribeToNotificationsWithDeviceToken:deviceToken];
            });

            OCMVerify([courier unsubscribeFromChannel:expectedChannel]);
        });
    });
});

QuickSpecEnd
