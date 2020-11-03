//
//  PersonPort.h
//  MultiThreadDemo
//
//  Created by nucarf on 2020/11/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonPort : NSObject

- (void)personLaunchThreadWithPort:(NSMachPort *)port;

@end

NS_ASSUME_NONNULL_END
