//
//  ViewHelper.h
//  CardApp
//
//  Created by tailang on 14-8-21.
//  Copyright (c) 2014年 2dfire.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//#import "MBProgressHUD.h"

@interface ViewHelper : NSObject


+ (void)showTipOnHub:(NSString *)tip;
+ (void)showTipOnHub:(NSString *)tip coverPreTip:(BOOL)coverPreTip;

@end
