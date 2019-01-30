//
//  UIApplication+Hook.m
//  blackboard
//
//  Created by roni on 2018/12/6.
//  Copyright © 2018 xkb. All rights reserved.
//

#import "UIApplication+Hook.h"
#import "RuntimeHelper.h"
#import "blackboard-Swift.h"
#import <Mars/Mars.h>

@implementation UIApplication (Hook)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self sel_exchangeFromSel:@selector(sendAction:to:from:forEvent:) toSel:@selector(hook_sendAction:to:from:forEvent:)];
    });
}

- (BOOL)hook_sendAction:(SEL)action to:(nullable id)target from:(nullable id)sender forEvent:(nullable UIEvent *)event {
    Class class = [target class];
    NSString *viewControllerName = @"unknown";
    if ([class isKindOfClass:[UIViewController class]]) {
        viewControllerName = NSStringFromClass([target class]);
    } else {
        viewControllerName = [PathHelper getMyViewControllerWithSender:target];
    }

    NSString *title = [PathHelper getTitleWithSender:sender];
    NSString *actionName = NSStringFromSelector(action);
    [SLMarsIO addClickWithNSString:viewControllerName withNSString:nil withNSString:actionName withNSString:title];
    return [self hook_sendAction:action to:target from:sender forEvent:event];
}

@end
