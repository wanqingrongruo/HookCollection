//
//  NSObject+Hook.h
//  blackboard
//
//  Created by roni on 2018/12/12.
//  Copyright © 2018 xkb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^DeallocCallback)(void);

@interface NSObject (Hook)

- (BOOL)class_addMethod:(Class)class selector:(SEL)selector imp:(IMP)imp types:(const char *)types;

- (void)sel_exchangeFromSel:(SEL)sel toSel:(SEL)sel2;

- (void)sel_exchangeClass:(Class)class fromSel:(SEL)sel1 toSel:(SEL)sel2;

- (IMP)method_getImplementation:(Method)method;

- (Method)class_getInstanceMethod:(Class)class selector:(SEL)selector;

- (BOOL)isContainSel:(SEL)sel inClass:(Class)class;

- (void)log_class_copyMethodList:(Class)class;

- (void)setDeallocCallback:(DeallocCallback)callback;
- (DeallocCallback)deallocCallback;

@end

NS_ASSUME_NONNULL_END
