//
//  SystemTaskHelper.m
//  File@nx
//
//  Created by juliano on 12/30/16.
//  Copyright © 2016 Chindle. All rights reserved.
//

#import "SystemTaskHelper.h"

@implementation SystemTaskHelper
+(void)performSystemTask:(NSString *)task
{
    system([task UTF8String]);
}
@end
