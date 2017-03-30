//
//  FBFootView.h
//  ImageRegulator
//
//  Created by dong on 2017/3/30.
//  Copyright © 2017年 dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FBFootViewDelegate <NSObject>

@optional

- (void)buttonDidSeletedWithIndex:(NSInteger)index;

@end

@interface FBFootView : UIView

@property (nonatomic, strong) UIScrollView    *   buttonView;         //  按钮视图
@property (nonatomic, strong) NSArray         *   titleArr;           //  底部按钮标题
@property (nonatomic, strong) UILabel         *   line;               //  导航条
@property (nonatomic, strong) UIButton        *   seletedBtn;         //  保存上次点击的button

@property (nonatomic, assign) NSInteger           titleFontSize;      //  标题字号大小
@property (nonatomic, strong) UIColor         *   titleNormalColor;   //  标题默认颜色
@property (nonatomic, strong) UIColor         *   titleSeletedColor;  //  标题点击颜色
@property (nonatomic, strong) UIColor         *   btnBgColor;         //  按钮背景颜色

@property (nonatomic, weak) id <FBFootViewDelegate> delegate;

//  添加按钮
- (void)addFootViewButton;

//  是否显示导航条
- (void)showLineWithButton;


@end
