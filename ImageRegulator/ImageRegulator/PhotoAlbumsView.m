//
//  PhotoAlbumsView.m
//  ImageRegulator
//
//  Created by dong on 2017/3/29.
//  Copyright © 2017年 dong. All rights reserved.
//

#import "PhotoAlbumsView.h"
#import "Helper.h"
#import "PhotoAlbumsTableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoModel.h"

@interface PhotoAlbumsView () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation PhotoAlbumsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.photoAlbums = [NSMutableArray array];
        self.photosMarr = [NSMutableArray array];
        //  from "PictureView.m"
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPhotoAlbums:) name:@"photoAlbums" object:nil];
    }
    return self;
}
    
- (void)getPhotoAlbums:(NSNotification *)photoAlbums {
    self.photoAlbums = [photoAlbums object];
    [self addSubview:self.photoAlbumsTableView];
}
    
#pragma mark - 相册列表
- (UITableView *)photoAlbumsTableView {
    if (!_photoAlbumsTableView) {
        _photoAlbumsTableView = [[UITableView alloc] initWithFrame:self.bounds];
        _photoAlbumsTableView.delegate = self;
        _photoAlbumsTableView.dataSource = self;
        _photoAlbumsTableView.backgroundColor = [UIColor blackColor];
        
        UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        footView.backgroundColor = [UIColor blackColor];
        _photoAlbumsTableView.tableFooterView = footView;
    }
    return _photoAlbumsTableView;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.photoAlbums.count;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellId = @"PhotoAlbumsTableViewCell";
    PhotoAlbumsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!cell) {
        cell = [[PhotoAlbumsTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CellId];
    }
    [cell setPhotoAlbumsData:self.photoAlbums[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect openPhotoAlbumsRect = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-50);
    [UIView animateWithDuration:.3 animations:^{
        self.frame = openPhotoAlbumsRect;
        self.photoAlbumsBtn.selected = NO;
        self.nextBtn.hidden = NO;
    }];
    
    if (self.photosMarr.count > 0) {
        [self.photosMarr removeAllObjects];
    }
    [self getPhotoAlbumsAllPhotos:[self.photoAlbums[indexPath.row] valueForKey:@"group"]];
    [self.collectionView reloadData];
    //  默认选中照片列表第一个
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                      animated:YES
                                scrollPosition:(UICollectionViewScrollPositionNone)];
    
    // to "CreateViewController.h"
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PhotoAlbumsName" object:[self.photoAlbums[indexPath.row] valueForKey:@"name"]];
    
}
    
- (void)getPhotoAlbumsAllPhotos:(ALAssetsGroup *)group {
    NSMutableArray * marr = [NSMutableArray array];
    
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            PhotoModel * photo = [[PhotoModel alloc] init];
            photo.asset = result;
            [marr addObject:photo];
        }
    }];
    
    //  相片倒序排列
    NSEnumerator * enumerator = [marr reverseObjectEnumerator];
    while (id photoObj = [enumerator nextObject]) {
        [self.photosMarr addObject:photoObj];
    }
    
    if (self.photosMarr.count) {
        //  默认加载第一张照片
        PhotoModel * firstPhoto = [self.photosMarr objectAtIndex:0];
        self.showImageView.image = firstPhoto.originalImage;
    }
}
    
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"photoAlbums" object:nil];
}


@end
