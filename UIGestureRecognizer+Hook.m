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

@implementation UIGestureRecognizer (Hook)

+ (void)load
{
    [self sel_exchangeFromSel:@selector(initWithTarget:action:) toSel:@selector(hook_initWithTarget:action:)];
}

- (instancetype)hook_initWithTarget:(nullable id)target action:(nullable SEL)action
{
    UIGestureRecognizer *selfGestureRecognizer = [self hook_initWithTarget:target action:action];

    if (!target || !action) {
        return selfGestureRecognizer;
    }

    if ([target isKindOfClass:[UIScrollView class]]) {
        return selfGestureRecognizer;
    }

    Class class = [target class];

    SEL originalSEL = action;
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"hook_%@", NSStringFromSelector(action)]);

    BOOL isAddMethod = class_addMethod(class, swizzledSEL, (IMP)hook_gestureAction, "v@:@");

    if (isAddMethod) {
        Method fromMethod = class_getInstanceMethod(class, originalSEL);
        Method toMethod = class_getInstanceMethod(class, swizzledSEL);
        method_exchangeImplementations(fromMethod, toMethod);
    }

    return selfGestureRecognizer;
}

void hook_gestureAction(id self, SEL _cmd, id sender) {
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"hook_%@", NSStringFromSelector(_cmd)]);
    ((void(*)(id, SEL, id))objc_msgSend)(self, swizzledSEL, sender);

    if ([sender isKindOfClass:[UIGestureRecognizer class]]) {
        UIGestureRecognizer *gesture = (UIGestureRecognizer *)sender;
        if (gesture.state == UIGestureRecognizerStateEnded) {
            id vc = [PathHelper getMyViewControllerWithSender:sender isPush:NO];
            NSString *info = [NSString stringWithFormat:@" %@:%@ -> %@", vc, NSStringFromClass([sender class]), NSStringFromSelector(swizzledSEL)];
            NSLog(@"%@", info);
        }
    }
}

@end
