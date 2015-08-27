//
//  KJBannerAdRefreshControl.m
//  RefreshAreaAd
//
//  Created by 金城 尚志 on 2015/08/23.
//  Copyright © 2015年 Takashi Kinjo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KJBannerAdRefreshControl.h"

typedef NS_ENUM(NSInteger, KJRefreshingState) {
    KJRefreshingStateDefault,
    KJRefreshingStateRefreshing,
    KJRefreshingStateRefreshed,
};

static const CGFloat kMarginTopOfIcon = 10.0;

@interface KJBannerAdRefreshControl()

@property (strong, nonatomic) UIImageView *bannerView;
@property (strong, nonatomic) UIImageView *refreshIconView;

@property (nonatomic) CGFloat threshold;
@property (nonatomic) CGFloat contentHeight;
@property (nonatomic) BOOL didExceedThreshold;
@property (nonatomic) CGFloat originalIconAngle;
@property (nonatomic) KJRefreshingState refreshingState;

- (CGFloat)pullDistance;
- (void)layoutViews;
- (void)refreshIfExceedThreshold;
- (void)animateRefreshing;
- (void)endAnimateRefreshing;

@end

@implementation KJBannerAdRefreshControl

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0.0, 0.0, 320.0, 100.0);

    self.bannerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/jump_banner_320x120"]];
    self.bannerView.hidden = YES; // TODO: なぜか初期位置にゴミが残るので最初は非表示にしておく
    self.bannerView.userInteractionEnabled = YES;
    [self addSubview:self.bannerView];

    self.refreshIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/refresh_icon_01"]];
    self.refreshIconView.hidden = YES; // TODO: なぜか初期位置にゴミが残るので最初は非表示にしておく
    [self addSubview:self.refreshIconView];

    // 更新開始のしきい値はアイコンの高さ + マージン
    self.threshold = -(self.refreshIconView.bounds.size.height + kMarginTopOfIcon);
    // コンテンツの高さはアイコン + マージン + バナー
    self.contentHeight = -(self.refreshIconView.bounds.size.height + kMarginTopOfIcon + self.bannerView.bounds.size.height);

    self.refreshingState = KJRefreshingStateDefault;

    CGAffineTransform transform = self.refreshIconView.transform;
    self.originalIconAngle = atan2(transform.a, transform.b);
}

- (void)attachToScrollView:(UIScrollView *)root {
    [root addSubview:self];
}

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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.bannerView isEqual:[[touches anyObject] view]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.shonenjump.com/p/sp/comics/"]];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (object == self.superview && [keyPath isEqualToString:@"contentOffset"]) {
        [self.superview bringSubviewToFront:self];
        [self layoutViews];
        [self refreshIfExceedThreshold];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark -

- (CGFloat)pullDistance {
    CGFloat defaultOffsetY = -64; // TODO: Navigation Bar 有無に合わせて動的に値を決める
    CGFloat contentOffsetY = ((UIScrollView *)self.superview).contentOffset.y;

    return contentOffsetY - defaultOffsetY;
}

- (void)layoutViews {
    CGFloat pullDistance = MIN([self pullDistance], 0.0);
    CGRect rootViewFrame = self.bounds;

    // 自身のサイズは scroll view をひっぱった分
    rootViewFrame.size.height = pullDistance;
    self.frame = rootViewFrame;

    CGFloat horizontalCenter = self.frame.size.width  / 2.0;

    // refresh icon をスクロールに追従させる
    CGFloat refreshIconWidth  = self.refreshIconView.bounds.size.width;
    CGFloat refreshIconHeight = self.refreshIconView.bounds.size.height;
    CGFloat refreshIconX = horizontalCenter - (refreshIconWidth  / 2.0);
    CGFloat refreshIconY = -rootViewFrame.size.height - refreshIconHeight;

    CGRect refreshIconFrame = self.refreshIconView.frame;
    refreshIconFrame.origin.x = refreshIconX;
    refreshIconFrame.origin.y = refreshIconY;
    self.refreshIconView.frame = refreshIconFrame;
    self.refreshIconView.hidden = NO;

    // banner view を refresh icon の上に表示 ( 全部表示されたあとは画面上部に固定 )
    CGFloat bannerViewWidth  = self.bannerView.bounds.size.width;
    CGFloat bannerViewHeight = self.bannerView.bounds.size.height;
    CGFloat bannerViewX = horizontalCenter - (bannerViewWidth  / 2.0);
    CGFloat bannerViewY = MIN(0.0, -rootViewFrame.size.height - refreshIconHeight - kMarginTopOfIcon - bannerViewHeight);
    
    CGRect bannerViewFrame = self.bannerView.frame;
    bannerViewFrame.origin.x = bannerViewX;
    bannerViewFrame.origin.y = bannerViewY;
    self.bannerView.frame = bannerViewFrame;
    self.bannerView.hidden = NO;
}

- (void)refreshIfExceedThreshold {
    @synchronized(self) {
        // すでに更新中なら何もしない
        if ([self isRefreshingOrRefreshed]) { return; }
    }

    UIScrollView *scrollView = (UIScrollView *)self.superview;
    if (scrollView.isTracking) {
        self.didExceedThreshold = ([self pullDistance] < self.threshold);
    }
    else {
        // しきい値を超えた位置で scrollView から指を離したら、更新開始
        if (self.didExceedThreshold) {
            self.didExceedThreshold = NO;
            [self beginRefreshing];
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}

- (void)beginRefreshing {
    @synchronized(self) {
        // すでに更新中なら何もしない
        if ([self isRefreshingOrRefreshed]) { return; }
        self.refreshingState = KJRefreshingStateRefreshing;
    }

    UIScrollView *scrollView = (UIScrollView *)self.superview;
    UIEdgeInsets insets = scrollView.contentInset;
    insets.top += -self.contentHeight;

    // バナーが隠れている場合にスクロールして完全に表示するため、 offset を調整する
    CGPoint offset = scrollView.contentOffset;
    offset.y = -insets.top;

    [UIView animateWithDuration:0.3f
                     animations:^{
                         scrollView.contentInset = insets;
                         scrollView.contentOffset = offset;
                     }
                     completion:^(BOOL finished) {
                         // ロード中アニメーション...
                         [self animateRefreshing];
                     }];
}

- (void)endRefreshing {
    @synchronized(self) {
        // 更新中でなければ何もしない
        if (![self isRefreshingOrRefreshed]) { return; }
        self.refreshingState = KJRefreshingStateRefreshed;
    }

    // ここではまだロード中アニメーションを止めない
}

- (void)animateRefreshing {
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.refreshIconView setTransform:CGAffineTransformRotate(self.refreshIconView.transform, M_PI_2)];
                     }
                     completion:^(BOOL finished) {
                         CGAffineTransform transform = self.refreshIconView.transform;
                         BOOL isOriginalAngle = (fabs(atan2(transform.a, transform.b) - self.originalIconAngle) < 0.001);
                         if (isOriginalAngle && [self isRefreshed]) {
                             // ロード完了
                             [self endAnimateRefreshing];
                         }
                         else {
                             // まだロード中
                             [self animateRefreshing];
                         }
                     }];
}

- (void)endAnimateRefreshing {
    UIScrollView *scrollView = (UIScrollView *)self.superview;
    UIEdgeInsets insets = scrollView.contentInset;
    insets.top -= -self.contentHeight;

    // 画像を入れ替えて、少し置いてから insets を元に戻す
    self.refreshIconView.image = [UIImage imageNamed:@"Images/refresh_icon_02"];
    [UIView animateWithDuration:0.3f
                          delay:1.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         scrollView.contentInset = insets;
                     }
                     completion:^(BOOL finished) {
                         @synchronized(self) {
                             self.refreshIconView.image = [UIImage imageNamed:@"Images/refresh_icon_01"];
                             self.refreshingState = KJRefreshingStateDefault;
                         }
                     }];
}

- (BOOL)isRefreshing {
    return self.refreshingState == KJRefreshingStateRefreshing;
}

- (BOOL)isRefreshed {
    return self.refreshingState == KJRefreshingStateRefreshed;
}

- (BOOL)isRefreshingOrRefreshed {
    return [self isRefreshing] || [self isRefreshed];
}
@end
