//
//  ViewHelper.m
//  CardApp
//
//  Created by tailang on 14-8-21.
//  Copyright (c) 2014年 2dfire.com. All rights reserved.
//

#import "ViewHelper.h"

#define kKeyWindow [[UIApplication sharedApplication].delegate window]
#define SCREEN_WIDTH                  [[UIScreen mainScreen] bounds].size.width
@implementation ViewHelper


+ (void)showTipOnHub:(NSString *)tip
{
    [self showTipOnHub:tip coverPreTip:NO];
}

+ (void)showTipOnHub:(NSString *)tip coverPreTip:(BOOL)coverPreTip
{
    
    UIView *preTipView = [kKeyWindow viewWithTag:123456789];
    if (preTipView) {
        if (coverPreTip) {
            [preTipView removeFromSuperview];
            preTipView = nil;
        }else {//如果存在就不显示
            return;
        }
    }
    
    if (tip && tip.length > 0) {
        UILabel *label = [[UILabel alloc] init];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.maximumLineHeight = 20;
        paragraphStyle.minimumLineHeight = 20;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        label.attributedText = [[NSAttributedString alloc] initWithString:tip
                                                               attributes:@{NSParagraphStyleAttributeName: paragraphStyle,
                                                                            NSFontAttributeName:[UIFont systemFontOfSize:14]
                                                                            }];;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithWhite:1 alpha:0.95];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        
        CGSize lblSize = [label.attributedText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH*0.667 - 40, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        label.frame = CGRectMake(20, 5, ceil(lblSize.width), ceil(lblSize.height));
        
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
        view.bounds = CGRectMake(0, 0, lblSize.width + 40, lblSize.height + 14);
        view.center = CGPointMake(kKeyWindow.center.x, kKeyWindow.center.y);
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 5;
        view.alpha = 0;
        view.tag = 123456789;
        
        [view addSubview:label];
        
        [kKeyWindow addSubview:view];
        [UIView animateWithDuration:0.5 animations:^{
            view.alpha = 1;
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 delay:2.5 options:0 animations:^{
                view.alpha = 0;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }];
    }
}

@end
