//
//  FBFootView.m
//  ImageRegulator
//
//  Created by dong on 2017/3/30.
//  Copyright © 2017年 dong. All rights reserved.
//

#import "FBFootView.h"
#import "Helper.h"

const static NSInteger btnTag = 100;

@implementation FBFootView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.buttonView];
    }
    return self;
}

//  设置按钮视图
- (UIScrollView *)buttonView {
    if (!_buttonView) {
        _buttonView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
        _buttonView.bounces = NO;
        _buttonView.showsHorizontalScrollIndicator = NO;
        _buttonView.showsVerticalScrollIndicator = NO;
    }
    return _buttonView;
}

- (void)addFootViewButton {
    for (NSUInteger idx = 0; idx < self.titleArr.count; idx ++) {
        UIButton * toolBtn = [[UIButton alloc] initWithFrame:CGRectMake(idx * SCREEN_WIDTH/self.titleArr.count, 0, SCREEN_WIDTH/self.titleArr.count, 47)];
        [toolBtn setTitle:self.titleArr[idx] forState:(UIControlStateNormal)];
        [toolBtn setTitleColor:self.titleNormalColor forState:(UIControlStateNormal)];
        [toolBtn setTitleColor:self.titleSeletedColor forState:(UIControlStateSelected)];
        toolBtn.backgroundColor = self.btnBgColor;
        toolBtn.titleLabel.font = [UIFont systemFontOfSize:self.titleFontSize];
        toolBtn.tag = btnTag + idx;
        
        if (toolBtn.tag == btnTag) {
            toolBtn.selected = YES;
            self.seletedBtn = toolBtn;
        }
        
        [toolBtn addTarget:self action:@selector(toolBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self.buttonView addSubview:toolBtn];
    }
}


@end
