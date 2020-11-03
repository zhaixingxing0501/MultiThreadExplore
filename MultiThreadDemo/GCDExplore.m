//
//  GCDExplore.m
//  MultiThreadDemo
//
//  Created by nucarf on 2020/10/22.
//

#import "GCDExplore.h"
#define NSLog(fmt, ...) fprintf(stderr, "\n%s", [[NSString stringWithFormat:fmt, ## __VA_ARGS__] UTF8String])


@interface GCDExplore ()
{
    dispatch_semaphore_t _semaphoreLock;
}

@property (nonatomic, assign) NSInteger ticketsCount;


@end

@implementation GCDExplore

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupGCD];
    }
    return self;
}

- (void)setupGCD {
    // @param label 队列的唯一标识符,队列的名称推荐使用应用程序id这种逆序全程域名
    // @param attr 用来识别是串行队列还是并发队列 (DISPATCH_QUEUE_SERIAL, DISPATCH_QUEUE_CONCURRENT)
    // dispatch_queue_t dispatch_queue_create(const char *_Nullable label, dispatch_queue_attr_t _Nullable attr);

//    // 串行队列
//    dispatch_queue_t serialQueue = dispatch_queue_create("com.appleid.functionA", DISPATCH_QUEUE_SERIAL);
//    // 并发队列
//    dispatch_queue_t concurrentlQueue = dispatch_queue_create("com.appleid.functionB", DISPATCH_QUEUE_CONCURRENT);
//    // 主队列
//    dispatch_queue_t mainQueue = dispatch_get_main_queue();
//    // 全局并发队列 (参数0: 填写默认 , 参数1: 填写0)
//    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//
//    dispatch_queue_t queue = dispatch_queue_create("com.appleid.functionA", DISPATCH_QUEUE_SERIAL);
//
//    dispatch_sync(queue, ^{
//        // 同步执行任务
//        // code snippet
//    });
//    dispatch_async(queue, ^{
//        // 异步执行任务
//        // code snippet
//    });

//    [self after];
//    [self barrier];
//    [self apply];

//    [self group];
    [self semaphor];
}

- (void)semaphor {
//    NSLog(@"当前线程:%@", [NSThread currentThread]);
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//
//    dispatch_async(queue, ^{
//        [NSThread sleepForTimeInterval:2];
//        NSLog(@"任务1, %@", [NSThread currentThread]);
//
//        dispatch_semaphore_signal(semaphore);
//    });
//    NSLog(@"当前线程1:%@", [NSThread currentThread]);
//
//    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//    NSLog(@"任务完成");

    self.ticketsCount = 50;

    dispatch_queue_t windowA = dispatch_queue_create("com.appleid.functionA", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t windowB = dispatch_queue_create("com.appleid.functionB", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t windowC = dispatch_queue_create("com.appleid.functionC", DISPATCH_QUEUE_CONCURRENT);

    __weak typeof(self) weakSelf = self;
    dispatch_async(windowA, ^{
        [weakSelf saleTicket1];
    });

    dispatch_async(windowB, ^{
        [weakSelf saleTicket1];
    });

    dispatch_async(windowC, ^{
        [weakSelf saleTicket1];
    });
    _semaphoreLock = dispatch_semaphore_create(1);
}

- (void)saleTicket1 {
    while (1) {
//        dispatch_semaphore_wait(_semaphoreLock, DISPATCH_TIME_FOREVER);

        if (self.ticketsCount > 0) {
            self.ticketsCount--;
            NSLog(@"%@, %ld", [NSThread currentThread], (long)self.ticketsCount);
            [NSThread sleepForTimeInterval:0.1];
        } else {
            NSLog(@"所有火车票均已售完");
//            dispatch_semaphore_signal(_semaphoreLock);

            break;
        }

//        dispatch_semaphore_signal(_semaphoreLock);
    }
}

- (void)group1 {
    dispatch_group_t group = dispatch_group_create();

    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"任务1, %@", [NSThread currentThread]);
        dispatch_group_leave(group);
    });

    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"任务2, %@", [NSThread currentThread]);
        dispatch_group_leave(group);
    });

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步任务 1、任务 2 都执行完毕后，回到主线程执行下边任务
        [NSThread sleepForTimeInterval:2];
        NSLog(@"任务3, %@", [NSThread currentThread]);
        NSLog(@"group任务完成");
    });
}

- (void)group {
    dispatch_group_t group = dispatch_group_create();

    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"任务1, %@", [NSThread currentThread]);
    });

    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"任务2, %@", [NSThread currentThread]);
    });

    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"group任务完成");

//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        // 等前面的异步任务 1、任务 2 都执行完毕后，回到主线程执行下边任务
//        [NSThread sleepForTimeInterval:2];
//        NSLog(@"任务3, %@", [NSThread currentThread]);
//        NSLog(@"group任务完成");
//    });
}

- (void)apply {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    // dispatch_apply是同步的
    dispatch_apply(10, queue, ^(size_t index) {
        NSLog(@"同步index:%zu %@", index, [NSThread currentThread]);
    });

    // 如果想异步,包装一层
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_apply(10, queue, ^(size_t index) {
            NSLog(@"异步index:%zu %@", index, [NSThread currentThread]);
        });
    });
}

- (void)after {
    NSLog(@"当前线程%@", [NSThread currentThread]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"after:%@", [NSThread currentThread]);  // 打印当前线程
    });
}

- (void)once {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 只执行一次, 默认线程安全
        // code snippet
    });
}

- (void)barrier {
    dispatch_queue_t queue = dispatch_queue_create("com.appleid.functionA", DISPATCH_QUEUE_CONCURRENT);

    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"任务1, %@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"任务2, %@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"任务3, %@", [NSThread currentThread]);
    });

    dispatch_barrier_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"barrier任务4, %@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"任务5, %@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"任务6, %@", [NSThread currentThread]);
    });
}



@end
