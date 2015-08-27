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

@implementation ViewController {
}

- (NSArray *)viewItems {
    return
    @[
      // 花のち晴れ
      @[ @"Images/interstitial_01", @"http://plus.shonenjump.com/item/SHSA_ST01C88040200101_57.html" ],
      // Soul Scathers
      @[ @"Images/interstitial_02", @"http://plus.shonenjump.com/item_list.html?series_kana=ソウルキャッチャーズ" ],
      // 声優ましまし倶楽部
      @[ @"Images/interstitial_03", @"http://plus.shonenjump.com/item/SHSA_ST01C88034800101_57.html" ],
      // ケッパレ松原さん
      @[ @"Images/interstitial_04", @"http://plus.shonenjump.com/item/SHSA_ST01C88039400101_57.html" ],
      // 猫田びより
      @[ @"Images/interstitial_05", @"http://plus.shonenjump.com/item_list.html?series_kana=ネコタビヨリ" ],
      // ジョジョの奇妙な冒険
      @[ @"Images/interstitial_06", @"http://plus.shonenjump.com/item_list.html?series_kana=ジョジョノキミョウナボウケン01ダイ02ブ" ],
      // i-ショウジョ+
      @[ @"Images/interstitial_07", @"http://plus.shonenjump.com/item_list.html?series_kana=アイショウジョプラスカラーバン" ],
      // アナノムジナ
      @[ @"Images/interstitial_08", @"http://plus.shonenjump.com/item/SHSA_ST01C88044300201_57.html" ],
      // カラダ探し
      @[ @"Images/interstitial_09", @"http://plus.shonenjump.com/item_list.html?series_kana=カラダサガシ" ],
      // 食戟のソーマ
      @[ @"Images/interstitial_10", @"http://plus.shonenjump.com/item/SHSA_ST01C88053400101_57.html" ],
      // ヘタリア world stars
      @[ @"Images/interstitial_11", @"http://plus.shonenjump.com/item_list.html?series_kana=ヘタリアワールドスターズ" ],
      // るろうに剣心
      @[ @"Images/interstitial_12", @"http://plus.shonenjump.com/item_list.html?series_kana=ルロウニケンシンメイジケンカクロマンタン" ],
    ];
}

- (void)viewDidLoad {
    self.imgView.image = [UIImage imageNamed:@"Images/jump_comic_sample"];

    NSArray *item = self.viewItems[self.indexPath.row];
    self.loadingView = [[KJInterstitialLoadingView alloc] initWithImage:[UIImage imageNamed:item[0]]
                                                                    URL:[NSURL URLWithString:item[1]]];
    [self.view addSubview:self.loadingView];

    [self.loadingView beginLoading];
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^(void){
        [self.loadingView endLoading];
    });
}

@end
