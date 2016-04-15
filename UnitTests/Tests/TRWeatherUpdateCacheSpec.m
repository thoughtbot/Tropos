@import CoreLocation;
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import "TRWeatherUpdate.h"
#import "TRWeatherUpdateCache.h"

@interface TRWeatherUpdateCache (Tests)

- (NSString *)latestWeatherUpdateFilePath;
- (NSURL *)latestWeatherUpdateURL;

@end

SpecBegin(TRWeatherUpdateCache)

CLPlacemark* (^stubbedPlacemark) () = ^CLPlacemark* {
    CLPlacemark *placemark = OCMClassMock([CLPlacemark class]);
    OCMStub([placemark locality]).andReturn(@"");
    OCMStub([placemark administrativeArea]).andReturn(@"");
    return placemark;
};

NSURL* (^weatherUpdateURLForTesting) () = ^NSURL* {
    NSURL *documentsPath = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                  inDomains:NSUserDomainMask] firstObject];
    return [documentsPath URLByAppendingPathComponent:@"TestWeatherUpdate"];
};

void (^resetFilesystem) () = ^{
    [[NSFileManager defaultManager] removeItemAtURL:weatherUpdateURLForTesting() error:nil];
};

describe(@"TRWeatherUpdateCache", ^{
    beforeEach(^{
        resetFilesystem();
    });

    context(@"-init", ^{
        it(@"sets the latestWeatherUpdateURL", ^{
            TRWeatherUpdateCache *cache = [[TRWeatherUpdateCache alloc] init];

            expect(cache.latestWeatherUpdateURL).toNot.beNil();
        });
    });

    context(@"-archiveLatestWeatherUpdate", ^{
        it(@"archives the object to disk", ^{
            NSURL *weatherUpdateURL = weatherUpdateURLForTesting();
            TRWeatherUpdateCache *cache = OCMPartialMock([[TRWeatherUpdateCache alloc] init]);
            OCMStub([cache latestWeatherUpdateFilePath]).andReturn([weatherUpdateURL path]);
            TRWeatherUpdate *update = [[TRWeatherUpdate alloc] initWithPlacemark:stubbedPlacemark() currentConditionsJSON:@{} yesterdaysConditionsJSON:@{}];

            [cache archiveWeatherUpdate:update];
            
            expect([[NSFileManager defaultManager] isReadableFileAtPath:[weatherUpdateURL path]]).to.equal(YES);
        });
    });

    context(@"-latestWeatherUpdate", ^{
        it(@"returns nil when not archived", ^{
            NSURL *weatherUpdateURL = weatherUpdateURLForTesting();
            TRWeatherUpdateCache *cache = OCMPartialMock([[TRWeatherUpdateCache alloc] init]);
            OCMStub([cache latestWeatherUpdateFilePath]).andReturn([weatherUpdateURL path]);

            TRWeatherUpdate* unarchivedWeatherUpdate = [cache latestWeatherUpdate];

            expect(unarchivedWeatherUpdate).to.beNil();
        });

        it(@"returns an initialized TRWeatherUpdate when archive exists", ^{
            NSURL *weatherUpdateURL = weatherUpdateURLForTesting();
            TRWeatherUpdateCache *cache = OCMPartialMock([[TRWeatherUpdateCache alloc] init]);
            OCMStub([cache latestWeatherUpdateFilePath]).andReturn([weatherUpdateURL path]);
            TRWeatherUpdate *update = [[TRWeatherUpdate alloc] initWithPlacemark:stubbedPlacemark() currentConditionsJSON:@{} yesterdaysConditionsJSON:@{}];
            [cache archiveWeatherUpdate:update];

            TRWeatherUpdate* unarchivedWeatherUpdate = [cache latestWeatherUpdate];

            expect(unarchivedWeatherUpdate).to.beInstanceOf([TRWeatherUpdate class]);
        });

        it(@"caches the date", ^{
            NSURL *weatherUpdateURL = weatherUpdateURLForTesting();
            TRWeatherUpdateCache *cache = OCMPartialMock([[TRWeatherUpdateCache alloc] init]);
            OCMStub([cache latestWeatherUpdateFilePath]).andReturn([weatherUpdateURL path]);
            NSDate *date = [NSDate date];
            TRWeatherUpdate *update = [[TRWeatherUpdate alloc] initWithPlacemark:stubbedPlacemark() currentConditionsJSON:@{} yesterdaysConditionsJSON:@{} date:date];
            [cache archiveWeatherUpdate:update];

            TRWeatherUpdate* unarchivedWeatherUpdate = [cache latestWeatherUpdate];

            expect(unarchivedWeatherUpdate.date).to.equal(date);
        });
    });
});

SpecEnd
