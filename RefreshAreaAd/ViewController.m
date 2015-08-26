//
//  ViewController.m
//  RefreshAreaAd
//
//  Created by 金城 尚志 on 2015/08/26.
//  Copyright © 2015年 Takashi Kinjo. All rights reserved.
//

#import "KJInterstitialLoadingView.h"
#import "ViewController.h"

@interface ViewController()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (strong, nonatomic) KJInterstitialLoadingView *loadingView;

@end

@implementation ViewController

- (void)viewDidLoad {
    self.imgView.image = [UIImage imageNamed:@"Images/jump_comic_sample"];

    self.loadingView = [[KJInterstitialLoadingView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.loadingView];

    [self.loadingView beginLoading];
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^(void){
        [self.loadingView endLoading];
    });
}

@end
