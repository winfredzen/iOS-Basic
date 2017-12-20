//
//  ViewController.m
//  RunLoop
//
//  Created by 王振 on 2017/12/19.
//  Copyright © 2017年 wangzhen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  NSRunLoop *mainRunLoop = [NSRunLoop mainRunLoop];
  NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
  
  NSLog(@"mainRunLoop : %p, currentRunLoop : %p", mainRunLoop, currentRunLoop);
  //mainRunLoop : 0x6040000affc0, currentRunLoop : 0x6040000affc0
  
  NSLog(@"%p", CFRunLoopGetMain());//0x6040001f1300
  NSLog(@"%p", CFRunLoopGetCurrent());//0x6040001f1300
  NSLog(@"%p", mainRunLoop.getCFRunLoop);//0x6040001f1300
  
//  [[[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil] start];
  
  
}

- (void)timer{
  NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
  //[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
  //[[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
  [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  //[NSThread detachNewThreadSelector:@selector(timerInThread) toTarget:self withObject:nil];
}

- (void)timerInThread{
  NSRunLoop *currentRunloop = [NSRunLoop currentRunLoop];
  [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
  //开启runloop
  [currentRunloop run];
}

//GCD定时器
- (void)GCDTimer{
  dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, <#dispatchQueue#>);
  dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, <#intervalInSeconds#> * NSEC_PER_SEC, <#leewayInSeconds#> * NSEC_PER_SEC);
  dispatch_source_set_event_handler(timer, ^{
    <#code to be executed when timer fires#>
  });
  dispatch_resume(timer);
}

- (void)run{
  NSLog(@"run-%@-%@", [NSThread currentThread], [NSRunLoop currentRunLoop].currentMode);
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
