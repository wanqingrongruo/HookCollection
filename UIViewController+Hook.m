//
//  UIViewController+Hook.m
//  blackboard
//
//  Created by roni on 2018/12/7.
//  Copyright © 2018 xkb. All rights reserved.
//

#import "UIViewController+Hook.h"
#import "RuntimeHelper.h"
#import "blackboard-Swift.h"
#import <Mars/Mars.h>


@implementation UIViewController (Hook)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self sel_exchangeFromSel:@selector(viewDidLoad) toSel:@selector(hook_ViewDidLoad)];
    });
}

- (void)hook_ViewDidLoad {
    if (![self isKindOfClass:[UINavigationController class]] && ![self isKindOfClass:[UITabBarController class]]) {
        NSString *name = [PathHelper getClassTypeWithSender:self];
        [SLMarsIO addCreateWithNSString:name withNSString:nil];
    }

    [self hook_ViewDidLoad];
}

@end
