//
//  ViewController.m
//  Runtime
//
//  Created by 王振 on 2017/12/21.
//  Copyright © 2017年 wangzhen. All rights reserved.
//

#import "ViewController.h"
#import <objc/message.h>
#import "Person.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  Person *p = [[Person alloc] init];
  [p eat];
  NSLog(@"%@", [p class]);
  
  Person *p1 = objc_msgSend(objc_getClass("Person"), sel_registerName("alloc"));
  p1 = objc_msgSend(p1, sel_registerName("init"));
  //调用eat方法
  objc_msgSend(p1, @selector(eat));
  
  objc_msgSend(p1, @selector(speak:), @"hello");
  
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
