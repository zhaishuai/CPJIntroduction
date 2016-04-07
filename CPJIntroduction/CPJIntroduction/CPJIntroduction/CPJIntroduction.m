//
//  CPJIntroduction.m
//  CPJIntroduction
//
//  Created by shuaizhai on 4/7/16.
//  Copyright © 2016 cpj. All rights reserved.
//

#import "CPJIntroduction.h"

#define DEFAULTS   @"INTRODUCTION_DEFAULTS"
#define VERSION    @"APP_VERSION"
#define EVENT      @"APP_EVENT"

@interface CPJIntroduction ()

@property (nonatomic) NSUserDefaults *defaults;

@end

@implementation CPJIntroduction

- (void)requestNewIntroductionInfo{
    // TODO:做网络请求
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"IntroductionJson" ofType:@"json"];
    NSLog(@"%@", path);
    NSString *content=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"文件读取成功: %@",content);
}

- (void)addToViewController:(UIViewController *)viewController{
    
}

- (NSString *)getAppVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (BOOL)shouldShowIntroductionView{
    if(![[self.defaults objectForKey:VERSION] isEqualToString:[self getAppVersion]]){
        // app初次安装或者升级后第一次进入
        //
        return YES;
    }else if([self.defaults objectForKey:EVENT]){
        // app当前有活动（活动从服务端获取）
        //
        return YES;
    }
    return NO;
}

- (NSUserDefaults *)defaults{
    if(!_defaults){
        _defaults = [[NSUserDefaults alloc] initWithSuiteName:DEFAULTS];
    }
    return _defaults;
}


@end
