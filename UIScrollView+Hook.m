//
//  UIScrollView+Hook.m
//  blackboard
//
//  Created by roni on 2019/1/30.
//  Copyright © 2019 xkb. All rights reserved.
//

#import "UIScrollView+Hook.h"
#import "RuntimeHelper.h"

@implementation UIScrollView (Hook)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSel = @selector(setDelegate:);
        SEL swizzledSEL = @selector(hook_setDelegate:);

        Class class = [UIScrollView class];
        if ([self isContainSel:originalSel inClass:class]) {
            [self sel_exchangeFromSel:originalSel toSel:swizzledSEL];
        }
    });
}

- (void)hook_setDelegate:(id<UIScrollViewDelegate>)delegate {
    Class class = [delegate class];
    SEL originalSel = @selector(setDelegate:);
    if ([self isContainSel:originalSel inClass:class]) {
        if (delegate) {
            UIScrollView * __weak weak_self = (UIScrollView *)self;
            [(NSObject *)delegate setDeallocCallback:^{
                weak_self.delegate = nil;
            }];
        }
    }
    [self hook_setDelegate:delegate];
}

@end
