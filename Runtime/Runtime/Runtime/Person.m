//
//  Person.m
//  Runtime
//
//  Created by 王振 on 2017/12/21.
//  Copyright © 2017年 wangzhen. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)eat
{
  NSLog(@"eat");
}

- (void)speak:(NSString *)something
{
  NSLog(@"speak %@", something);
}

@end
