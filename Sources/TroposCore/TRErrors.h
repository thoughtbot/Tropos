@import Foundation;

static NSString * const TRErrorDomain = @"TroposErrorDomain";

typedef NS_ENUM(NSInteger, TRError) {
    TRErrorLocationUnauthorized,

    TRErrorConditionsResponseFailed = 200,
    TRErrorConditionsResponseLocationNotFound,
    TRErrorConditionsResponseUnexpectedFormat,
};
