//
//  GSPromising.m
//  TestPromiseKit
//
//  Created by beforeold on 2017/8/30.
//  Copyright © 2017年 beforeold. All rights reserved.
//

#import "GSPromising.h"

@implementation GSPromising

- (instancetype)initWithHandler:(GSPromiseHandler)handler {
    self = [super init];
    if (self) {
        _handler = [handler copy];
    }
    
    return self;
}

+ (instancetype)promise {
    return [[self alloc] initWithHandler:^(dispatch_block_t  _Nonnull ok) {
        ok();
    }];
}

+ (instancetype)promiseWithHandler:(GSPromiseHandler)handler {
    id instance = [[GSPromising alloc] initWithHandler:handler];
    
    return instance;
}

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"%@ dealloc", self);
#endif
}

@end

static NSInteger const GSPromiseIndexUnkown = -1;
@interface GSPromiseManager ()
{
    /// list of operating promises
    NSMutableArray<id<GSPromisable>> *container;
    NSInteger currentIndex;
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
    
    [self handleNextPromiseAfterIndex:currentIndex];
}

/// try to handle next operation
- (void)handleNextPromiseAfterIndex:(NSInteger)index {
    if (self.isWorking) return;
    
    NSUInteger count = container.count;
    if (!count) return;
    
    NSInteger nextIndex = GSPromiseIndexUnkown;
    id<GSPromisable> nextPromise = nil;
    if (index == GSPromiseIndexUnkown) {
        nextPromise = container.firstObject;
        nextIndex = 0;
        
    } else {
        nextIndex = index + 1;
        if (nextIndex < count) nextPromise = container[nextIndex];
    }
    
    if (!nextPromise) return;
    
    self.working = YES;
    currentIndex = nextIndex;
    
    // 此处使用 self 可以造成必要的循环引用
    nextPromise.handler(^{
        self.working = NO;
        [self handleNextPromiseAfterIndex:nextIndex];
    });
}

#pragma mark - initialiers
/// convinience initilizer
- (instancetype)initWithPromises:(NSArray<id<GSPromisable>> *)promises {
    self = [super init];
    if (self) {
        container = [[NSMutableArray alloc] initWithCapacity:3];
        [container addObjectsFromArray:promises ?: @[]];
        
        currentIndex = GSPromiseIndexUnkown;
        
        [self handleNextPromiseAfterIndex:currentIndex];
    }
    
    return self;
}

- (instancetype)initWithPromise:(id<GSPromisable>)promise {
    return [self initWithPromises:promise ? @[promise] : @[]];
}

- (instancetype)init {
    return [self initWithPromises:@[]];
}

+ (instancetype)manager {
    return [[self alloc] init];
}

+ (instancetype)manangerWithPromise:(id<GSPromisable>)promise {
    return [[self alloc] initWithPromise:promise];
}

+ (instancetype)manangerWithPromises:(NSArray<id<GSPromisable>> *)promises {
    return [[self alloc] initWithPromises:promises];
}

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"manager dealloc");
#endif
}

@end
