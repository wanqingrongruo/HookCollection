//
//  UIApplication+Hook.m
//  blackboard
//
//  Created by roni on 2018/12/6.
//  Copyright © 2018 xkb. All rights reserved.
//

#import "UIControl+Hook.h"
#import "RuntimeHelper.h"
#import "blackboard-Swift.h"

@implementation UIControl (Hook)

+ (void)load
{
    [self sel_exchangeFromSel:@selector(sendAction:to:from:forEvent:) toSel:@selector(hook_sendAction:to:from:forEvent:)];
}

- (BOOL)hook_sendAction:(SEL)action to:(nullable id)target from:(nullable id)sender forEvent:(nullable UIEvent *)event
{
    id vc = [PathHelper getMyViewControllerWithSender:sender isPush:NO];
    NSString *info = [NSString stringWithFormat:@" %@%@ -> %@", vc, NSStringFromClass([sender class]), NSStringFromSelector(action)];
    NSLog(@"%@", info);
    return [self hook_sendAction:action to:target from:sender forEvent:event];
}

@end
