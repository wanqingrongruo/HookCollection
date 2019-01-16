//
//  UIGestureRecognizer+Hook.m
//  blackboard
//
//  Created by roni on 2018/12/10.
//  Copyright © 2018 xkb. All rights reserved.
//

#import "UIGestureRecognizer+Hook.h"
#import "RuntimeHelper.h"
#import "blackboard-Swift.h"
#import <Mars/Mars.h>

@implementation UIGestureRecognizer (Hook)
@dynamic methodName;

+ (void)load {
    [self sel_exchangeFromSel:@selector(initWithTarget:action:) toSel:@selector(hook_initWithTarget:action:)];
}

- (instancetype)hook_initWithTarget:(nullable id)target action:(nullable SEL)action {
    UIGestureRecognizer *selfGestureRecognizer = [self hook_initWithTarget:target action:action];
    self.methodName = NSStringFromSelector(action);
    return selfGestureRecognizer;
}

static const void *MethodName = &MethodName;

- (void)setMethodName:(NSString *)methodName {
    objc_setAssociatedObject(self, MethodName, methodName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)methodName {
    return objc_getAssociatedObject(self, MethodName);
}

@end

