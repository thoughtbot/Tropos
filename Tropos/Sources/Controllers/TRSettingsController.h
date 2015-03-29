#import "TRSettingsController.h"
#import "NSBundle+TRBundleInfo.h"

NSString *const TRSettingsDidChangeNotification = @"TRSettingsDidChangeNotification";
static NSString *const TRSettingsUnitSystemKey = @"TRUnitSystem";
static NSString *const TRSettingsLastVersionKey = @"TRLastVersion";

@interface TRSettingsController ()

@property (nonatomic) RACSignal *userDefaultsChanged;

@end

@implementation TRSettingsController

#pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    self.userDefaultsChanged = [[NSNotificationCenter defaultCenter] rac_addObserverForName:NSUserDefaultsDidChangeNotification object:nil];

    return self;
}

#pragma mark - Properties

- (RACSignal *)unitSystemChanged
{
    return [[[self.userDefaultsChanged filter:^BOOL(NSNotification *notification) {
        return [notification.name isEqualToString:NSUserDefaultsDidChangeNotification];
    }] map:^id(id value) {
        return @([self unitSystem]);
    }] startWith:@([self unitSystem])];
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

@end