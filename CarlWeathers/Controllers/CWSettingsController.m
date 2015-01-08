#import "CWSettingsController.h"
#import "NSBundle+CWBundleInfo.h"

NSString *const CWSettingsDidChangeNotification = @"CWSettingsDidChangeNotification";
static NSString *const CWSettingsUnitSystemKey = @"CWUnitSystem";
static NSString *const CWSettingsLastVersionKey = @"CWLastVersion";

@implementation CWSettingsController

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

- (CWUnitSystem)unitSystem
{
    return [[[NSUserDefaults standardUserDefaults] stringForKey:CWSettingsUnitSystemKey] integerValue];
}

- (void)setUnitSystem:(CWUnitSystem)unitSystem
{
    NSString *systemString = [NSString stringWithFormat:@"%zd", unitSystem];
    [[NSUserDefaults standardUserDefaults] setObject:systemString forKey:CWSettingsUnitSystemKey];
}

#pragma mark - Private

- (void)registerUnitSystem
{
    BOOL localeUsesMetric = [[[NSLocale currentLocale] objectForKey:NSLocaleUsesMetricSystem] boolValue];
    CWUnitSystem unitSystem = localeUsesMetric? CWUnitSystemMetric : CWUnitSystemImperial;
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{CWSettingsUnitSystemKey: @(unitSystem)}];
}

- (void)registerLastVersion
{
    NSString *version = [[NSBundle mainBundle] versionNumber];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{CWSettingsLastVersionKey: version}];
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:CWSettingsLastVersionKey];
}

- (void)userDefaultsDidChange:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CWSettingsDidChangeNotification object:nil];
}

@end
