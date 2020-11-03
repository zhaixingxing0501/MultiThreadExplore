//
//  OperationExplore.m
//  MultiThreadDemo
//
//  Created by nucarf on 2020/10/22.
//

#import "OperationExplore.h"

#define NSLog(fmt, ...) fprintf(stderr, "\n%s", [[NSString stringWithFormat:fmt, ## __VA_ARGS__] UTF8String])

@implementation OperationExplore

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initOperation];

        [self sketch];
    }
    return self;
}

- (void)initOperation {
//    // 创建对象
//    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(operationFunc1) object:nil];
//    // 开始执行
//    [op start];
//
//    [NSThread detachNewThreadWithBlock:^{
//        NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(operationFunc1) object:nil];
//        [op1 start];
//    }];

//    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
//        [NSThread sleepForTimeInterval:2];
//        NSLog(@"任务1: %@", [NSThread currentThread]);
//    }];
//
//    [op addExecutionBlock:^{
//        [NSThread sleepForTimeInterval:2];
//        NSLog(@"任务2: %@", [NSThread currentThread]);
//    }];
//
//    [op addExecutionBlock:^{
//        [NSThread sleepForTimeInterval:2];
//        NSLog(@"任务3: %@", [NSThread currentThread]);
//    }];
//
//    [op addExecutionBlock:^{
//        [NSThread sleepForTimeInterval:2];
//        NSLog(@"任务4: %@", [NSThread currentThread]);
//    }];
//
//    [op start];

//    // 主队列(主线程)
//    NSOperationQueue *queue0 = [NSOperationQueue mainQueue];
//
//    // 自定义队列, 添加到这中华队列中的操作, 会自动放到子线程执行
//    NSOperationQueue *queue1 = [NSOperationQueue mainQueue];
//    // 默认-1, 不限制,并发执行 , 为1时, 串行队列, 大于1: 并行队列
////    queue1.maxConcurrentOperationCount = 1;
//
//    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
//        [NSThread sleepForTimeInterval:2];
//        NSLog(@"任务1: %@", [NSThread currentThread]);
//    }];
//
//    [queue1 addOperation:op];
//
//    // 直接添加操作代码
//    [queue0 addOperationWithBlock:^{
//        [NSThread sleepForTimeInterval:2];
//        NSLog(@"任务2: %@", [NSThread currentThread]);
//    }];

//    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
//
//    [queue addOperationWithBlock:^{
//        [NSThread sleepForTimeInterval:2];
//        NSLog(@"任务1: %@", [NSThread currentThread]);
//
//        // 回到主线程
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            [NSThread sleepForTimeInterval:2];
//            NSLog(@"任务2: %@", [NSThread currentThread]);
//        }];
//    }];

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"任务1: %@", [NSThread currentThread]);
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"任务2: %@", [NSThread currentThread]);
    }];

    // 添加依赖
    // 让op2 依赖于 op1，则先执行op1，在执行op2
    [op2 addDependency:op1];

    // 添加操作到队列中
    [queue addOperation:op1];
    [queue addOperation:op2];
}

- (void)operationFunc1 {
    NSLog(@"%@", [NSThread currentThread]);
}

- (void)sketch {
}

@end
