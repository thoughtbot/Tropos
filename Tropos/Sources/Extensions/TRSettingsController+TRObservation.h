#import <ReactiveObjC/ReactiveObjC.h>
#import <TroposCore/TroposCore.h>

@interface TRSettingsController (TRObservation)

- (RACSignal *)unitSystemChanged;

@end
