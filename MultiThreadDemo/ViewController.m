//
//  ViewController.m
//  MultiThreadDemo
//
//  Created by nucarf on 2020/10/20.
//

#import "ViewController.h"
#import "OperationExplore.h"
#import "ThreadExplore.h"
#import "GCDExplore.h"
#import "PortViewController.h"
#import "InterviewViewController.h"

#define NSLog(fmt, ...) fprintf(stderr, "\n%s", [[NSString stringWithFormat:fmt, ## __VA_ARGS__] UTF8String])

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"多线程探索";

//    ThreadExplore *op1 =  [[ThreadExplore alloc] init];
//    GCDExplore *op2 =  [[GCDExplore alloc] init];
//    OperationExplore *op3 =  [[OperationExplore alloc] init];
}

- (IBAction)buttonAction:(UIButton *)sender {
    switch (sender.tag) {
        case 100: {
            [ThreadExplore new];
            break;
        }
        case 101: {
            [OperationExplore new];
            break;
        }
        case 102: {
            [GCDExplore new];
            break;
        }
        case 103: {
            UIViewController *vc = [PortViewController new];
            [self.navigationController pushViewController:vc animated:YES];

            break;
        }
        case 104: {
            UIViewController *vc = [InterviewViewController new];
            [self.navigationController pushViewController:vc animated:YES];

            break;
        }

        default:
            break;
    }
}

@end
