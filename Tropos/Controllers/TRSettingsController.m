#import "TRSettingsController.h"
#import "NSBundle+TRBundleInfo.h"

NSString *const TRSettingsDidChangeNotification = @"TRSettingsDidChangeNotification";
NSString *const TRSettingsUnitSystemKey = @"TRUnitSystem";
NSString *const TRSettingsLastVersionKey = @"TRLastVersion";

@interface TRSettingsController ()

@property (nonatomic) NSLocale *locale;

@end

@implementation TRSettingsController

#pragma mark - Initializers

- (instancetype)initWithLocale:(NSLocale *)locale
{
    self = [super init];
    if (!self) return nil;

    self.locale = locale;

    return self;
}

- (instancetype)init
{
    return [self initWithLocale:[NSLocale autoupdatingCurrentLocale]];
}

#pragma mark - Public Methods

- (void)registerSettings
{
    [self registerUnitSystem];
    [self registerLastVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (TRUnitSystem)unitSystem
{
    return (TRUnitSystem)[[NSUserDefaults standardUserDefaults] integerForKey:TRSettingsUnitSystemKey];
}

- (void)setUnitSystem:(TRUnitSystem)unitSystem
{
    [[NSUserDefaults standardUserDefaults] setInteger:(NSInteger)unitSystem forKey:TRSettingsUnitSystemKey];
}

#pragma mark - Private

- (void)registerUnitSystem
{
    BOOL localeUsesMetric = [[self.locale objectForKey:NSLocaleUsesMetricSystem] boolValue];
    TRUnitSystem unitSystem = localeUsesMetric? TRUnitSystemMetric : TRUnitSystemImperial;
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{TRSettingsUnitSystemKey: @(unitSystem)}];
}

- (void)registerLastVersion
{
    NSString *version = [[NSBundle mainBundle] versionNumber];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{TRSettingsLastVersionKey: version}];
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:TRSettingsLastVersionKey];
}

@end
