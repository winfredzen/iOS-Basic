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

@property (nonatomic, strong) NSThread *thread;

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
  
  //[self GCDTimer];
  
  //[NSThread detachNewThreadSelector:@selector(task) toTarget:self withObject:nil];
  
  [self observer];
  [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(task) userInfo:nil repeats:YES];
}

- (void)timerInThread{
  NSRunLoop *currentRunloop = [NSRunLoop currentRunLoop];
  [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
  //开启runloop
  [currentRunloop run];
}

#pragma mark - GCD定时器
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

#pragma mark - CFRunLoopObserverRef
-(void)task
{
  NSLog(@"%s",__func__);
  
  //    [NSRunLoop currentRunLoop] runUntilDate:[];
}

-(void)observer
{
  //1.创建监听者
  /*
   第一个参数:怎么分配存储空间
   第二个参数:要监听的状态 kCFRunLoopAllActivities 所有的状态
   第三个参数:时候持续监听
   第四个参数:优先级 总是传0
   第五个参数:当状态改变时候的回调
   */
  CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
    
    /*
     kCFRunLoopEntry = (1UL << 0),        即将进入runloop
     kCFRunLoopBeforeTimers = (1UL << 1), 即将处理timer事件
     kCFRunLoopBeforeSources = (1UL << 2),即将处理source事件
     kCFRunLoopBeforeWaiting = (1UL << 5),即将进入睡眠
     kCFRunLoopAfterWaiting = (1UL << 6), 被唤醒
     kCFRunLoopExit = (1UL << 7),         runloop退出
     kCFRunLoopAllActivities = 0x0FFFFFFFU
     */
    switch (activity) {
      case kCFRunLoopEntry:
        NSLog(@"即将进入runloop");
        break;
      case kCFRunLoopBeforeTimers:
        NSLog(@"即将处理timer事件");
        break;
      case kCFRunLoopBeforeSources:
        NSLog(@"即将处理source事件");
        break;
      case kCFRunLoopBeforeWaiting:
        NSLog(@"即将进入睡眠");
        break;
      case kCFRunLoopAfterWaiting:
        NSLog(@"被唤醒");
        break;
      case kCFRunLoopExit:
        NSLog(@"runloop退出");
        break;
        
      default:
        break;
    }
  });
  
  //添加Observer
  /*
   第一个参数:要监听哪个runloop
   第二个参数:观察者
   第三个参数:运行模式
   */
  CFRunLoopAddObserver(CFRunLoopGetCurrent(),observer, kCFRunLoopDefaultMode);
  
  //NSDefaultRunLoopMode == kCFRunLoopDefaultMode
  //NSRunLoopCommonModes == kCFRunLoopCommonModes
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - 线程常驻
- (IBAction)createBtnClick:(id)sender {
  //1.创建线程
  self.thread = [[NSThread alloc]initWithTarget:self selector:@selector(task1) object:nil];
  [self.thread start];
}
- (IBAction)otherBtnClick:(id)sender {
  //[self.thread start];
  [self performSelector:@selector(task2) onThread:self.thread withObject:nil waitUntilDone:YES];
}

-(void)task1
{
  NSLog(@"task1---%@",[NSThread currentThread]);
  //解决方法:开runloop
  //1.获得子线程对应的runloop
  NSRunLoop *runloop = [NSRunLoop currentRunLoop];
  //2.向runloop中添加timer或者source，不让runloop退出
  //NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
  //[runloop addTimer:timer forMode:NSDefaultRunLoopMode];
  [runloop addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
  //3.启动（默认是没有启动的）
  [runloop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:10]];
  //[runloop run];
  NSLog(@"---end----");
}

-(void)task2
{
  NSLog(@"task2---%@",[NSThread currentThread]);
}

@end
