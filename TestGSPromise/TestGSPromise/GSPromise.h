//
//  GSPromise.h
//  TestPromiseKit
//
//  Created by Brook on 2017/8/30.
//  Copyright © 2017年 Brook. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 what a promise will execute

 @param then should call this block after promise done
 */
typedef void(^GSPromiseHandler)(dispatch_block_t then);

@protocol GSPromisable <NSObject>
/**
 the handler which a promise should retain
 */
@property (nonatomic, copy) GSPromiseHandler handler;

@end

/**
 GSPromise ecapsulate a promise which confirms to GSPromisable protocol
 */
@interface GSPromise : NSObject <GSPromisable>

/// GSPromisable
@property (nonatomic, copy) GSPromiseHandler handler;

// Convenience initializers
- (instancetype)initWithHandler:(GSPromiseHandler)handler;
+ (instancetype)promiseWithHandler:(GSPromiseHandler)handler;

@end

/**
 A promise manager who managers a array of `promisable` objects
 a promise mananger can will be captured in promise's handler block within handler's `then` block parameter
 */
@interface GSPromiseManager : NSObject

/**
 add a promise, it will start as soon as possible

 @param promise a promise confirms to `promisable` protocol
 */
- (void)addPromise:(id<GSPromisable>)promise;

// Convenience initilizers
- (instancetype)initWithPromise:(id <GSPromisable>)promise;
+ (instancetype)manangerWithPromise:(id <GSPromisable>)promise;
- (instancetype)initWithPromises:(NSArray <id <GSPromisable>> *)promises;
+ (instancetype)manangerWithPromises:(NSArray <id <GSPromisable>> *)promises;

@end

