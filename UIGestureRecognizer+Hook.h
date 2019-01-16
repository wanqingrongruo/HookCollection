//
//  UIGestureRecognizer+Hook.h
//  blackboard
//
//  Created by roni on 2018/12/18.
//  Copyright © 2018 xkb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIGestureRecognizer (Hook)
@property(nonatomic, strong) NSString *methodName;
@end

NS_ASSUME_NONNULL_END
