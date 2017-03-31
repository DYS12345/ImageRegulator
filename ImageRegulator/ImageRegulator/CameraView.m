//
//  CameraView.m
//  ImageRegulator
//
//  Created by dong on 2017/3/29.
//  Copyright © 2017年 dong. All rights reserved.
//

#import "CameraView.h"
#import "Helper.h"
#import "Masonry/Masonry/Masonry.h"
#import "SceneAddViewController.h"

@interface CameraView ()

{
    BOOL _isUsingFrontFacingCamera;
}

@end

@implementation CameraView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.cameraNavView];
        [self setCamere];
        [self setCameraViewUI];
    }
    return self;
}

#pragma marm - setUI
- (void)setCameraViewUI {
    [self addSubview:self.previewView];
    
    [self addSubview:self.takePhotosBtn];
    [_takePhotosBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.bottom.equalTo(self.mas_bottom).with.offset(-63);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.flashBtn];
    [_flashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.right.equalTo(self.mas_right).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(SCREEN_WIDTH);
    }];
    
    [self addSubview:self.selfTimerBtn];
    [_selfTimerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.left.equalTo(self.mas_left).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(SCREEN_WIDTH);
    }];
}

#pragma mark - 预览图层
- (UIView *)previewView {
    if (!_previewView) {
        _previewView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_WIDTH)];
    }
    return _previewView;
}

#pragma mark - 拍照按钮
- (UIButton *)takePhotosBtn {
    if (!_takePhotosBtn) {
        _takePhotosBtn = [[UIButton alloc] init];
        [_takePhotosBtn setImage:[UIImage imageNamed:@"icon_capture"] forState:(UIControlStateNormal)];
        [_takePhotosBtn addTarget:self action:@selector(takePhotosBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _takePhotosBtn;
}

- (void)takePhotosBtnClick {
    //  控制输入和输出
    AVCaptureConnection * photoConnection = [self.photosOutput connectionWithMediaType:AVMediaTypeVideo];
    
    //  设备的旋转方向
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation videoOrientation = [self photoDeviceOrientation:deviceOrientation];
    [photoConnection setVideoOrientation:videoOrientation];
    //  焦距
    [photoConnection setVideoScaleAndCropFactor:1];
    
    [self.photosOutput captureStillImageAsynchronouslyFromConnection:photoConnection
                                                   completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                                                       
                                                       NSData * photoData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                                                       
                                                       //   监测摄像头的权限
                                                       ALAuthorizationStatus photoStatus = [ALAssetsLibrary authorizationStatus];
                                                       if (photoStatus == ALAuthorizationStatusRestricted || photoStatus == ALAuthorizationStatusDenied) {
                                                           
                                                       } else {
//                                                           UIImage * image = [UIImage imageWithData:photoData];
//                                                           UIImage * photo = [self cropImage:image withCropSize:CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH)];
//                                                           SceneAddViewController * sceneAddVC = [[SceneAddViewController alloc] init];
//                                                           sceneAddVC.filtersImg = photo;
//                                                           [self.Nav pushViewController:sceneAddVC animated:YES];
                                                       }
                                                       
                                                   }];
}

#pragma mark 拍摄后裁剪照片尺寸
- (UIImage *)cropImage:(UIImage *)image withCropSize:(CGSize)cropSize {
    UIImage *newImage = nil;
    
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = cropSize.width;
    CGFloat targetHeight = cropSize.height;
    
    CGFloat scaleFactor = 0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0, 0);
    
    if (CGSizeEqualToSize(imageSize, cropSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor;
        } else {
            scaleFactor = heightFactor;
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * .5f;
        } else {
            if (widthFactor < heightFactor) {
                thumbnailPoint.x = (targetWidth - scaledWidth) * .5f;
            }
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(cropSize, YES, 0);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [image drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark 获取设备的方向
- (AVCaptureVideoOrientation)photoDeviceOrientation:(UIDeviceOrientation)deviceOrientation {
    AVCaptureVideoOrientation videoOrientation = (AVCaptureVideoOrientation)deviceOrientation;
    if (deviceOrientation == UIDeviceOrientationLandscapeLeft) {
        videoOrientation = AVCaptureVideoOrientationLandscapeRight;
        
    } else if (deviceOrientation == UIDeviceOrientationLandscapeRight) {
        videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
    }
    return videoOrientation;
}


#pragma mark - 初始化相机
- (void)setCamere {
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device isFlashAvailable]) {
        [device lockForConfiguration:nil];
        //设置闪光灯为关闭
        [device setFlashMode:AVCaptureFlashModeOff];
        [device unlockForConfiguration];
        
        //  初始化数据连接
        self.session = [[AVCaptureSession alloc] init];
        //  初始化设备
        AVCaptureDevice * cameraDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        //  初始化输入设备
        self.cameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:cameraDevice error:nil];
        //  初始化图片输出
        self.photosOutput = [[AVCaptureStillImageOutput alloc] init];
        
        //  输出图像设置
        NSDictionary * outputSet = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
        [self.photosOutput setOutputSettings:outputSet];
        
        if ([self.session canAddInput:self.cameraInput]) {
            [self.session addInput:self.cameraInput];
        }
        if ([self.session canAddOutput:self.photosOutput]) {
            [self.session addOutput:self.photosOutput];
        }
        
        //  初始化预览图层
        self.previewPhoto = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        [self.previewPhoto setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        self.previewPhoto.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
        [self.previewView.layer addSublayer:self.previewPhoto];
        
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"相机错误" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}


@end
