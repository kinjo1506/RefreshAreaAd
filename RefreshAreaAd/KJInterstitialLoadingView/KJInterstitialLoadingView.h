//
//  KJInterstitialLoadingView.h
//  RefreshAreaAd
//
//  Created by kinjo on 2015/08/27.
//  Copyright © 2015年 Takashi Kinjo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KJInterstitialLoadingView : UIView

- (void)beginLoading;
- (void)endLoading;
- (BOOL)isLoading;

@end
