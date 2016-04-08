//
//  CPJIntroduction.h
//  CPJIntroduction
//
//  Created by shuaizhai on 4/7/16.
//  Copyright © 2016 cpj. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CPJIntroduction : NSObject

/**
 * 从服务端获取需要展示的信息，在应用启动时调用该方法, 或者在通知中调用。
 */
- (void)requestNewIntroductionInfo;

/**
 * 在子类中重写该方法
 */
- (void)addToViewController:(UIViewController *) viewController ;

@end


