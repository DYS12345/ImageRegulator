//
//  PhotoAlbumsTableViewCell.h
//  ImageRegulator
//
//  Created by dong on 2017/3/29.
//  Copyright © 2017年 dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoAlbumsTableViewCell : UITableViewCell

@property(nonatomic,strong) UIImageView     *   coverImage;       //    相册封面
@property(nonatomic,strong) UILabel         *   titleLab;         //    相册名称
@property(nonatomic,strong) UILabel         *   photoCount;       //    相片数量
    
- (void)setPhotoAlbumsData:(NSDictionary *)photoAlbum;
    
@end
