//
//  EndViewController.h
//  CatchGhost
//
//  Created by yiner on 2017/11/16.
//  Copyright © 2017年 yiner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EndViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *sortedArray;

@property (nonatomic, assign) NSInteger farmerNum;

@property (nonatomic, assign) NSInteger ghostNum;

@property (nonatomic, copy) NSString *farmer;

@property (nonatomic, copy) NSString *ghost;

@end
