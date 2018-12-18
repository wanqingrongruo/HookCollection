//
//  UIView+Hook.m
//  blackboard
//
//  Created by roni on 2018/12/18.
//  Copyright © 2018 xkb. All rights reserved.
//

#import "UIView+Hook.h"
#import "RuntimeHelper.h"
#import "blackboard-Swift.h"
#import <Mars/Mars.h>

@implementation UIView (Hook)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSel = @selector(addGestureRecognizer:);
        SEL swizzledSEL = @selector(hook_addGestureRecognizer:);

        Class class = [UIView class];

        if ([self isContainSel:originalSel inClass:class]) {
            [self sel_exchangeFromSel:originalSel toSel:swizzledSEL];
        }
    });
}

- (void)hook_addGestureRecognizer:(UIGestureRecognizer *)gesture {
    [self hook_addGestureRecognizer:gesture];

    if ([gesture isKindOfClass:[UITapGestureRecognizer class]] || [gesture isKindOfClass:[UILongPressGestureRecognizer class]]) {
        [gesture addTarget:self action:@selector(autoEventAction:)];
    }
}

- (void)autoEventAction:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        NSString *viewControllerName = [PathHelper getMyViewControllerWithSender:gesture];
        NSString *actionName = @"手势点击";
        [SLMarsIO addClickWithNSString:viewControllerName withNSString:nil withNSString:actionName withNSString:@"手势点击"];
    }
}

@end
