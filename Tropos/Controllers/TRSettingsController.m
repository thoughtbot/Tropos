#import "TRSettingsController.h"
#import "NSBundle+TRBundleInfo.h"

NSString *const TRSettingsDidChangeNotification = @"TRSettingsDidChangeNotification";
NSString *const TRSettingsUnitSystemKey = @"TRUnitSystem";
NSString *const TRSettingsLastVersionKey = @"TRLastVersion";

@interface TRSettingsController ()

@property (nonatomic) NSLocale *locale;
@property (nonatomic) RACSignal *userDefaultsChanged;

@end

@implementation TRSettingsController

#pragma mark - Initializers

- (instancetype)initWithLocale:(NSLocale *)locale
{
    self = [super init];
    if (!self) return nil;

    self.locale = locale;
    self.userDefaultsChanged = [[NSNotificationCenter defaultCenter] rac_addObserverForName:NSUserDefaultsDidChangeNotification object:nil];

    return self;
}

- (instancetype)init
{
    return [self initWithLocale:[NSLocale autoupdatingCurrentLocale]];
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
