//
//  TouchEventMonitManager.m
//  MonitTouch
//
//  Created by changpengkai on 16/7/9.
//  Copyright © 2016年 com.pengkaichang. All rights reserved.
//

#import "TouchEventMonitManager.h"
#import <objc/runtime.h>


NSString *const TouchEventMonitManagerReceiveUIEventNofification = @"TouchEventMonitManagerReceiveUIEventNofification";

@interface TouchEventMonitManager ()
@property (nonatomic, assign) BOOL shouldMonit;
@end

@implementation TouchEventMonitManager

// load方法里面exchange系统的hitTest:withEvent:
+ (void)load {
    
    Method orginM = class_getInstanceMethod([UIView class], @selector(hitTest:withEvent:));
    Method newM = class_getInstanceMethod([self class], @selector(custom_hitTest:withEvent:));
    class_addMethod([UIView class], @selector(custom_hitTest:withEvent:), method_getImplementation(newM), method_getTypeEncoding(newM));
    newM = class_getInstanceMethod([UIView class], @selector(custom_hitTest:withEvent:));
    method_exchangeImplementations(newM, orginM);
}

+ (instancetype)shareTouchEventMonitManager {
    
    static TouchEventMonitManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TouchEventMonitManager alloc]init];
    });
    return instance;
}

+ (void)enableMonitUIEvent {
    TouchEventMonitManager *manager = [self shareTouchEventMonitManager];
    manager.shouldMonit = YES;
}

+ (void)disableMonitUIEvent {
    TouchEventMonitManager *manager = [self shareTouchEventMonitManager];
    manager.shouldMonit = NO;
}

// 方法里面监听UIEvent
- (UIView *)custom_hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    // 不能直接调用self，self是hit-test view调用类的instance
    TouchEventMonitManager *manager = [TouchEventMonitManager shareTouchEventMonitManager];
    // 拦截处理
    if (manager.shouldMonit) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *userInfo = [[NSDictionary alloc]initWithObjectsAndKeys:[NSValue valueWithCGPoint:point],@"TouchLocation",event,@"UIEvent" ,nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:TouchEventMonitManagerReceiveUIEventNofification object:nil userInfo:userInfo];
        });
    }
    
    // 继续系统自己的逻辑处理
    return [self custom_hitTest:point withEvent:event];
}

@end
