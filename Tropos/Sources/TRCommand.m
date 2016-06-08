//
//  TRCommand.m
//  Tropos
//
//  Created by Klaas Pieter Annema on 07-06-16.
//  Copyright © 2016 thoughtbot. All rights reserved.
//

#import "TRCommand.h"

@implementation TRCommand

- (RACSignal *)execute:(id)input;
{
    return [super execute:input];
}

@end
