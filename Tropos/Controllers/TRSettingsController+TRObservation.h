#import <ReactiveCocoa/ReactiveCocoa.h>
#import <TroposCore/TroposCore.h>

@interface TRSettingsController (TRObservation)

- (RACSignal *)unitSystemChanged;

@end
