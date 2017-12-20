//
//  ViewController.m
//  RunLoop
//
//  Created by 王振 on 2017/12/19.
//  Copyright © 2017年 wangzhen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) dispatch_source_t timer;

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
  
  [self GCDTimer];
}

- (void)timerInThread{
  NSRunLoop *currentRunloop = [NSRunLoop currentRunLoop];
  [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
  //开启runloop
  [currentRunloop run];
}

//GCD定时器
- (void)GCDTimer{
  //1.创建GCD中的定时器
  /**
   *第一个参数：source的类型，DISPATCH_SOURCE_TYPE_TIMER表示定时器
   *第二个参数：描述信息，线程ID
   *第三个参数：更详细描述信息
   *第四个参数：队列，决定GCD定时器中的任务在哪个线程中执行的
   */
  dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
  //2.设置定时器（起始时间，间隔时间，精准度）
  /**
   *第一个参数：定时器对象
   *第二个参数：起始时间，DISPATCH_TIME_NOW表示从现在开始计时
   *第三个参数：间隔时间，GCD中时间是以纳秒为单位的
   *第四个参数：精准度，如果想绝对精准，传0
   */
  dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
  //3.设置定时器任务
  dispatch_source_set_event_handler(timer, ^{
    NSLog(@"CurrentThread: %@", [NSThread currentThread]);
  });
  //4.启动执行
  dispatch_resume(timer);
  
  self.timer = timer;
}

- (void)run{
  NSLog(@"run-%@-%@", [NSThread currentThread], [NSRunLoop currentRunLoop].currentMode);
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
