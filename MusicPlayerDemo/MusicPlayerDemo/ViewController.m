//
//  ViewController.m
//  MusicPlayerDemo
//
//  Created by Heaton on 2018/1/22.
//  Copyright © 2018年 WangMingDeveloper. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "XDPlayer.h"
#import "XDPlayerView.h"
@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    XDPlayerView *playerView = [[XDPlayerView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    [self.view addSubview:playerView];
    
    XDPlayer *player = [[XDPlayer alloc] initWithFish:^(NSArray<XDMusicModel *> *currentPlayList) {
        [playerView.dataSource addObjectsFromArray:currentPlayList];
        [playerView.tableViewMusicList reloadData];
    }];
    
    player.blockstartPlay = ^(XDPlayer *player, NSUInteger currentIndex, NSString *totalTime, NSString *musicName, NSString *artist) {
        playerView.labelTotalTime.text = totalTime;
        playerView.labelMusicName.text = musicName;
        playerView.labelAritst.text = artist;
    };
    
    // 播放进度回调
    player.blockProgress = ^(XDPlayer *player, CGFloat currentProgress,NSString *playingTime) {
        playerView.sliderProgress.value = currentProgress;
        playerView.labelPlayingTime.text = playingTime;
        NSLog(@"播放进度:%.2f\n",currentProgress);
    };
    
    player.blockStopPlay = ^(XDPlayer *player, NSUInteger currentIndex) {
        playerView.isPlaying = NO;
    };
    
    
    
    // 播放/暂停
    playerView.blockPlayerButton = ^(UIButton *sender) {
        if(sender.selected){
            [player play];
        }else{
            [player pause];
        }
    };
    
    // 下一首
    playerView.blockNextButton = ^(UIButton *sender) {
        [player playNext];
    };
    
    // 上一首
    playerView.blockLastButton = ^(UIButton *sender) {
        [player playLast];
    };
    
    // 选择歌曲
    playerView.blockDidSelected = ^(NSUInteger index) {
        [player playWithIndex:index];
    };
   
    // 模式设置
    playerView.blockModelButton = ^(UIButton *sender, XDPlayType type) {
        switch (type) {
            case XDPlayTypeRandom:
                player.playType = XDPlayerTypeRandom;
                break;
            case XDPlayTypeSingCycle:
                player.playType = XDPlayerTypeSingleCycle;
                break;
            case XDPlayTypeRepeatAll:
                player.playType = XDPlayerTypeRepeatAll;
                break;
            default:
                break;
        }
    };
    
    playerView.blockProgressChange = ^(UISlider *sender) {
        [player playAtProgress:sender.value];
    };

}

@end
