//
//  XDPlayer.h
//  MusicPlayerDemo
//
//  Created by Heaton on 2018/1/22.
//  Copyright © 2018年 WangMingDeveloper. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "XDMusicModel.h"
#import <Foundation/Foundation.h>
#import "XDPlayerDefine.h"
@class XDPlayer;
typedef NS_ENUM(NSInteger, XDPlayerPlayType) {
    XDPlayerTypeRepeatAll,   // 按顺序播放
    XDPlayerTypeSingleCycle, // 单曲循环
    XDPlayerTypeRandom       // 随机播放
};
typedef NS_ENUM(NSInteger, XDMusicSortType) {
    XDMusicSortTypeName,
    XDMusicSortTypeTime,
    XDMusicSortTypeCustom,
    XDMusicSortTypeCount
};
typedef void (^XDPlayerInitFishBlock)(NSArray<XDMusicModel *> *currentPlayList);
typedef void (^XDPlayerStopPlayBlock)(XDPlayer *player,NSUInteger currentIndex);
typedef void (^XDPlayerStartPlayBlock)(XDPlayer *player,NSUInteger currentIndex,NSString *totalTime,NSString *musicName,NSString *artist);
typedef void (^XDPlayerProgressBlock)(XDPlayer *player,CGFloat currentProgress,NSString *playingTime);
typedef void (^XDPlayerPlayWithIndexBlock)(XDPlayer *player,NSUInteger currentIndex);
typedef void (^XDPlayerFinishWithIndexBlock)(XDPlayer *player,NSUInteger currentIndex);
typedef void (^XDPlayerInterruptWithIndexBlock)(XDPlayer *player,NSUInteger currentIndex);
typedef void (^XDPlayerPlayFailWithIndexBlock)(XDPlayer *player,NSError *error);
typedef void (^XDPlayerRefreshMusicListBlock)(XDPlayer *player,NSArray<XDMusicModel *> *musicArray);
typedef void (^XDPlayerMusicListChangedBlock)(XDPlayer *player,NSArray<XDMusicModel *> *musicArray,NSUInteger newIndexInList);

@interface XDPlayer : NSObject
@property(nonatomic,strong,readonly) NSURL *currentPlayingURL;// 当前播放歌曲URL
@property(nonatomic,copy,readonly) NSArray<XDMusicModel *> *currentPlayList;// 当前播放列表
@property(nonatomic,assign,readonly) BOOL isPlaying; // 是否正在播放
@property(nonatomic,assign) NSInteger pan;// 声道设置
@property(nonatomic,assign) float volume; // 音量
@property(nonatomic,assign) XDMusicSortType sortType; // 音乐分类
@property(nonatomic,assign) XDPlayerPlayType playType;// 播放模式
@property(nonatomic,copy) XDPlayerStartPlayBlock blockstartPlay;             // 开始进度回调
@property(nonatomic,copy) XDPlayerStopPlayBlock blockStopPlay;              // 开始进度回调
@property(nonatomic,copy) XDPlayerProgressBlock blockProgress;               // 播放进度回调
@property(nonatomic,copy) XDPlayerPlayWithIndexBlock blockPlayerWithIndex;   // 播放当前歌曲回调
@property(nonatomic,copy) XDPlayerFinishWithIndexBlock blockPlayFish;        // 播放完成回调
@property(nonatomic,copy) XDPlayerPlayFailWithIndexBlock blockPlayFail;      // 播放失败回调
@property(nonatomic,copy) XDPlayerInterruptWithIndexBlock blockInterrupt;    // 播放中断回调
@property(nonatomic,copy) XDPlayerMusicListChangedBlock blockMusicListChange;// 歌曲列表更新回调
@property(nonatomic,copy) XDPlayerRefreshMusicListBlock blockRefreshList;   //  刷新列表回调
-(instancetype)initWithFish:(XDPlayerInitFishBlock)fishBlock;
- (void)playNext;// 播放下一首
- (void)playLast;// 播放上一首
- (void)playWithIndex:(NSInteger)index;// 从选中索引开始播放
- (void)playAtProgress:(float)progress;// 从指定位置开始播放

- (void)play; // 播放
- (void)pause;// 暂停
- (void)stopPlay;// 停止
- (void)refreshMusicList;// 顺序列表
@end
