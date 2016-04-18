#import <ReactiveCocoa/ReactiveCocoa.h>
#import "Tropos-Swift.h"

@interface TRSettingsController (TRObservation)

- (RACSignal *)unitSystemChanged;

@end
