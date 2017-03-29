//
//  PhotoAlbumsView.h
//  ImageRegulator
//
//  Created by dong on 2017/3/29.
//  Copyright © 2017年 dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoAlbumsView : UIView

@property(nonatomic,strong) UITableView         *   photoAlbumsTableView;    //     相册列表
@property(nonatomic,strong) NSMutableArray      *   photoAlbums;             //     相薄

@property(nonatomic,strong) UIButton            *   photoAlbumsBtn;          //     相薄的相册按钮
@property(nonatomic,strong) UIButton            *   nextBtn;                 //     下一步的按钮
@property(nonatomic,strong) UICollectionView    *   collectionView;          //     相册列表
@property(nonatomic,strong) UIImageView         *   showImageView;           //     展示的图片视图
@property(nonatomic,strong) NSMutableArray      *   photosMarr;
    
@end
