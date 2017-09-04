//
//  GSPromise.m
//  TestPromiseKit
//
//  Created by Brook on 2017/8/30.
//  Copyright © 2017年 Brook. All rights reserved.
//

#import "GSPromise.h"
@implementation GSPromise
- (instancetype)initWithHandler:(GSPromiseHandler)handler {
    self = [super init];
    if (self) {
        _handler = [handler copy];
    }
    
    return self;
}

+ (instancetype)promiseWithHandler:(GSPromiseHandler)handler {
    id instance = [[GSPromise alloc] initWithHandler:handler];
    
    return instance;
}

@end

@interface GSPromiseManager ()
{
    /// list of operating promises
    NSMutableArray <id <GSPromisable>> *container;
}

/// whether manager is working, atomic
@property (getter=isWorking) BOOL working;

@end

@implementation GSPromiseManager
- (void)addPromise:(id<GSPromisable>)promise {
    NSParameterAssert(promise);
    NSParameterAssert(promise.handler);
    
    @synchronized (self) {
        [container addObject:promise];
    }
    
    [self try2Start];
}

/// try to handle next operation
- (void)try2Start {
    if (self.isWorking) return;
    
    id <GSPromisable> first = container.firstObject;
    if (!first) return;
    
    self.working = YES;
    dispatch_block_t then = ^{
        self.working = NO;
        
        @synchronized (self) {
            if (!container.firstObject) return;
            [container removeObjectAtIndex:0];
        }
        
        [self try2Start];
    };
    
    first.handler(then);
}

#pragma mark - initialiers
/// convinience initilizer
- (instancetype)initWithPromises:(NSArray <id <GSPromisable>> *)promises {
    self = [super init];
    if (self) {
        container = [[NSMutableArray alloc] initWithCapacity:3];
        [container addObjectsFromArray:promises ?: @[]];
        
        [self try2Start];
    }
    
    return self;
}

- (instancetype)initWithPromise:(id <GSPromisable>)promise {
    return [self initWithPromises:promise ? @[promise] : @[]];
}

- (instancetype)init {
    return [self initWithPromises:@[]];
}

+ (instancetype)manangerWithPromise:(id <GSPromisable>)promise {
    return [[self alloc] initWithPromise:promise];
}

+ (instancetype)manangerWithPromises:(NSArray <id <GSPromisable>> *)promises {
    return [[self alloc] initWithPromises:promises];
}

@end
