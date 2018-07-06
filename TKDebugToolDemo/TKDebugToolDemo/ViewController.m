//
//  ViewController.m
//  TKDebugToolDemo
//
//  Created by usee on 2018/6/29.
//  Copyright © 2018年 tax. All rights reserved.
//

#import "ViewController.h"
#import "TKWindow.h"
#import "TKDebugTool.h"
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", [[NSBundle mainBundle] infoDictionary]);
    
}
- (IBAction)bntClick {
    [TKDebugTool.sharedInstance stop];
}

@end
