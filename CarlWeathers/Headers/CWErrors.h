#ifndef CarlWeathers_CWErrors_h
#define CarlWeathers_CWErrors_h

static NSString * const CWErrorDomain = @"CarlWeathersErrorDomain";

typedef NS_ENUM(NSUInteger, CWError) {
    CWErrorLocationRestricted,
    CWErrorLocationDenied,
};

#endif
