#import "TRSettingsController+TRObservation.h"

@implementation TRSettingsController (TRObservation)

- (RACSignal *)unitSystemChanged
{
    return [[NSUserDefaults standardUserDefaults] rac_valuesForKeyPath:TRSettingsUnitSystemKey observer:self];
}

@end
