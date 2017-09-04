//
//  Manager.m
//  TestPromiseKit
//
//  Created by Brook on 2017/8/30.
//  Copyright © 2017年 Brook. All rights reserved.
//

#import "TestManager.h"

@implementation TestManager

+ (void)doSomethingWithCompletion:(dispatch_block_t)completion {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion();
        });
    });
}

@end
