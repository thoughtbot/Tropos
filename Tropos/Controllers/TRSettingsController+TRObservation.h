#import <ReactiveCocoa/ReactiveCocoa.h>
#import "TRSettingsController.h"

@interface TRSettingsController (TRObservation)

- (RACSignal *)unitSystemChanged;

@end
