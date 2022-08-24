//
//  ViewController.m
//  TestPromiseKit
//
//  Created by beforeold on 2017/8/30.
//  Copyright © 2017年 beforeold. All rights reserved.
//

#import "ViewController.h"

#import "GSPromising.h"

#import "TestManager.h"

@interface ViewController ()

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testPromise];
}

- (void)testPromise {
    GSPromising *a = [GSPromising promiseWithHandler:^(dispatch_block_t then){
        [TestManager doSomethingWithCompletion:^{
            NSLog(@"done a"); then();
        }];
    }];
    
    GSPromising *b = [GSPromising promiseWithHandler:^(dispatch_block_t then){
        [TestManager doSomethingWithCompletion:^{
            NSLog(@"done b"); then();
        }];
    }];
    
    GSPromising *c = [GSPromising promiseWithHandler:^(dispatch_block_t then){
        [TestManager doSomethingWithCompletion:^{
            NSLog(@"done c"); then();
        }];
    }];
    
    GSPromiseManager *manager = [GSPromiseManager manangerWithPromises:@[a, b]];
    [manager addPromise:c];
}

- (void)callbackHell {
    [TestManager doSomethingWithCompletion:^{
        NSLog(@"No 1 done");
        [TestManager doSomethingWithCompletion:^{
            NSLog(@"No 2 done");
            [TestManager doSomethingWithCompletion:^{
                NSLog(@"No 3 done");
            }];
        }];
    }];
}

@end
