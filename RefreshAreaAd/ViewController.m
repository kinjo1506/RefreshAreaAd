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

- (void)refresh:(id)sender;

@end

@implementation ViewController

#pragma mark - UIViewController events

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refresh:)
                  forControlEvents:UIControlEventValueChanged];

    UIView *adView = [[UIView alloc] initWithFrame:self.refreshControl.bounds];
    adView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    adView.clipsToBounds = YES;
    [self.refreshControl addSubview:adView];
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
