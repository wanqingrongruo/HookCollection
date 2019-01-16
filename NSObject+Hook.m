//
//  NSObject+Hook.m
//  blackboard
//
//  Created by roni on 2018/12/12.
//  Copyright © 2018 xkb. All rights reserved.
//

#import "NSObject+Hook.h"

@implementation NSObject (Hook)

- (BOOL)class_addMethod:(Class)class selector:(SEL)selector imp:(IMP)imp types:(const char *)types {
    return class_addMethod(class,selector,imp,types);
}

- (void)sel_exchangeFromSel:(SEL)sel1 toSel:(SEL)sel2 {
    [self sel_exchangeClass:[self class] fromSel:sel1 toSel:sel2];
}

- (void)sel_exchangeClass:(Class)class fromSel:(SEL)sel1 toSel:(SEL)sel2 {
    Method fromMethod = class_getInstanceMethod(class, sel1);
    Method toMethod = class_getInstanceMethod(class, sel2);
    if (![self class_addMethod:class selector:sel2 imp:method_getImplementation(toMethod) types:method_getTypeEncoding(toMethod)]) {
        method_exchangeImplementations(fromMethod, toMethod);
    }
}

- (void)method_exchangeImplementations:(Method)fromMethod method:(Method)toMethod {
    method_exchangeImplementations(fromMethod,toMethod);
}

- (IMP)method_getImplementation:(Method)method {
    return method_getImplementation(method);
}

- (Method)class_getInstanceMethod:(Class)class selector:(SEL)selector {
    return class_getInstanceMethod(class, selector);
}

- (BOOL)isContainSel:(SEL)sel inClass:(Class)class {
    unsigned int count;

    Method *methodList = class_copyMethodList(class,&count);
    for (int i = 0; i < count; i++) {
        Method method = methodList[i];
        NSString *tempMethodString = [NSString stringWithUTF8String:sel_getName(method_getName(method))];
        if ([tempMethodString isEqualToString:NSStringFromSelector(sel)]) {
            return YES;
        }
    }
    return NO;
}

- (void)log_class_copyMethodList:(Class)class {
    unsigned int count;
    Method *methodList = class_copyMethodList(class,&count);
    for (int i = 0; i < count; i++) {
        Method method = methodList[i];
        NSLog(@"%s%s",__func__,sel_getName(method_getName(method)));
    }
}

@end
