#import <Mixpanel/Mixpanel.h>
#import "TRAnalyticsController.h"

#ifndef DEBUG
#import "Secrets.h"
#endif

#define DISABLE_MIXPANEL_AB_DESIGNER

@implementation TRAnalyticsController

#pragma mark - Initialization

+ (instancetype)sharedController
{
    static TRAnalyticsController *controller;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [TRAnalyticsController new];
    });
    return controller;
}

#pragma mark - API

- (void)install
{
#ifndef DEBUG
    [Mixpanel sharedInstanceWithToken:TRMixpanelToken];
#endif
}

- (void)trackEventNamed:(NSString *)eventName
{
    [[Mixpanel sharedInstance] track:eventName];
}

- (void)trackEvent:(id<TRAnalyticsEvent>)event
{
    [[Mixpanel sharedInstance] track:event.eventName properties:event.eventProperties];
}

- (void)trackError:(NSError *)error eventName:(NSString *)eventName
{
    [[Mixpanel sharedInstance] track:eventName properties:[self propertiesForError:error]];
}

#pragma mark - Private

- (NSDictionary *)propertiesForError:(NSError *)error
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if (error.domain) dictionary[@"ErrorDomain"] = error.domain;
    if (error.code) dictionary[@"ErrorCode"] = @(error.code);
    if (error.userInfo.count > 0) [dictionary addEntriesFromDictionary:error.userInfo];
    return [dictionary copy];
}

@end
