//
//  UICollectionView+Hook.m
//  blackboard
//
//  Created by roni on 2018/12/11.
//  Copyright © 2018 xkb. All rights reserved.
//

#import "UICollectionView+Hook.h"
#import "RuntimeHelper.h"
#import "blackboard-Swift.h"

@implementation UICollectionView (Hook)


+ (void)load
{
    [self sel_exchangeFromSel:@selector(setDelegate:) toSel:@selector(hook_setDelegate:)];
}

- (void)hook_setDelegate:(id<UICollectionViewDelegate>)delegate
{
    [self hook_setDelegate:delegate];
    
    Class class = [delegate class];

    // 判断当前有没有实现 didSelectItemAtIndexPath -- 没有实现 exchange 会 crsh
    if (![self isContainSel:@selector(collectionView:didSelectItemAtIndexPath:) inClass:class]) {
        return;
    }
    if (class_addMethod(class, NSSelectorFromString(@"hook02_didSelectRowAtIndexPath"), (IMP)hook02_didSelectRowAtIndexPath, "v@:@@")) {
        [self sel_exchangeClass:class fromSel:@selector(collectionView:didSelectItemAtIndexPath:) toSel:NSSelectorFromString(@"hook02_didSelectRowAtIndexPath")];
    }
}

void hook02_didSelectRowAtIndexPath(id self, SEL _cmd, id collectionView, id indexPath)
{
    SEL swizzledSEL = NSSelectorFromString(@"hook02_didSelectRowAtIndexPath");
    ((void(*)(id, SEL, id, id))objc_msgSend)(self, swizzledSEL, collectionView, indexPath);

    id vc = [PathHelper getMyViewControllerWithSender:collectionView isPush: YES];
    NSString *info = [NSString stringWithFormat:@" %@:%@ -> %@", vc, NSStringFromClass([collectionView class]),  NSStringFromSelector(swizzledSEL)];
    NSLog(@"%@", info);
}

@end
