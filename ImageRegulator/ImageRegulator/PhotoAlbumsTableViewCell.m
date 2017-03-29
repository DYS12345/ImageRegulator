//
//  PhotoAlbumsTableViewCell.m
//  ImageRegulator
//
//  Created by dong on 2017/3/29.
//  Copyright © 2017年 dong. All rights reserved.
//

#import "PhotoAlbumsTableViewCell.h"
#import "Masonry/Masonry/Masonry.h"

@implementation PhotoAlbumsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        
        [self addSubview:self.coverImage];
        [_coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.left.equalTo(self.mas_left).with.offset(15);
            make.centerY.equalTo(self);
        }];
        
        [self addSubview:self.titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150, 15));
            make.left.equalTo(self.coverImage.mas_right).with.offset(15);
            make.centerY.equalTo(self.coverImage);
        }];
        
        [self addSubview:self.photoCount];
        [_photoCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 15));
            make.right.equalTo(self.mas_right).with.offset(-15);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}
    
- (void)setPhotoAlbumsData:(NSDictionary *)photoAlbum {
    UIImage * coverImage = [UIImage imageWithData:[photoAlbum valueForKey:@"coverImage"]];
    self.coverImage.image = coverImage;
    self.titleLab.text = [photoAlbum valueForKey:@"name"];
    self.photoCount.text = [photoAlbum valueForKey:@"count"];
}
    
#pragma mark - 相册封面
- (UIImageView *)coverImage {
    if (!_coverImage) {
        _coverImage = [[UIImageView alloc] init];
    }
    return _coverImage;
}
    
#pragma mark - 相册名称
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.font = [UIFont systemFontOfSize:14];
    }
    return _titleLab;
}
    
#pragma mark - 相册内图片数量
- (UILabel *)photoCount {
    if (!_photoCount) {
        _photoCount = [[UILabel alloc] init];
        _photoCount.textColor = [UIColor grayColor];
        _photoCount.font = [UIFont systemFontOfSize:14];
        _photoCount.textAlignment = NSTextAlignmentRight;
    }
    return _photoCount;
}
    
@end
