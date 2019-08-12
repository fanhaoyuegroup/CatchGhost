//
//  EndViewController.m
//  CatchGhost
//
//  Created by yiner on 2017/11/16.
//  Copyright © 2017年 yiner. All rights reserved.
//

#import "EndViewController.h"
#import <Masonry/Masonry.h>
#import "ViewHelper.h"

@interface EndViewController ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *bgImg;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL allSelect;

@property (nonatomic, strong) UIButton *giveUpChance; /* 降低做鬼率， 第一位专用 */
@property (nonatomic, strong) UIButton *reduceBecomGhost; /* 降低做鬼率， 第一位专用 */
@property (nonatomic, strong) UILabel *reduceTip;         /* 提示信息 */

@property (nonatomic, strong) UILabel *pingminLab;
@property (nonatomic, strong) UITextField *pingminTxt;
@property (nonatomic, strong) UIButton *submitBtn;

@end

#define BUTTON_WIDTH ([[UIScreen mainScreen] bounds].size.width - 40)/3

@implementation EndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"记住自己的词开始撕逼吧";
    self.isSelected = YES;
    self.allSelect = NO;
    
    [self.view addSubview:self.bgImg];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.bgView];

    [self.view addSubview:self.giveUpChance];
    [self.view addSubview:self.reduceBecomGhost];
    [self.view addSubview:self.reduceTip];
    
    [self.view addSubview:self.pingminTxt];
    [self.view addSubview:self.pingminLab];
    [self.view addSubview:self.submitBtn];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"裁判" style:UIBarButtonItemStyleDone target:self action:@selector(anwser:)];
    self.navigationItem.rightBarButtonItem = item;

    [self configureUI];
}

- (void)configureUI
{
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];

    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        make.left.right.equalTo(self.view);
    }];

    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];

    [self.giveUpChance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(200);
        make.right.equalTo(self.view.mas_centerX).offset(-40);
        make.size.mas_equalTo(CGSizeMake(BUTTON_WIDTH, 40));
    }];

    [self.reduceBecomGhost mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(200);
        make.left.equalTo(self.view.mas_centerX).offset(40);
        make.size.mas_equalTo(CGSizeMake(BUTTON_WIDTH, 40));
    }];

    [self.reduceTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.giveUpChance.mas_top).offset(-5);
        make.centerX.equalTo(self.view);
    }];
    
    [self.pingminTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-100);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(150);
    }];
    
    [self.pingminLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.pingminTxt.mas_left).offset(-10);
        make.centerY.equalTo(self.pingminTxt);
    }];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pingminTxt.mas_right).offset(30);
        make.centerY.equalTo(self.pingminTxt);
        make.size.mas_equalTo(CGSizeMake(70, 40));
    }];
}

- (void)setSortedArray:(NSMutableArray *)sortedArray
{
    NSInteger i = sortedArray.count;
    while (--i > 0) {
        int j = arc4random()%(i+1);
        [sortedArray exchangeObjectAtIndex:i withObjectAtIndex:j];
    }

    _sortedArray = sortedArray;
}

- (void)loadButton {
    for (int i = 0; i<self.sortedArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.enabled = i == 0;
        button.tag = 101+i;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.titleLabel.numberOfLines = 0;
        button.frame = CGRectMake((i%3)*BUTTON_WIDTH + (i%3+1)*10, (i/3)*50+(i/3+1)*30, BUTTON_WIDTH, 50);
        [button setTitle:[NSString stringWithFormat:@"%i",i+1] forState:UIControlStateNormal];
        [button setTitle:self.sortedArray[i] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"bg_btn_small"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"bg_btn_small_sel"] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageNamed:@"bg_btn_small_disable"] forState:UIControlStateDisabled];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] init];
        [longPress addTarget:self action:@selector(longPress:)];
        [button addGestureRecognizer:longPress];
        [self.bgView addSubview:button];
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)sender
{
    UIButton *longPressBtn = (UIButton *)sender.view;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"是否投出该玩家？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
    
    UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //TODO :  判定
        NSString *normalTitle = [longPressBtn titleForState:UIControlStateNormal];
        NSString *selectedTitle = [longPressBtn titleForState:UIControlStateSelected];
        longPressBtn.hidden = YES;
        
        if ([selectedTitle isEqualToString:self.farmer]) {
            self.farmerNum--;
            if (self.farmerNum == 0) {
                [ViewHelper showTipOnHub:[NSString stringWithFormat:@"%@号玩家被投出，恭喜👻获胜", normalTitle]];
            }
            else {
                [ViewHelper showTipOnHub:[NSString stringWithFormat:@"%@号玩家被投出，游戏继续", normalTitle]];
            }
        }
        else if ([selectedTitle isEqualToString:self.ghost]) {
            self.ghostNum--;
            if (self.ghostNum == 0) {
                [ViewHelper showTipOnHub:[NSString stringWithFormat:@"%@号玩家被投出，恭喜👩‍🌾获胜", normalTitle]];
            }
            else {
                [ViewHelper showTipOnHub:[NSString stringWithFormat:@"%@号玩家被投出，游戏继续", normalTitle]];
            }
        }
        else {
            [ViewHelper showTipOnHub:[NSString stringWithFormat:@"%@号玩家被投出，游戏继续", normalTitle]];
        }
        
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:suerAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)selectButton:(UIButton *)sender
{
    if (sender.enabled && !sender.selected) {
        sender.selected = !sender.selected;
    }
    else {
        // 当前按钮不可点击
        sender.enabled = NO;
        sender.selected = !sender.selected;

        // 下一个按钮可点击
        UIButton *button = (UIButton *)[self.bgView viewWithTag:sender.tag + 1];
        button.enabled = YES;

        // 最后一个按钮点击后， 给所有按钮添加 长按事件
        if (sender.tag == 100 + self.sortedArray.count) {
            self.allSelect = YES;
            [self addLongPressTargetWithButton];
        }
    }
}

- (void)addLongPressTargetWithButton {
    [self.bgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = (UIButton *)obj;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] init];
        [longPress addTarget:self action:@selector(longPress:)];
        [btn addGestureRecognizer:longPress];
    }];
}

- (void)anwser:(id)sender
{
    //    for (UIView *view in self.bgView.subviews) {
    //        if ([view isKindOfClass:[UIButton class]]) {
    //            UIButton *btn = (UIButton *)view;
    //            if (![btn.titleLabel.text isEqualToString:@"不能翻喽"] && !btn.enabled) {
    //
    //                return;
    //            }
    //        }
    //    }

    if (!self.allSelect) {
        return;
    }

    [self.bgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        UIButton *btn = (UIButton *)obj;
        btn.enabled = YES;
        btn.selected = self.isSelected;
    }];
    self.isSelected = !self.isSelected;
}

// 点击不想做鬼
- (void)reduceBecomGhostClick {

    [self viewHiddenAndReload];
    [self exchangeWordFormFirst];
}

//点击想做鬼
- (void)giveUpChanceClick {

    [self viewHiddenAndReload];
}

// 不想做鬼和提示信息 移除
- (void)viewHiddenAndReload {

    [self.giveUpChance removeFromSuperview];
    [self.reduceBecomGhost removeFromSuperview];
    [self.reduceTip removeFromSuperview];

//    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.tipLabel.mas_bottom);
//    }];
    self.tipLabel.hidden = NO;
    [self loadButton];
}

// 不想做鬼 那就换一下吧
- (void)exchangeWordFormFirst {
    NSInteger i = self.sortedArray.count;
    NSInteger j = arc4random()%(i);  /* 随机0 - self.sortedArray.count */

    [self.sortedArray exchangeObjectAtIndex:0 withObjectAtIndex:j];

    if (j == 0) { /* 为0不变动 */
        return;
    }

    UIButton *firstBtn = (UIButton *)[self.bgView viewWithTag:101];
    [firstBtn setTitle:self.sortedArray[0] forState:UIControlStateSelected];

    UIButton *randomBtn = (UIButton *)[self.bgView viewWithTag:101+j];
    [randomBtn setTitle:self.sortedArray[j] forState:UIControlStateSelected];

}

- (void)submitBtnClick:(id)sender {
    
    if ([self.pingminTxt.text isEqualToString:@""]) {
        [ViewHelper showTipOnHub:@"词都不输，是想碰瓷？"];
        return;
    }
    
    NSString *inputW = [self.pingminTxt.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([inputW isEqualToString:self.farmer]) {
        [ViewHelper showTipOnHub:@"恭喜👻获胜"];
    }
    else {
        [ViewHelper showTipOnHub:@"没猜对，你是🐷吗？"];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - set & get -
- (UIImageView *)bgImg
{
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"corekit_rootViewBg"]];
    }
    return _bgImg;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"按顺序查看，看完记得把词翻回来，不翻是🐶";
        _tipLabel.numberOfLines = 0;
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:15];
        _tipLabel.hidden = YES;
    }
    return _tipLabel;
}

- (UIButton *)giveUpChance {
    if (!_giveUpChance) {
        _giveUpChance = [UIButton buttonWithType:UIButtonTypeCustom];
        _giveUpChance.layer.masksToBounds = YES;
        _giveUpChance.layer.cornerRadius = 20;
        [_giveUpChance setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_giveUpChance setTitle:@"我想当👻" forState:UIControlStateNormal];
        [_giveUpChance setBackgroundColor:[UIColor colorWithRed:246/255.0 green:87/255.0 blue:61/255.0 alpha:1]];
        _giveUpChance.titleLabel.font = [UIFont systemFontOfSize:18];
        [_giveUpChance addTarget:self action:@selector(reduceBecomGhostClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _giveUpChance;
}

- (UIButton *)reduceBecomGhost {
    if (!_reduceBecomGhost) {
        _reduceBecomGhost = [UIButton buttonWithType:UIButtonTypeCustom];
        _reduceBecomGhost.layer.masksToBounds = YES;
        _reduceBecomGhost.layer.cornerRadius = 20;
        [_reduceBecomGhost setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_reduceBecomGhost setTitle:@"我不想当👻" forState:UIControlStateNormal];
        [_reduceBecomGhost setBackgroundColor:[UIColor colorWithRed:246/255.0 green:87/255.0 blue:61/255.0 alpha:1]];
        _reduceBecomGhost.titleLabel.font = [UIFont systemFontOfSize:18];
        [_reduceBecomGhost addTarget:self action:@selector(giveUpChanceClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reduceBecomGhost;
}

- (UILabel *)reduceTip {
    if (!_reduceTip) {
        _reduceTip = [[UILabel alloc] init];
        _reduceTip.text = @"首位玩家特权：是否降低当👻的概率";
        _reduceTip.textColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
        _reduceTip.textAlignment = NSTextAlignmentLeft;
        _reduceTip.font = [UIFont systemFontOfSize:15];
        _reduceTip.numberOfLines = 0;
    }
    return _reduceTip;
}


- (UILabel *)pingminLab
{
    if (!_pingminLab) {
        _pingminLab = [UILabel new];
        _pingminLab.text = @"👨‍🌾词:";
        _pingminLab.textColor = [UIColor blackColor];
        _pingminLab.font = [UIFont systemFontOfSize:18];
        
    }
    return _pingminLab;
}

- (UITextField *)pingminTxt
{
    if (!_pingminTxt) {
        _pingminTxt = [UITextField new];
        _pingminTxt.backgroundColor = [UIColor whiteColor];
        _pingminTxt.keyboardType = UIKeyboardTypeDefault;
        _pingminTxt.textColor = [UIColor blackColor];
    }
    return _pingminTxt;
}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.layer.cornerRadius = 20;
        [_submitBtn setTitle:@"猜词" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_submitBtn setBackgroundColor:[UIColor colorWithRed:246/255.0 green:87/255.0 blue:61/255.0 alpha:1]];
        [_submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

@end
