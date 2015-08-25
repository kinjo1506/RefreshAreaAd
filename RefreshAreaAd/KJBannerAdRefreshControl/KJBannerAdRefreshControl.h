//
//  KJBannerAdRefreshControl.h
//  RefreshAreaAd
//
//  Created by 金城 尚志 on 2015/08/23.
//  Copyright © 2015年 Takashi Kinjo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KJBannerAdRefreshControl : UIControl

- (void)attachToScrollView:(UIScrollView *)root;
- (void)beginRefreshing;
- (void)endRefreshing;
- (BOOL)isRefreshing;
- (BOOL)isRefreshed;
- (BOOL)isRefreshingOrRefreshed;

@end
