//
//  InterviewViewController.m
//  MultiThreadDemo
//
//  Created by nucarf on 2020/11/3.
//

#import "InterviewViewController.h"

@interface InterviewViewController ()

@end

@implementation InterviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    // Do any additional setup after loading the view.

    CFAbsoluteTime time = CFAbsoluteTimeGetCurrent();

    // OS_dispatch_queue_serial   DISPATCH_QUEUE_SERIAL = NULL
    dispatch_queue_t serial = dispatch_queue_create("star", DISPATCH_QUEUE_SERIAL); //#define DISPATCH_QUEUE_SERIAL NULL

    // OS_dispatch_queue_concurrent
    // OS_dispatch_queue_concurrent
    dispatch_queue_t conque = dispatch_queue_create("star", DISPATCH_QUEUE_CONCURRENT);
    // DISPATCH_QUEUE_SERIAL max && 1
    // queue 对象 alloc init class
    dispatch_queue_t mainQueue = dispatch_get_main_queue();

    dispatch_queue_t globQueue = dispatch_get_global_queue(0, 0);
    CFAbsoluteTime time1 = CFAbsoluteTimeGetCurrent() - time;

    
    NSLog(@"%@\n%@\n%@\n%@\n", serial, conque, mainQueue, globQueue);
    
    NSLog(@"创建线程耗时: %f", time1);

    [self wbinterDemo2];
//    [self kuaishouTest];
}

- (void)TestDemo {
//    dispatch_queue_t queue = dispatch_queue_create("star", DISPATCH_QUEUE_CONCURRENT);
//    NSLog(@"1");
//    dispatch_async(queue, ^{
//        NSLog(@"2");
//        dispatch_async(queue, ^{
//            NSLog(@"3");
//        });
//        NSLog(@"4");
//    });
//    NSLog(@"5");
//
//    //执行顺序 15243

    dispatch_queue_t queue = dispatch_queue_create("star1", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"1");
    dispatch_async(queue, ^{
        NSLog(@"2");

        dispatch_sync(queue, ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");

    //执行顺序 15234
}

//MARK: - 快手
- (void)kuaishouTest {
    dispatch_queue_t queue = dispatch_queue_create("star1", NULL);
    NSLog(@"1");
    dispatch_async(queue, ^{
        NSLog(@"2");

        dispatch_sync(queue, ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");

    //执行顺序  152 崩溃

/*
 分析:

 dispatch_async(queue, ^{  }); 是串行任务   执行顺序应该为 2  同步block 块  4
 串行队列:FIFO (先进先出)

 但是:   根据(快手面试解析.jpg) 任务4 等待 3 block 块执行完毕  而任务3 在等待任务 4 执行完成 这样就造成互相等待(死锁)

 */
}

//MARK: - 新浪

- (void)wbinterDemo2{
    
    dispatch_queue_t queue1 = dispatch_queue_create("com.sina.cn", DISPATCH_QUEUE_CONCURRENT);

    dispatch_async(queue1, ^{
        NSLog(@"1");
    });
    dispatch_async(queue1, ^{
        NSLog(@"2");
    });

    dispatch_barrier_async(queue1, ^{
        NSLog(@"3");
    
    });
    dispatch_async(queue1, ^{
        NSLog(@"4");
    });
    
    //执行顺序: (12)  3  4
    
    /*
      3 栅栏函数执行完成
     才会执行 4
     
     */
}
- (void)wbinterDemo1 {
    dispatch_queue_t queue = dispatch_queue_create("com.sina.cn", DISPATCH_QUEUE_CONCURRENT);

    dispatch_async(queue, ^{ // 耗时
        NSLog(@"1");
    });
    dispatch_async(queue, ^{
        NSLog(@"2");
    });

    // 堵塞哪一行
    dispatch_sync(queue, ^{
        NSLog(@"3");
    });

    NSLog(@"0");

    dispatch_async(queue, ^{
        NSLog(@"7");
    });
    dispatch_async(queue, ^{
        NSLog(@"8");
    });
    dispatch_async(queue, ^{
        NSLog(@"9");
    });

    // A: 1230789
    // B: 1237890
    // C: 3120798
    // D: 2137890

    /*
     分析:  123(无序)  并发执行

     3 阻塞 ,未执行完不再执行下一行
     故 0在 123(无序) 之后

     789 并发执行 无序



     分析可得  (123) 0 (789)
     可得选择 AC
     */
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
