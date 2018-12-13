//
//  UITableView+Hook.m
//  blackboard
//
//  Created by roni on 2018/12/10.
//  Copyright © 2018 xkb. All rights reserved.
//

#import "UITableView+Hook.h"
#import "RuntimeHelper.h"
#import "blackboard-Swift.h"

@implementation UITableView (Hook)

+ (void)load
{
   [self sel_exchangeFromSel:@selector(setDelegate:) toSel:@selector(hook_setDelegate:)];
}

- (void)hook_setDelegate:(id<UITableViewDelegate>)delegate
{
    [self hook_setDelegate:delegate];
    
    Class class = [delegate class];
    
    // 判断当前有没有实现 didSelectItemAtIndexPath -- 没有实现 exchange 会 crsh
    if (![self isContainSel:@selector(tableView:didSelectRowAtIndexPath:) inClass:class]) {
        return;
    }
    if (class_addMethod(class, NSSelectorFromString(@"hook_didSelectRowAtIndexPath"), (IMP)hook_didSelectRowAtIndexPath, "v@:@@")) {
        [self sel_exchangeClass:class fromSel:@selector(tableView:didSelectRowAtIndexPath:) toSel:NSSelectorFromString(@"hook_didSelectRowAtIndexPath")];
    }
}

void hook_didSelectRowAtIndexPath(id self, SEL _cmd, id tableView, id indexPath)
{
    SEL swizzledSEL = NSSelectorFromString(@"hook_didSelectRowAtIndexPath");
    ((void(*)(id, SEL, id, id))objc_msgSend)(self, swizzledSEL, tableView, indexPath);

    id vc = [PathHelper getMyViewControllerWithSender:tableView isPush: YES];
    NSString *info = [NSString stringWithFormat:@" %@%@ -> %@", vc, NSStringFromClass([tableView class]),  NSStringFromSelector(swizzledSEL)];
    NSLog(@"%@", info);
}


@end
