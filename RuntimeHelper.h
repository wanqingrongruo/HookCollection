//
//  RuntimeHelper.h
//  blackboard
//
//  Created by roni on 2018/12/12.
//  Copyright © 2018 xkb. All rights reserved.
//

#ifndef RuntimeHelper_h
#define RuntimeHelper_h

#import "NSObject+Hook.h"

#define GET_CLASS_CUSTOM_SEL(sel,class)  NSSelectorFromString([NSString stringWithFormat:@"%@_%@",NSStringFromClass(class),NSStringFromSelector(sel)])

#endif /* RuntimeHelper_h */
