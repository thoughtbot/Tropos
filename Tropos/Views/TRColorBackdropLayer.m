#import "TRColorBackdropLayer.h"
#import "UIImage+TRColorBackdrop.h"

@implementation TRColorBackdropLayer

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    self.actions = @{@"bounds": [NSNull null]};
    self.backgroundColor = [[UIColor colorWithPatternImage:[UIImage colorBackdropImage]] CGColor];

    return self;
}

@end
