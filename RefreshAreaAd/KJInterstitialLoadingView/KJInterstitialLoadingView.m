//
//  KJInterstitialLoadingView.m
//  RefreshAreaAd
//
//  Created by kinjo on 2015/08/27.
//  Copyright © 2015年 Takashi Kinjo. All rights reserved.
//

#import "KJInterstitialLoadingView.h"

typedef NS_ENUM(NSInteger, KJLoadingState) {
    KJLoadingStateDefault,
    KJLoadingStateLoading,
};

@interface KJInterstitialLoadingView()

@property (strong, nonatomic) UIView *loadingView;
@property (weak, nonatomic) UIImageView *interstitialView;
@property (copy, nonatomic) NSURL *url;

@property (nonatomic) KJLoadingState loadingState;

@end

@implementation KJInterstitialLoadingView

- (instancetype)init {
    return [self initWithImage:nil URL:nil];
}

- (instancetype)initWithImage:(UIImage *)img URL:(NSURL *)url {
    self = [super init];
    if (self) {
        UINib *nib = [UINib nibWithNibName:@"KJInterstitialLoadingView" bundle:nil];
        self.loadingView = [nib instantiateWithOwner:self options:nil][0];
        
        // 最初は非表示
        self.loadingView.alpha = 0;
        self.loadingView.hidden = YES;
        
        self.interstitialView = (UIImageView *)[self.loadingView viewWithTag:1];
        self.interstitialView.image = img;
        self.interstitialView.userInteractionEnabled = YES;
        self.interstitialView.layer.borderWidth = 0.5f;
        self.interstitialView.layer.cornerRadius = 5;
        self.interstitialView.layer.masksToBounds = YES;
        [self addSubview:self.loadingView];

        self.url = url;
    }
    return self;
}


- (void)beginLoading {
    @synchronized(self) {
        if (self.isLoading) { return; }
        self.loadingState = KJLoadingStateLoading;
    }

    // 表示する
    self.loadingView.alpha = 1;
    self.loadingView.hidden = NO;
}

- (void)endLoading {
    @synchronized(self) {
        if (!self.isLoading) { return; }
        self.loadingState = KJLoadingStateDefault;
    }

    // フェードアウトしたあと非表示にする
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.loadingView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         self.loadingView.hidden = YES;
                     }];
}

- (BOOL)isLoading {
    @synchronized(self) {
        return (self.loadingState == KJLoadingStateLoading);
    }
}

#pragma mark - UIView events

- (void)didMoveToSuperview {
    self.frame = self.superview.frame;
    self.loadingView.frame = self.bounds;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.interstitialView isEqual:[[touches anyObject] view]]) {
        [[UIApplication sharedApplication] openURL:self.url];
    }
}

#pragma mark -

@end
