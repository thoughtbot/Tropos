#import "TRSettingsController.h"
#import "NSBundle+TRBundleInfo.h"

NSString *const TRSettingsDidChangeNotification = @"TRSettingsDidChangeNotification";
static NSString *const TRSettingsUnitSystemKey = @"TRUnitSystem";
static NSString *const TRSettingsLastVersionKey = @"TRLastVersion";

@implementation TRSettingsController

#pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDefaultsDidChange:) name:NSUserDefaultsDidChangeNotification object:nil];

    return self;
}

#pragma mark - NSObject

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUserDefaultsDidChangeNotification object:nil];
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
    return [[[NSUserDefaults standardUserDefaults] stringForKey:TRSettingsUnitSystemKey] integerValue];
}

- (void)setUnitSystem:(TRUnitSystem)unitSystem
{
    NSString *systemString = [NSString stringWithFormat:@"%zd", unitSystem];
    [[NSUserDefaults standardUserDefaults] setObject:systemString forKey:TRSettingsUnitSystemKey];
}

#pragma mark - Private

- (void)registerUnitSystem
{
    BOOL localeUsesMetric = [[[NSLocale currentLocale] objectForKey:NSLocaleUsesMetricSystem] boolValue];
    TRUnitSystem unitSystem = localeUsesMetric? TRUnitSystemMetric : TRUnitSystemImperial;
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{TRSettingsUnitSystemKey: @(unitSystem)}];
}

- (void)registerLastVersion
{
    NSString *version = [[NSBundle mainBundle] versionNumber];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{TRSettingsLastVersionKey: version}];
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:TRSettingsLastVersionKey];
}

- (void)userDefaultsDidChange:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TRSettingsDidChangeNotification object:nil];
}

@end
