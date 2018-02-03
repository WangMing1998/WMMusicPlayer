//
//  XDPlayerView.h
//  MusicPlayerDemo
//
//  Created by Heaton on 2018/1/23.
//  Copyright © 2018年 WangMingDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDMusicModel;
typedef NS_ENUM(NSUInteger,XDPlayType){
    XDPlayTypeRepeatAll,
    XDPlayTypeSingCycle,
    XDPlayTypeRandom
};
typedef void(^XDPlayerViewPlayButtonBlock)(UIButton *sender); // 播放按钮事件
typedef void(^XDPlayerViewNextButtonBlock)(UIButton *sender); // 下一首按钮事件
typedef void(^XDPlayerViewLastButtonBlock)(UIButton *sender); // 上一首按钮事件
typedef void(^XDPlayerViewModelButtonBlock)(UIButton *sender,XDPlayType type);// 播放模式按钮事件
typedef void(^XDPlayerViewSortlButtonBlock)(UIButton *sender);// 音乐分类按钮事件
typedef void(^XDPlayerViewVolumeChangeBlock)(UISlider *sender);  // 音量事件
typedef void(^XDPlayerViewProgressChangeBlock)(UISlider *sender);// 进度事件
typedef void(^XDPlayerViewDidSelectedBlock)(NSUInteger index);   // 选中事件
typedef void (^XDPlayerSliderTouchDownBlock)(UISlider *slider);
typedef void (^XDPlayerSliderTouchUpInsideBlock)(UISlider *slider);
typedef void (^XDPlayerSliderTouchUpOutsideBlock)(UISlider *slider);

@interface XDPlayerView : UIView
@property(nonatomic,strong) UILabel  *labelTotalTime;  // 音乐总时长
@property(nonatomic,strong) UILabel  *labelPlayingTime;// 已经播放事件
@property(nonatomic,strong) UILabel  *labelAritst;   // 歌手名
@property(nonatomic,strong) UILabel  *labelMusicName;// 歌曲名
@property(nonatomic,strong) UISlider *sliderProgress;// 播放进度条
@property(nonatomic,strong) UISlider *sliderVolume; // 音量条
@property(nonatomic,strong) UITableView *tableViewMusicList; // 歌曲列表
@property(nonatomic,strong) NSMutableArray<XDMusicModel *> *dataSource; // 数据源
@property(nonatomic,assign) XDPlayType playType;
@property(nonatomic,assign) BOOL isPlaying;
@property(nonatomic,copy) XDPlayerViewPlayButtonBlock blockPlayerButton;
@property(nonatomic,copy) XDPlayerViewLastButtonBlock blockLastButton;
@property(nonatomic,copy) XDPlayerViewNextButtonBlock blockNextButton;
@property(nonatomic,copy) XDPlayerViewModelButtonBlock blockModelButton;
@property(nonatomic,copy) XDPlayerViewSortlButtonBlock blockSortButton;

@property(nonatomic,copy) XDPlayerViewVolumeChangeBlock blockVolumeChange;
@property(nonatomic,copy) XDPlayerViewProgressChangeBlock blockProgressChange;
@property(nonatomic,copy) XDPlayerViewDidSelectedBlock blockDidSelected;

-(CGFloat)getVolume;

@end
