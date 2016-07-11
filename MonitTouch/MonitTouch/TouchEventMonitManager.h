//
//  TouchEventMonitManager.h
//  MonitTouch
//
//  Created by changpengkai on 16/7/9.
//  Copyright © 2016年 com.pengkaichang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 监听通知
extern NSString *const TouchEventMonitManagerReceiveUIEventNofification;

@interface TouchEventMonitManager : NSObject
+ (void)enableMonitUIEvent;
+ (void)disableMonitUIEvent;
@end
