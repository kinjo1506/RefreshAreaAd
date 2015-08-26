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

@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic) UILabel *loadingText;
@property (strong, nonatomic) UIView *loadingLabelView;

@property (nonatomic) KJLoadingState loadingState;

@end

@implementation KJInterstitialLoadingView

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
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];

    self.loadingText = [[UILabel alloc] init];
    self.loadingText.text = @"ロードしています...";
    [self addSubview:self.loadingText];

    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.indicatorView.hidden = YES;
    [self.indicatorView setCenter:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
    [self addSubview:self.indicatorView];

    NSLayoutConstraint *layoutBaseline = [NSLayoutConstraint constraintWithItem:self.loadingText
                                                                      attribute:NSLayoutAttributeBaseline
                                                                      relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.indicatorView
                                                                      attribute:NSLayoutAttributeBaseline
                                                                     multiplier:1.0
                                                                       constant:0.0];
    [self.indicatorView addConstraint:layoutBaseline];
}

- (void)beginLoading {
    @synchronized(self) {
        if (self.isLoading) { return; }
        self.loadingState = KJLoadingStateLoading;
    }

    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
    self.indicatorView.hidden = NO;
    [self.indicatorView startAnimating];
}

- (void)endLoading {
    @synchronized(self) {
        if (!self.isLoading) { return; }
        self.loadingState = KJLoadingStateDefault;
    }

    [UIView animateWithDuration:0.3
                     animations:^{
                         self.backgroundColor = [UIColor clearColor];
                         self.indicatorView.hidden = YES;
                         [self.indicatorView stopAnimating];
                     }];
}

- (BOOL)isLoading {
    @synchronized(self) {
        return (self.loadingState == KJLoadingStateLoading);
    }
}

#pragma mark - UIView events

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    if ([self.bannerView isEqual:[[touches anyObject] view]]) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.shonenjump.com/p/sp/comics/"]];
//    }
}

#pragma mark -

@end
