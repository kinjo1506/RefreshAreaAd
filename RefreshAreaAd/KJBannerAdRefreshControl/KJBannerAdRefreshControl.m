//
//  KJBannerAdRefreshControl.m
//  RefreshAreaAd
//
//  Created by 金城 尚志 on 2015/08/23.
//  Copyright © 2015年 Takashi Kinjo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KJBannerAdRefreshControl.h"

@implementation KJBannerAdRefreshControl

#pragma mark - UIView events

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        [self.superview removeObserver:self forKeyPath:@"contentOffset"];
    }
}

- (void)didMoveToSuperview {
    
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        [self.superview addObserver:self forKeyPath:@"contentOffset" options:0 context:NULL];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {

    if (object == self.superview && [keyPath isEqualToString:@"contentOffset"]) {
        NSLog(@"keyPath:%@ object:%@ change:%@ context:%@", keyPath, object, change, context);
        [self.superview bringSubviewToFront:self];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
