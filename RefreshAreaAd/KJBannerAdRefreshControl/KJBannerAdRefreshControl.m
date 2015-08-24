//
//  KJBannerAdRefreshControl.m
//  RefreshAreaAd
//
//  Created by 金城 尚志 on 2015/08/23.
//  Copyright © 2015年 Takashi Kinjo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KJBannerAdRefreshControl.h"

#define DEFAULT_IMPL NO

@interface KJBannerAdRefreshControl()

@property (strong, nonatomic) UIImageView *bannerView;

- (void)keepOnTop;

@end

@implementation KJBannerAdRefreshControl

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.clipsToBounds = YES;

    self.bannerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jump_320x50"]];
    self.frame = self.bannerView.frame;
    [self addSubview:self.bannerView];
}

#pragma mark - UIView events

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (DEFAULT_IMPL) { [super willMoveToSuperview:newSuperview]; }

    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        [self.superview removeObserver:self forKeyPath:@"contentOffset"];
    }
}

- (void)didMoveToSuperview {
    if (DEFAULT_IMPL) { [super didMoveToSuperview]; }

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
        [self.superview bringSubviewToFront:self];
        [self keepOnTop];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark -

- (void)keepOnTop {
    NSLog(@"contentOffset:%@ self.frame:%@",
          NSStringFromCGPoint([(UIScrollView *)self.superview contentOffset]),
          NSStringFromCGRect(self.frame));

    CGFloat defaultOffsetY = -64; // TODO

    CGFloat contentOffsetY = [(UIScrollView *)self.superview contentOffset].y;
    CGFloat frameOriginY = MIN(contentOffsetY - defaultOffsetY, -self.frame.size.height);
    self.frame = CGRectMake(self.frame.origin.x, frameOriginY, self.frame.size.width, self.frame.size.height);
}

@end
