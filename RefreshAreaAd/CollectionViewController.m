//
//  CollectionViewController.m
//  RefreshAreaAd
//
//  Created by kinjo on 2015/08/23.
//  Copyright © 2015年 Takashi Kinjo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CollectionViewController.h"
#import "KJBannerAdRefreshControl.h"
#import "ViewController.h"

@interface CollectionViewController()

@property (strong, nonatomic) KJBannerAdRefreshControl *refreshControl;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    self.refreshControl = [[KJBannerAdRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl attachToScrollView:self.collectionView];
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self collectionView:collectionView
               dequeueReusableCellWithReuseIdentifier:@"Cell"
                                         forIndexPath:indexPath];

    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    NSString *imgName = [NSString stringWithFormat:@"Images/jump_comics_%02d.png", (int) (indexPath.row + 1)];
    imageView.image = [UIImage imageNamed:imgName];

    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SampleViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark -

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
  dequeueReusableCellWithReuseIdentifier:(NSString *)identifier
                            forIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                                           forIndexPath:indexPath];
    cell.layer.borderWidth = 0.5f;
    cell.layer.cornerRadius = 5;
    cell.layer.masksToBounds = YES;

    return cell;
}

- (void)onRefresh:(id)sender {
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^(void){
        [self.refreshControl endRefreshing];
    });
}

@end
