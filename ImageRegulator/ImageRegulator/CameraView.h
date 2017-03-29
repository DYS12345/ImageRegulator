//
//  CameraView.h
//  ImageRegulator
//
//  Created by dong on 2017/3/29.
//  Copyright © 2017年 dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@interface CameraView : UIView

@property(nonatomic,strong) UINavigationController      *   Nav;
@property(nonatomic,strong) UIViewController            *   VC;
@property(nonatomic,strong) UIView                      *   previewView;
@property(nonatomic,strong) UIView                      *   cameraNavView;      //  顶部导航
@property(nonatomic,strong) UIButton                    *   cameraCancelBtn;    //  取消按钮
@property(nonatomic,strong) UILabel                     *   cameraTitlt;        //  页面标题
@property(nonatomic,strong) UIButton                    *   takePhotosBtn;      //  拍照按钮
@property(nonatomic,strong) UIButton                    *   flashBtn;           //  闪光灯按钮
@property(nonatomic,strong) UIButton                    *   selfTimerBtn;       //  自拍按钮
@property(nonatomic,strong) AVCaptureSession            *   session;            //  输入&输出之间的数据传递
@property(nonatomic,strong) AVCaptureDeviceInput        *   cameraInput;        //  图像输入设备
@property(nonatomic,strong) AVCaptureStillImageOutput   *   photosOutput;       //  照片输出
@property(nonatomic,strong) AVCaptureVideoPreviewLayer  *   previewPhoto;       //  预览照片图层
    
@end
