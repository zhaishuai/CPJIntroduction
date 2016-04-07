//
//  ViewController.m
//  CPJIntroduction
//
//  Created by shuaizhai on 4/7/16.
//  Copyright © 2016 cpj. All rights reserved.
//

#import "ViewController.h"
#import "CPJIntroduction.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CPJIntroduction *intr = [[CPJIntroduction alloc] init];
    
    [intr requestNewIntroductionInfo];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
