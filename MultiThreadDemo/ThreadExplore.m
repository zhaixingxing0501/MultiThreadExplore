//
//  ThreadExplore.m
//  MultiThreadDemo
//
//  Created by nucarf on 2020/10/22.
//

#import "ThreadExplore.h"

#define NSLog(fmt, ...) fprintf(stderr, "\n%s", [[NSString stringWithFormat:fmt, ## __VA_ARGS__] UTF8String])


@implementation ThreadExplore

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupNSThread];
    }
    return self;
}

- (void)setupNSThread {
    //创建线程
//    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(threadFunction1:) object:@"初始化: thread"];
//
//    NSThread *thread2 = [[NSThread alloc] initWithBlock:^{
//        NSLog(@"初始化: thread2");
//    }];
//    NSThread *thread3 = [[NSThread alloc] init];
//
//    // 由于静态方法没有返回值，如果需要获取新创建的thread，需要在selector中调用获取当前线程的方法
//    [NSThread detachNewThreadSelector:@selector(threadFunction2:) toTarget:self withObject:@"静态创建"];
//
//    thread1.name = @"thread";
//    //设置线程优先级
//    thread1.qualityOfService = NSQualityOfServiceBackground;
//    // 线程开始
//    [thread1 start];
//    // 线程取消
////    [thread cancel];
//
////    // 线程停止 停止方法会立即终止除主线程以外所有线程（无论是否在执行任务）并退出，需要在掌控所有线程状态的情况下调用此方法，
////    [NSThread exit];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(threadExit) name:NSThreadWillExitNotification object:nil];
    // 票数20
    self.ticketsCount = 20;

    NSThread *windowA = [[NSThread alloc] initWithTarget:self selector:@selector(threadWindowA) object:nil];
    windowA.name = @"窗口A";
    [windowA start];

    NSThread *windowB = [[NSThread alloc] initWithTarget:self selector:@selector(threadWindowB) object:nil];
    windowB.name = @"窗口B";
    [windowB start];

    [self performSelector:@selector(saleTicket) onThread:windowA withObject:nil waitUntilDone:NO];
    [self performSelector:@selector(saleTicket) onThread:windowB withObject:nil waitUntilDone:NO];
}

- (void)threadWindowA {
    NSRunLoop *runLoop1 = [NSRunLoop currentRunLoop];
    //一直运行
    [runLoop1 runUntilDate:[NSDate date]];
}

- (void)threadWindowB {
    NSRunLoop *runLoop2 = [NSRunLoop currentRunLoop];
    //自定义运行时间
    [runLoop2 runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:12.0]];
}

// 售票
- (void)saleTicket {
    //线程启动后，执行saleTicket，执行完毕后就会退出，为了模拟持续售票的过程，

    while (1) {
        // 添加同步锁
        if (self.ticketsCount > 0) {
            self.ticketsCount--;

            NSLog(@"%@, %ld", [NSThread currentThread].name, (long)self.ticketsCount);
            [NSThread sleepForTimeInterval:0.2];
        } else {
            //如果已卖完，关闭售票窗口
            if ([NSThread currentThread].isCancelled) {
                break;
            } else {
                NSLog(@"售卖完毕");
                //自定义线程停止时机

                //给当前线程标记为取消状态
                [[NSThread currentThread] cancel];
                //停止当前线程的runLoop
                CFRunLoopStop(CFRunLoopGetCurrent());
            }
        }
    }
}

- (void)threadExit {
    NSLog(@"线程退出:%@", [NSThread currentThread].name);
}

- (void)threadFunction {
}

- (void)threadFunction1:(NSString *)object {
    NSLog(@"%@", object);

    // 是否是主线程
    [NSThread isMainThread];
    // 设置为主线程
    [NSThread mainThread];
    // 获取当前线程
    [NSThread currentThread];
    // 设置线程优先级
    [NSThread currentThread].qualityOfService = NSQualityOfServiceBackground;

    NSLog(@"是否是主线程:%d", [NSThread isMainThread]);
    NSLog(@"主线程:%@", [NSThread mainThread]);
    NSLog(@"当前线程:%@", [NSThread currentThread]);

    NSLog(@"线程优先级:%ld", (long)[[NSThread currentThread] qualityOfService]);

    // 线程暂停
    [NSThread sleepForTimeInterval:1.0];//（以暂停一秒为例）
    [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    NSLog(@"%@", object);
}

- (void)threadFunction2:(NSString *)object {
    NSLog(@"%@", object);
    NSLog(@"当前线程:%@", [NSThread currentThread]);
    NSLog(@"线程优先级:%ld", (long)[[NSThread currentThread] qualityOfService]);
}

@end
