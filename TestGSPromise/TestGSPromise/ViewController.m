//
//  ViewController.m
//  TestPromiseKit
//
//  Created by Brook on 2017/8/30.
//  Copyright © 2017年 Brook. All rights reserved.
//

#import "ViewController.h"

#import "GSPromise.h"
#import "TestManager.h"

@interface ViewController ()

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testPromise];
}

- (void)testPromise {
    GSPromise *a = [GSPromise promiseWithHandler:^(dispatch_block_t then){
        [TestManager doSomethingWithCompletion:^{
            NSLog(@"done a"); then();
        }];
    }];
    
    GSPromise *b = [GSPromise promiseWithHandler:^(dispatch_block_t then){
        [TestManager doSomethingWithCompletion:^{
            NSLog(@"done b"); then();
        }];
    }];
    
    GSPromise *c = [GSPromise promiseWithHandler:^(dispatch_block_t then){
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
