//
//  PhotoModel.h
//  ImageRegulator
//
//  Created by dong on 2017/3/29.
//  Copyright © 2017年 dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoModel : NSObject

@property (nonatomic, readonly) UIImage         *       thumbnailImage;     //  缩略图
@property (nonatomic, readonly) UIImage         *       originalImage;      //  原始图
@property (nonatomic, strong) ALAsset           *       asset;              //  相片对象
    
@end
