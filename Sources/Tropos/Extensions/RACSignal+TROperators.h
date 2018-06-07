#import <ReactiveObjC/ReactiveObjC.h>

@interface RACSignal (TROperators)

/// Multicasts the signal to a subject with capicity 1, then lazily
/// connects to the resulting RACMulticastConnection.
- (RACSignal *)replayLastLazily;

@end
