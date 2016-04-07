//
//  CPJIntroduction.m
//  CPJIntroduction
//
//  Created by shuaizhai on 4/7/16.
//  Copyright © 2016 cpj. All rights reserved.
//

#import "CPJIntroduction.h"
#import "MYBlurIntroductionView.h"
#import "MYIntroductionPanel.h"

#define DEFAULTS   @"INTRODUCTION_DEFAULTS"
#define VERSION    @"APP_VERSION"
#define EVENT      @"APP_EVENT"
#define EVENT_ID   @"EVENT_ID"

@interface CPJIntroduction ()

@property (nonatomic) NSUserDefaults *defaults;

@end

CREATE_CPJMODEL_BEGAIN(CPJIntroductionModel)
    CPJMODEL_ADD_NSSTRING_PROPERTY(title, title)
    CPJMODEL_ADD_NSSTRING_PROPERTY(details, details)
    CPJMODEL_ADD_NSSTRING_PROPERTY(image, image)
    CPJMODEL_ADD_NSSTRING_PROPERTY(backgroundImage, background_image)
CREATE_CPJMODEL_END
CPJMODEL_IMPLEMENT(CPJIntroductionModel)

CREATE_CPJMODEL_BEGAIN(CPJIntroductionArray)
    CPJMODEL_ADD_NSSTRING_PROPERTY(eventID, event_id)
    CPJMODEL_ADD_NSARRAY_PROPERTY(CPJIntroductionModel, introductions, introductions)
CREATE_CPJMODEL_END
CPJMODEL_IMPLEMENT(CPJIntroductionArray)

@implementation CPJIntroduction

- (void)requestNewIntroductionInfo{
    // TODO:做网络请求
    
    NSString *URLString = @"http://127.0.0.1:5000/todo/api/v1.0/tasks";
    NSDictionary *parameters = @{};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"成功： %@", responseObject);
        //成功后重写json文件
        NSDictionary *introduction = responseObject;
        
        CPJIntroductionArray* introductionArray = [[CPJJSONAdapter new] modelsOfClass:[CPJIntroductionArray class] fromJSON:introduction];
        NSLog(@"introductionArray.eventID:%@      [self.defaults objectForKey:EVENT_ID]:%@", introductionArray.eventID, [self.defaults objectForKey:EVENT_ID]);
        if([introductionArray.eventID isEqualToString:[self.defaults objectForKey:EVENT_ID]]){
            NSLog(@"eventID 已经存在！");
            [self.defaults setBool:NO forKey:EVENT];
            return;
        }
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:introduction
                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                             error:&error];
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        } else {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"json:%@", jsonString);
            
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"IntroductionJson" ofType:@"json"];
            NSLog(@"%@", path);
            NSString *content=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            NSLog(@"文件读取成功: %@",content);
            
            BOOL res=[jsonString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
            if (res) {
                NSLog(@"文件写入成功");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.defaults setObject:introductionArray.eventID forKey:EVENT_ID];
                    [self.defaults setBool:YES forKey:EVENT];
                    [self.defaults synchronize];
                });
                
            }else
                NSLog(@"文件写入失败");
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError*error) {
        NSLog(@"失败");
    }];

}

- (void)addToViewController:(UIViewController *)viewController{
    if([self shouldShowIntroductionView]){
        NSMutableArray *panels = [NSMutableArray new];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"IntroductionJson" ofType:@"json"];
        NSString *content=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding]
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
        
        CPJIntroductionArray* introductionArray = [[CPJJSONAdapter new] modelsOfClass:[CPJIntroductionArray class] fromJSON:json];
        for(CPJIntroductionModel *info in introductionArray.introductions){
            MYIntroductionPanel *panel = [[MYIntroductionPanel alloc] initWithFrame:[UIScreen mainScreen].bounds title:info.title description:info.details image:nil header:nil];
            [panels addObject:panel];
        }
        
        MYBlurIntroductionView *introductionView = [[MYBlurIntroductionView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        introductionView.delegate = self;
        introductionView.BackgroundImageView.image = [UIImage imageNamed:@"Toronto, ON.jpg"];
        [introductionView setBackgroundColor:[UIColor colorWithRed:90.0f/255.0f green:175.0f/255.0f blue:113.0f/255.0f alpha:0.65]];
        //introductionView.LanguageDirection = MYLanguageDirectionRightToLeft;
        
        //Build the introduction with desired panels
        [introductionView buildIntroductionWithPanels:panels];
        
        [viewController.view addSubview:introductionView];
    }
    
    
}

- (NSString *)getAppVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (BOOL)shouldShowIntroductionView{
    NSLog(@"[self.defaults objectForKey:VERSION]:%@     [self getAppVersion]:%@", [self.defaults objectForKey:VERSION], [self getAppVersion]);
    if(![[self.defaults objectForKey:VERSION] isEqualToString:[self getAppVersion]]){
        // app初次安装或者升级后第一次进入
        //
        [self.defaults setObject:[self getAppVersion] forKey:VERSION];
        [self.defaults synchronize];
        return YES;
    }else if([[self.defaults objectForKey:EVENT] boolValue]){
        // app当前有活动（活动从服务端获取）
        //
        NSLog(@"event:%@", [self.defaults objectForKey:EVENT]);
        [self.defaults setBool:NO forKey:EVENT];
        [self.defaults synchronize];
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
