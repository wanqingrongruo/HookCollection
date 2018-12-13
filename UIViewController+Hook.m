//
//  UIViewController+Hook.m
//  blackboard
//
//  Created by roni on 2018/12/7.
//  Copyright © 2018 xkb. All rights reserved.
//

#import "UIViewController+Hook.h"
#import "RuntimeHelper.h"

static char kStartDate;

@implementation UIViewController (Hook)

@dynamic startDate;

+ (void)load{
    [self sel_exchangeFromSel:@selector(viewDidAppear:) toSel:@selector(hool_ViewDidAppear)];
    [self sel_exchangeFromSel:@selector(viewDidAppear:) toSel:@selector(hook_ViewDidDisAppear)];
}

- (void)hool_ViewDidAppear {
    NSString *key = NSStringFromClass([self class]);
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey: key];
    self.startDate = [NSDate  date];
    [self hool_ViewDidAppear];
}

- (void)hook_ViewDidDisAppear{
    NSDate *endDate = [NSDate date];
    NSString *survivalT = [NSString stringWithFormat:@"survival:%.2lfs", [endDate timeIntervalSinceDate: self.startDate]];
    NSString *key = NSStringFromClass([self class]);
    [[NSUserDefaults standardUserDefaults] setObject:survivalT forKey: key];
    [self hook_ViewDidDisAppear];
}

- (void)setStartDate:(NSDate *)startDate {
    objc_setAssociatedObject(self, &kStartDate, startDate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDate *)startDate {
    return (NSDate *)objc_getAssociatedObject(self, &kStartDate);
}

@end
