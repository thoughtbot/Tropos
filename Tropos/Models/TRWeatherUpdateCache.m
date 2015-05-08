#import "TRWeatherUpdateCache.h"

static NSString *const TRLatestWeatherUpdateFileName = @"TRLatestWeatherUpdateFile";

@interface TRWeatherUpdateCache ()

@property (nonatomic) NSURL *latestWeatherUpdateURL;

@end

@implementation TRWeatherUpdateCache

- (instancetype)init
{
    self = [super init];
    if (!self) { return nil; }

    NSURL *documentsPath = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                  inDomains:NSUserDomainMask] firstObject];

    self.latestWeatherUpdateURL = [documentsPath URLByAppendingPathComponent:TRLatestWeatherUpdateFileName];

    return self;
}

- (TRWeatherUpdate *)latestWeatherUpdate
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self latestWeatherUpdateFilePath]];
}

- (BOOL)archiveWeatherUpdate:(TRWeatherUpdate *)update
{
    return [NSKeyedArchiver archiveRootObject:update toFile:[self latestWeatherUpdateFilePath]];
}

- (NSString *)latestWeatherUpdateFilePath
{
    return [self.latestWeatherUpdateURL path];
}

@end
