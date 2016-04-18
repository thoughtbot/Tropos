@import Quick;
@import Nimble;
#import "TRSettingsController.h"

QuickSpecBegin(TRSettingsControllerSpec)

void (^resetUserDefaults)(void) = ^{
    for (NSString *key in [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
};

describe(@"TRSettingsController", ^{
    describe(@"registered defaults", ^{
        beforeEach(resetUserDefaults);
        afterEach(resetUserDefaults);

        it(@"returns the correct value in an imperial locale", ^{
            TRSettingsController *controller = [[TRSettingsController alloc] initWithLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
            [controller registerSettings];
            expect(@([controller unitSystem])).to(equal(@(TRUnitSystemImperial)));
        });

        it(@"returns the correct value in a metric locale", ^{
            TRSettingsController *controller = [[TRSettingsController alloc] initWithLocale:[NSLocale localeWithLocaleIdentifier:@"en_AU"]];
            [controller registerSettings];
            expect(@([controller unitSystem])).to(equal(@(TRUnitSystemMetric)));
        });
    });

    describe(@"migration", ^{
        it(@"converts from a string unit system representation to an integer", ^{
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:TRSettingsUnitSystemKey];
            TRSettingsController *controller = [TRSettingsController new];
            expect(@([controller unitSystem])).to(equal(@(TRUnitSystemImperial)));
        });
    });
});

QuickSpecEnd
