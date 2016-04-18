#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import "UIColor+TRTemperatureColors.h"

SpecBegin(UIColor_TRTemperatureColors)

describe(@"UIColor+TRTemperatureColors", ^{
    describe(@"lighterColorByAmount:", ^{
        it(@"blends with white", ^{
            UIColor *warmer = [UIColor warmerColor];

            UIColor *blendedColor = [warmer lighterColorByAmount:0.5];

            CGFloat hue, saturation, brightness, alpha;
            [blendedColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];

            expect(saturation).to.equal(0.5f);
            expect(brightness).to.beCloseToWithin(0.985, 0.001f);
        });
    });
});

SpecEnd
