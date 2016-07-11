//
//  ViewController.m
//  MonitTouch
//
//  Created by changpengkai on 16/7/8.
//  Copyright © 2016年 com.pengkaichang. All rights reserved.
//

#import "ViewController.h"
#import "TouchEventMonitManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib
    
    [TouchEventMonitManager enableMonitUIEvent];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recevieTouch:) name:TouchEventMonitManagerReceiveUIEventNofification object:nil];
}

// 方法会调用多次（暂时没有好的思路）
- (void)recevieTouch:(NSNotification *)not {
    //
    NSLog(@"-touch事件-- %@",not.userInfo);
}
@end
