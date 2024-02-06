//
//  WZViewController.m
//  CocoapodsFramework
//
//  Created by wangzhen on 02/06/2024.
//  Copyright (c) 2024 wangzhen. All rights reserved.
//

#import "WZViewController.h"
//@import CocoapodsFramework;

#import <CocoapodsFramework/CocoapodsFramework.h>

@interface WZViewController ()

@end

@implementation WZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    

    NSInteger result = [WZBase addWithA:1 b:2];
    NSLog(@"result = %ld", result);

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
