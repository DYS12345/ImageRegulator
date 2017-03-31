//
//  SceneAddViewController.m
//  ImageRegulator
//
//  Created by dong on 2017/3/31.
//  Copyright © 2017年 dong. All rights reserved.
//

#import "SceneAddViewController.h"
#import "Helper.h"

@interface SceneAddViewController ()

@property(nonatomic,strong) UILabel *navTitle;
@property(nonatomic,strong) UIView *navView;
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic,strong) UIButton *nextBtn;

@end

@implementation SceneAddViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavViewUI];
}

#pragma mark - 设置顶部导航栏
- (void)setNavViewUI {
    self.view.backgroundColor = [UIColor blackColor];
    self.view.clipsToBounds = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationSlide)];
    self.navTitle.text = @"标记产品";
    [self.navView addSubview:self.navTitle];
    [self.backBtn setImage:[UIImage imageNamed:@"icon_back_white"] forState:(UIControlStateNormal)];
    [self.navView addSubview:self.backBtn];
    [self addNextButton];
    [self.nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
}

//  继续下一步
- (void)addNextButton {
    [self.navView addSubview:self.nextBtn];
}

#pragma mark - 继续下一步的执行事件
- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 0, 45, 45)];
        [_nextBtn setTitle:@"继续" forState:(UIControlStateNormal)];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    }
    return _nextBtn;
}

#pragma mark - 返回上一步的执行事件
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _backBtn;
}

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 顶部导航
- (UIView *)navView {
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        _navView.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
    }
    return _navView;
}

#pragma mark - 页面的标题
- (UILabel *)navTitle {
    if (!_navTitle) {
        _navTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH-100, 45)];
        _navTitle.font = [UIFont systemFontOfSize:17];
        _navTitle.textColor = [UIColor whiteColor];
        _navTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _navTitle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
