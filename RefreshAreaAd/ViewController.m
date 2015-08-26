//
//  ViewController.m
//  RefreshAreaAd
//
//  Created by 金城 尚志 on 2015/08/26.
//  Copyright © 2015年 Takashi Kinjo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    self.imgView.image = [UIImage imageNamed:@"Images/jump_comic_sample"];
}

@end
