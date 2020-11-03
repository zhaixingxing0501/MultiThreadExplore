//
//  PersonPort.m
//  MultiThreadDemo
//
//  Created by nucarf on 2020/11/3.
//

#import "PersonPort.h"

@interface PersonPort ()<NSPortDelegate>

@property (nonatomic, strong) NSPort *vcPort;
@property (nonatomic, strong) NSPort *myPort;

@end

@implementation PersonPort

- (void)personLaunchThreadWithPort:(NSPort *)port {
    NSLog(@"VC 响应了Person里面");
    //1. 保存主线程传入的port
    self.vcPort = port;
    //2. 设置子线程名字
    [[NSThread currentThread] setName:@"PersonThread"];
    //3. 开启runloop
    [[NSRunLoop currentRunLoop] run];

    //4. 创建自己port
    self.myPort = [NSMachPort port];
//    [[NSRunLoop currentRunLoop] addPort:self.myPort forMode:NSDefaultRunLoopMode];

    //5. 设置port的代理回调对象
    self.myPort.delegate = self;

    //6. 完成向主线程port发送消息
    [self sendPortMessage];
}

//- (NSPort *)myPort {
//    if (!_myPort) {
//        _myPort = [NSMachPort port];
//        _myPort.delegate = self;
//        [[NSRunLoop currentRunLoop] addPort:_myPort forMode:NSDefaultRunLoopMode];
//    }
//    return _myPort;
//}

/**
 *   完成向主线程发送port消息
 */

- (void)sendPortMessage {
    NSData *data1 = [@"数据1" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data2 = [@"数据2" dataUsingEncoding:NSUTF8StringEncoding];

    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:@[data1, data2, self.myPort]];
    // 发送消息到VC的主线程
    // 第一个参数：发送时间。
    // msgid 消息标识。
    // components，发送消息附带参数。
    // reserved：为头部预留的字节数
    BOOL res = [self.vcPort sendBeforeDate:[NSDate date]
                                     msgid:10086
                                components:array
                                      from:self.myPort
                                  reserved:0];

    NSLog(@"%d", res);
}

#pragma mark - NSMachPortDelegate

- (void)handlePortMessage:(NSPortMessage *)message {
    NSLog(@"person:handlePortMessage  == %@", [NSThread currentThread]);
    NSLog(@"从VC 传过来一些信息:");
//    NSLog(@"components == %@", [message valueForKey:@"components"]);
//    NSLog(@"receivePort == %@", [message valueForKey:@"receivePort"]);
//    NSLog(@"sendPort == %@", [message valueForKey:@"sendPort"]);
//    NSLog(@"msgid == %@", [message valueForKey:@"msgid"]);
}

@end
