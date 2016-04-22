#import "RACSignal+TROperators.h"

@implementation RACSignal (TROperators)

- (RACSignal *)replayLastLazily
{
    RACMulticastConnection *connection = [self multicast:[RACReplaySubject replaySubjectWithCapacity:1]];
    return [[RACSignal defer:^{
        [connection connect];
        return connection.signal;
    }] setNameWithFormat:@"[%@] -replayLastLazily", self.name];
}

@end
