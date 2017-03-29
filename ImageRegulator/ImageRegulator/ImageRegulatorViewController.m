//
//  ImageRegulatorViewController.m
//  ImageRegulator
//
//  Created by dong on 2017/3/29.
//  Copyright © 2017年 dong. All rights reserved.
//

#import "ImageRegulatorViewController.h"
#import "Helper.h"
#import "PhotoAlbumsView.h"

@interface ImageRegulatorViewController ()
    
@property(nonatomic,strong) UIButton *cancelBtn;
@property(nonatomic,strong) UIButton *switchBtn;
@property(nonatomic,strong) UIView *navView;
@property(nonatomic,strong) PhotoAlbumsView *photoAlbumsView;
@property(nonatomic,strong) UIButton *nextBtn;
    
@end

@implementation ImageRegulatorViewController
    
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavViewUI];
}
    
-(void)setNavViewUI{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationSlide)];
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:self.navView];
    
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.cancelBtn setImage:[UIImage imageNamed:@"icon_cancel"] forState:(UIControlStateNormal)];
    [self.navView addSubview:self.cancelBtn];
    
    [self.switchBtn setTitle:@"相册" forState:(UIControlStateNormal)];
    [self.navView addSubview:self.switchBtn];
    [self getPhotoAlbumsTitleSize:@"相册"];
    [self.switchBtn addTarget:self action:@selector(openPhotoAlbumsClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.navView addSubview:self.nextBtn];
    [self.nextBtn addTarget:self action:@selector(nextButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
}
    
#pragma mark - 点击“继续”
- (void)nextButtonClick:(UIButton *)button {
//    SceneAddViewController *addVC = [[SceneAddViewController alloc] init];
//    addVC.filtersImg = self.clipImageView.capture;
//    addVC.actionId = self.actionId;
//    addVC.activeTitle = self.activeTitle;
//    addVC.domainId = self.domainId;
//    [self.navigationController pushViewController:addVC animated:YES];
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
    
#pragma mark - 打开相册列表
- (void)openPhotoAlbumsClick {
    if (self.switchBtn.selected == YES) {
        self.switchBtn.selected = NO;
        CGRect openPhotoAlbumsRect = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-45);
        [UIView animateWithDuration:.3 animations:^{
            self.photoAlbumsView.frame = openPhotoAlbumsRect;
            self.nextBtn.hidden = NO;
        }];
        
    } else if (self.switchBtn.selected == NO){
        self.switchBtn.selected = YES;
        CGRect openPhotoAlbumsRect = CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT-45);
        [UIView animateWithDuration:.3 animations:^{
            self.photoAlbumsView.frame = openPhotoAlbumsRect;
            self.nextBtn.hidden = YES;
        }];
    }
}
    
#pragma mark - 加载相薄页面
- (PhotoAlbumsView *)photoAlbumsView {
    if (!_photoAlbumsView) {
        _photoAlbumsView = [[PhotoAlbumsView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-45)];
//        _photoAlbumsView.photosMarr = self.sortPhotosArr;
//        _photoAlbumsView.collectionView = self.photosView;
//        _photoAlbumsView.photoAlbumsBtn = self.openPhotoAlbums;
//        _photoAlbumsView.nextBtn = self.nextBtn;
        //  from "PhotoAlbumsView.h"
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeViewTitle:) name:@"PhotoAlbumsName" object:nil];
    }
    return _photoAlbumsView;
}

   
- (void)getPhotoAlbumsTitleSize:(NSString *)title {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
    CGFloat titleW = [title boundingRectWithSize:CGSizeMake(320, 0)
                                         options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                      attributes:attribute
                                         context:nil].size.width;
    
    [_switchBtn setImageEdgeInsets:(UIEdgeInsetsMake(0, (titleW+20)*2, 0, 0))];
}
    
#pragma mark - 切换按钮
- (UIButton *)switchBtn {
    if (!_switchBtn) {
        _switchBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH - 100, 45)];
        [_switchBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_switchBtn setImage:[UIImage imageNamed:@"icon_down"] forState:(UIControlStateNormal)];
        [_switchBtn setImage:[UIImage imageNamed:@"icon_upward"] forState:(UIControlStateSelected)];
        _switchBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        _switchBtn.selected = NO;
        _switchBtn.clipsToBounds = YES;
    }
    return _switchBtn;
}
    
- (UIView *)navView {
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        _navView.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
    }
    return _navView;
}
    
-(void)cancelBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
