//
//  Manager.h
//  TestPromiseKit
//
//  Created by beforeold on 2017/8/30.
//  Copyright © 2017年 beforeold. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestManager : NSObject

+ (void)doSomethingWithCompletion:(dispatch_block_t)completion;

@end
