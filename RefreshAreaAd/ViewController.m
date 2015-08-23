//
//  ViewController.m
//  RefreshAreaAd
//
//  Created by 金城 尚志 on 2015/08/23.
//  Copyright © 2015年 Takashi Kinjo. All rights reserved.
//

#import "ViewController.h"
#import "KJBannerAdRefreshControl.h"

@interface ViewController ()

@property (strong, nonatomic) KJBannerAdRefreshControl *adRefreshControl;
@property (strong, nonatomic) UIView *bannerRoot;
@property (strong, nonatomic) UIImageView *bannerView;

- (void)refresh:(id)sender;

@end

@implementation ViewController

#pragma mark - UIViewController events

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.bannerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jump_320x50"]];

    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:self.bannerView.bounds];
    self.refreshControl.backgroundColor = [UIColor lightGrayColor];
    [self.refreshControl addTarget:self
                            action:@selector(refresh:)
                  forControlEvents:UIControlEventValueChanged];

    self.bannerRoot = [[UIView alloc] initWithFrame:self.refreshControl.frame];
    self.bannerRoot.clipsToBounds = YES;
    [self.refreshControl addSubview:self.bannerRoot];

    self.bannerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jump_320x50"]];
    [self.bannerRoot addSubview:self.bannerView];
}

- (void)viewDidUnload
{
    self.adRefreshControl = nil;
    
    [super viewDidUnload];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Get the current size of the refresh controller
    CGRect refreshBounds = self.refreshControl.bounds;
    
    // Distance the table has been pulled >= 0
    CGFloat pullDistance = MAX(0.0, -self.refreshControl.frame.origin.y);
    
    // Half the width of the table
    CGFloat midX = self.tableView.frame.size.width / 2.0;
    
    // Calculate the width and height of our graphics
    CGFloat bannerHeight = self.bannerView.bounds.size.height;
    CGFloat bannerHeightHalf = bannerHeight / 2.0;
    
    CGFloat bannerWidth = self.bannerView.bounds.size.width;
    
    // Calculate the pull ratio, between 0.0-1.0
    CGFloat pullRatio = MIN( MAX(pullDistance, 0.0), 100.0) / 100.0;
    
    // Set the Y coord of the graphics, based on pull distance
    CGFloat bannerY = MIN(0.0, (pullDistance / 2.0 - bannerHeightHalf));
    
    // Calculate the X coord of the graphics, adjust based on pull ratio
    CGFloat bannerX = midX - bannerWidth;
    
    // Set the graphic's frames
    CGRect bannerFrame = self.bannerView.frame;
    bannerFrame.origin.y = bannerY;

    self.bannerView.frame = bannerFrame;
    
    // Set the encompassing view's frames
    refreshBounds.size.height = pullDistance;
    
    self.bannerRoot.frame = refreshBounds;
//    self.refreshColorView.frame = refreshBounds;
//    self.refreshLoadingView.frame = refreshBounds;
//    
//    // If we're refreshing and the animation is not playing, then play the animation
//    if (self.refreshControl.isRefreshing && !self.isRefreshAnimating) {
//        [self animateRefreshView];
//    }

    NSLog(@"refreshBounds:%@ pullDistance:%.2f", NSStringFromCGRect(refreshBounds), pullDistance);
}

#pragma mark -

- (void)refresh:(id)sender {
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^(void){
        [self.refreshControl endRefreshing];
    });
}

@end
