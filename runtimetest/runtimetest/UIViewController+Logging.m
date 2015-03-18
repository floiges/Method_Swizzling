//
//  UIViewController+Logging.m
//  runtimetest
//
//  Created by 224 on 15/3/15.
//  Copyright (c) 2015年 zoomlgd. All rights reserved.
//

#import "UIViewController+Logging.h"
#import <objc/runtime.h>

void (*gOriginalViewDidAppear) (id,SEL,BOOL);

@implementation UIViewController (Logging)

//+ (void)load
//{
//    swizzleMethod([self class], @selector(viewDidAppear:), @selector(swizzled_viewDidAppear:));
//}
//
//- (void)swizzled_viewDidAppear:(BOOL)animated
//{
//    //call original implementation
//    [self swizzled_viewDidAppear:animated];
//    
//    //Loggin
//    NSLog(@"logging %@",[self class]);
//}
//
// void swizzleMethod(Class class,SEL originalSelector,SEL swizzledSelector)
//{
//    //the method might not exist in the class,but in its suoeorclass
//    Method originalMethod = class_getInstanceMethod(class, originalSelector);
//    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//    
//    //class_addMethod will fail if original method already exists
//    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
//    //the method doesn't exists and we just added one
//    if(didAddMethod) {
//        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//    }
//    else {
//        method_exchangeImplementations(originalMethod, swizzledMethod);
//    }
//}

//简化
void newViewDidAppear(UIViewController *self,SEL _cmd,BOOL animated)
{
    //call original implementation
    gOriginalViewDidAppear(self, _cmd, animated);
    
    NSLog(@"logging %@ easy",[self class]);
}

+ (void)load
{
    Method originalMethod = class_getInstanceMethod(self, @selector(viewDidAppear:));
    gOriginalViewDidAppear = (void *)method_getImplementation(originalMethod);
    
    if (!class_addMethod(self, @selector(viewDidAppear:), (IMP)newViewDidAppear, method_getTypeEncoding(originalMethod))) {
        method_setImplementation(originalMethod, (IMP)newViewDidAppear);
    }
}

@end
