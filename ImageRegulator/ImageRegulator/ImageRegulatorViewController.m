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
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVMediaFormat.h>
#import "CameraView.h"
#import "FBFootView.h"

@interface ImageRegulatorViewController ()
    
@property(nonatomic,strong) UIButton *cancelBtn;
@property(nonatomic,strong) UIButton *switchBtn;
@property(nonatomic,strong) UIView *navView;
@property(nonatomic,strong) PhotoAlbumsView *photoAlbumsView;
@property(nonatomic,strong) UIButton *nextBtn;
@property(nonatomic,strong) UIView *pictureView;
@property(nonatomic,strong) CameraView *cameraView;
@property(nonatomic,strong) NSMutableArray *sortPhotosArr;      //  排序的相片
@property(nonatomic,strong) UIButton *openPhotoAlbums;  //  打开相薄
    
@end

@implementation ImageRegulatorViewController
    
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavViewUI];
    if ([self isAllowMedia]) {
        if (self.pictureView.hidden == YES) {
            if (self.cameraView.session) {
                [self.cameraView.session startRunning];
            }
        }
    }
}
    
#pragma mark - 打开相机的页面
- (CameraView *)cameraView {
    if (!_cameraView) {
        _cameraView = [[CameraView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 45)];
        _cameraView.VC = self;
        _cameraView.Nav = self.navigationController;
    }
    return _cameraView;
}
    
- (BOOL)isAllowMedia{
    BOOL isMedia;
    NSString *mediaMessage = @"请在设置->隐私->相机 中打开本应用的访问权限";
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        isMedia = NO;
    }else{
        isMedia = YES;
    }
    if (!isMedia) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:mediaMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag = 7;
        alertView.delegate = self;
        [alertView show];
    }
    return isMedia;
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

#pragma mark - init
- (NSMutableArray *)sortPhotosArr {
    if (!_sortPhotosArr) {
        _sortPhotosArr = [NSMutableArray array];
    }
    return _sortPhotosArr;
}
    
#pragma mark - 加载相薄页面
- (PhotoAlbumsView *)photoAlbumsView {
    if (!_photoAlbumsView) {
        _photoAlbumsView = [[PhotoAlbumsView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-45)];
        _photoAlbumsView.photosMarr = self.sortPhotosArr;
        _photoAlbumsView.collectionView = self.photosView;
        _photoAlbumsView.photoAlbumsBtn = self.openPhotoAlbums;
        _photoAlbumsView.nextBtn = self.nextBtn;
        //  from "PhotoAlbumsView.h"
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeViewTitle:) name:@"PhotoAlbumsName" object:nil];
    }
    return _photoAlbumsView;
}

#pragma mark - 打开相薄
- (UIButton *)openPhotoAlbums {
    if (!_openPhotoAlbums) {
        _openPhotoAlbums = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH - 100, 45)];
        [_openPhotoAlbums setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_openPhotoAlbums setImage:[UIImage imageNamed:@"icon_down"] forState:(UIControlStateNormal)];
        [_openPhotoAlbums setImage:[UIImage imageNamed:@"icon_upward"] forState:(UIControlStateSelected)];
        _openPhotoAlbums.titleLabel.font = [UIFont systemFontOfSize:17];
        _openPhotoAlbums.selected = NO;
        _openPhotoAlbums.clipsToBounds = YES;
    }
    return _openPhotoAlbums;
}
    
- (void)changeViewTitle:(NSNotification *)title {
    [self getPhotoAlbumsTitleSize:[title object]];
    [self.openPhotoAlbums setTitle:[title object] forState:(UIControlStateNormal)];
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
    self.view.backgroundColor = [UIColor blackColor];
    [self loadAllPhotos];
    [self setViewUI];
}
    
- (void)setViewUI {
    [self.view addSubview:self.pictureView];
    [self.pictureView addSubview:self.clipImageView];
    
    [self.pictureView addSubview:self.dragView];
    
    [self.pictureView addSubview:self.photosView];
    
    [self.view addSubview:self.photoAlbumsView];
    
    [self.view addSubview:self.footView];
    [_footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 45));
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.centerX.equalTo(self.view);
    }];
}
    
#pragma mark - 底部选项工具栏
- (FBFootView *)footView {
    if (!_footView) {
        NSArray * arr = [NSArray arrayWithObjects:NSLocalizedString(@"album", nil), NSLocalizedString(@"camera", nil), nil];
        _footView = [[FBFootView alloc] init];
        _footView.backgroundColor = [UIColor colorWithHexString:@"#222222"];
        _footView.titleArr = arr;
        _footView.titleFontSize = Font_ControllerTitle;
        _footView.btnBgColor = [UIColor colorWithHexString:@"#222222"];
        _footView.titleNormalColor = [UIColor whiteColor];
        _footView.titleSeletedColor = [UIColor colorWithHexString:fineixColor alpha:1];
        [_footView addFootViewButton];
        [_footView showLineWithButton];
        _footView.delegate = self;
    }
    return _footView;
}
    
#pragma mark - 相册的列表视图
- (UICollectionView *)photosView {
    if (!_photosView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 6) / 4, (SCREEN_WIDTH - 6) / 4);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumInteritemSpacing = 2.0;
        flowLayout.minimumLineSpacing = 2.0;
        
        _photosView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH+32, SCREEN_WIDTH, CGRectGetHeight(self.pictureView.bounds) - (SCREEN_WIDTH+32)) collectionViewLayout:flowLayout];
        _photosView.delegate = self;
        _photosView.dataSource = self;
        _photosView.backgroundColor = [UIColor blackColor];
        _photosView.showsHorizontalScrollIndicator = NO;
        _photosView.showsVerticalScrollIndicator = NO;
        [_photosView registerClass:[FBPictureCollectionViewCell class] forCellWithReuseIdentifier:@"FBPictureCollectionViewCell"];
    }
    return _photosView;
}
  
#pragma mark - 下面的小图照片视图
- (UIView *)dragView {
    if (!_dragView) {
        _dragView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH, SCREEN_WIDTH, 30)];
        _dragView.backgroundColor = [UIColor blackColor];
        _dragView.clipsToBounds = YES;
        
        [_dragView addSubview:self.gripView];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [_dragView addGestureRecognizer:panGesture];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [_dragView addGestureRecognizer:tapGesture];
        
        [tapGesture requireGestureRecognizerToFail:panGesture];
    }
    return _dragView;
}
    
-(UIView *)pictureView {
    if (!_pictureView) {
        _pictureView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - 90)];
    }
    return _pictureView;
}
    
#pragma mark - 选中的那个视图
- (FBImageScrollView *)clipImageView {
    if (!_clipImageView) {
        _clipImageView = [[FBImageScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
        _clipImageView.clipsToBounds = YES;
    }
    return _clipImageView;
}
    
#pragma mark - 加载所有的相片
- (void)loadAllPhotos {
    __weak __typeof(self)weakSelf = self;
    [FBLoadPhoto loadAllPhotos:^(NSArray *photos, NSArray *photoAlbums, NSError *error) {
        if (!error) {
            NSEnumerator * enumerator = [photos reverseObjectEnumerator];
            while (id object = [enumerator nextObject]) {
                [weakSelf.sortPhotosArr addObject:object];
            }
            [weakSelf.photosView reloadData];
            [weakSelf.photosView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                              animated:YES
                                        scrollPosition:(UICollectionViewScrollPositionNone)];
            
            if (photos.count) {
                [weakSelf showFirstPhoto];
            }
            weakSelf.photoAlbumArr = [photoAlbums copy];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"photoAlbums" object:self.photoAlbumArr];
            
        } else {
            NSLog(@"error:%@", error);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PhotoAlbumsName" object:nil];
}

@end
