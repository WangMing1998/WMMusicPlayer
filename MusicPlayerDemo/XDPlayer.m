//
//  XDPlayer.m
//  MusicPlayerDemo
//
//  Created by Heaton on 2018/1/22.
//  Copyright © 2018年 WangMingDeveloper. All rights reserved.
//

#import "XDPlayer.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "XDFMDBManager.h"
#define SOUND_METER_COUNT       40
@interface XDPlayer()<AVAudioPlayerDelegate>{
    int soundMeters[40];
}
@property(nonatomic,assign) BOOL isSortChanged;
@property(nonatomic,assign) NSUInteger currentIndex;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) NSTimer *levelTimer;
@property(nonatomic,assign) NSTimeInterval timeCount;
@property(nonatomic,weak)   XDMusicModel *currentPlayItem;
@property(nonatomic,strong) AVAudioPlayer *player;
@end
@implementation XDPlayer
-(instancetype)initWithFish:(XDPlayerInitFishBlock)fishBlock{
    self = [super init];
    if(self){
        NSLog(@"加载开始");
        self.currentIndex = 0;   // 默认从第一首开始
        self.pan = 0;            // 默认立体声
        self.volume = 1.0;       // 默认最大声
        _currentPlayList = [NSArray array];
        self.playType = XDPlayerTypeRandom;// 默认按顺序播放全部列表
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaLibraryDidChangeNotification:) name:MPMediaLibraryDidChangeNotification object:nil]; 
        [self loadWithfishish:^(NSArray<XDMusicModel *> *muiscArray) {
            fishBlock(muiscArray);
        }];
    }
    return self;
}

- (void)loadWithfishish:(void(^)(NSArray<XDMusicModel *> *muiscArray))complete{
     self.isSortChanged = NO;
    MPMediaQuery *query = [[MPMediaQuery alloc] init];
    NSArray *items = [query items];
    NSMutableArray *musicList = [NSMutableArray new];
    for (MPMediaItem *item in items) {
        
        if (!(item.mediaType & MPMediaTypeMusic)) {
            continue;
        }
        
        if (item.assetURL == nil) {
            continue;
        }
        XDMusicModel *model = [XDMusicModel musicWithMediaItem:item];
        [XDFMDBManager insertMusicItem:model];
        [musicList addObject:model];
    }
    
    NSString *folderPath = [[NSBundle mainBundle] pathForResource:@"XDMusicBundle" ofType:@"bundle"];
    if(folderPath == nil){
        _currentPlayList = [musicList copy];
        complete(_currentPlayList);
    }
    NSArray *musicArray = [[NSBundle bundleWithPath:folderPath] pathsForResourcesOfType:@"mp3" inDirectory:nil];
    for(NSString *musicName in musicArray) {
        NSString *fileName = [musicName lastPathComponent];
        if([fileName hasSuffix:@".mp3"] || [fileName hasSuffix:@".wav"] || [fileName hasSuffix:@".m4a"]){
            NSMutableString *str = [fileName copy];
            NSArray *array = [str componentsSeparatedByString:@"."];
            fileName = array[0];
        }
        NSLog(@"%@",fileName);
        XDMusicModel *model = [XDMusicModel musicWithBundlePath:folderPath filename:fileName];
        [XDFMDBManager insertMusicItem:model];
        [musicList addObject:model];
    }
    _currentPlayList = [musicList copy];
    complete(_currentPlayList);
}

-(void)play{
    [self startPlay];
}

-(void)stopPlay{
    [self.player stop];
    [self stopTimer];
    self.player = nil;
    if(self.blockStopPlay){
        self.blockStopPlay(self,self.currentIndex);
    }
}
-(void)playAtProgress:(float)progress{
    if(progress >= 1.0){
        progress = 0.99;
    }
    if(progress <= 0){
        progress = 0;
    }
    
    NSTimeInterval time = self.player.duration * progress;
    self.player.currentTime = time;
    self.timeCount = time;
}
-(void)playWithIndex:(NSInteger)index{
    if(index > self.currentPlayList.count){
        index = self.currentPlayList.count-1;
    }
    if(index <= 0){
        index = 0;
    }
    self.currentIndex = index;
    [self stopPlay];
    [self startPlay];
}

-(void)pause{
    [self.player pause];
    [self pauseTimer];
}

-(void)startPlay{
   
    if(_player == nil){
        NSError *error = nil;
        if(self.currentPlayList.count > 0){
            XDMusicModel *model = self.currentPlayList[self.currentIndex];
            self.currentPlayItem = model;
            _currentPlayingURL = model.url;
            self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:model.url error:&error];
            if(error){
                if(self.blockPlayFail){
                    self.blockPlayFail(self,error);
                }
            }
            _player.pan = self.pan;
            _player.volume = self.volume;
            _player.delegate = self;
            _player.meteringEnabled = YES;// 开启音量检查
            if([_player prepareToPlay]){
                [_player play];
                [self startTimer];
                if(self.blockstartPlay){
                    self.blockstartPlay(self,self.currentIndex,[self stringFromNSTimeInteval:model.totalTime],model.musicName,model.artist);
                }
                _isPlaying = YES;
            }
            
        }else{
            if(self.blockPlayFail){
                if(self.blockPlayFail){
                    self.blockPlayFail(self,error);
                }
            }
        }
    }else{// 恢复播放
        [_player play];
        [self resumeTimer];
        _isPlaying = YES;
    }
}

-(void)playNext{
    self.currentIndex++;
    [self stopPlay];
    if(self.currentIndex >= self.currentPlayList.count){
        self.currentIndex = 0;
    }
    [self startPlay];
}

-(void)playLast{
    self.currentIndex--;
    [self stopPlay];
    if(_currentIndex <= 0){
        self.currentIndex = self.currentPlayList.count - 1;
    }
    [self startPlay];
}

-(void)startTimer{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopTimer];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];
    });
}

// 暂停计时
- (void)pauseTimer {
    [self.timer setFireDate:[NSDate distantFuture]];// 暂停
}

// 恢复计时
- (void)resumeTimer {
    if (self.timer == nil) {
        [self startTimer];
        self.timeCount = self.player.currentTime;
        return ;
    }
    [self.timer setFireDate:[NSDate date]];// 恢复定时器
}

// 停止计时
- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
    self.timeCount = 0;
}


-(void)refreshTime{
    self.timeCount++;
    if(self.blockProgress){
        self.blockProgress(self,self.timeCount/self.currentPlayItem.totalTime,[self stringFromNSTimeInteval:self.player.currentTime]);
    }
}


-(NSString *)stringFromNSTimeInteval:(NSTimeInterval)time
{
    NSInteger minute = time / 60;
    NSInteger second = (NSInteger)time % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld",minute,second];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"播放完成");
    switch (self.playType) {
        case XDPlayerTypeRepeatAll:
            [self playNext];
            break;
        case XDPlayerTypeRandom:
            self.currentIndex = [self getRandomNumber:0 to:self.currentPlayList.count-1];
            [self playWithIndex:self.currentIndex];
            NSLog(@"现在播放第:%ld首",self.currentIndex);
            break;
            case XDPlayerTypeSingleCycle:
            [self playWithIndex:self.currentIndex];
            break;
        default:
            break;
    }
}


/**
 指定范围内取随机数

 @param from 开始数
 @param to 结束数
 @return 随机数
 */
-(NSUInteger)getRandomNumber:(NSUInteger)from to:(NSUInteger)to{
    return (NSUInteger)(from + (arc4random() % (to - from + 1)));
}


- (void)setVolume:(float)volume {
    _volume = volume;
    self.player.volume = volume;
}


-(void)mediaLibraryDidChangeNotification:(NSNotification *)notic{
    // 1.加载音乐库
    [self loadWithfishish:^(NSArray<XDMusicModel *> *muiscArray) {
        if(muiscArray == nil || muiscArray.count == 0){
            [XDFMDBManager deletedDataBaseTableWithName:MUSIC_TABLE_NAME];
            [self clearAllData];
            return ;
        }
        
        NSInteger newCurrentIndex = [muiscArray indexOfObject:self.currentPlayItem];
        if(newCurrentIndex == NSNotFound){
            if(self.isPlaying){// 播放下一首
                [self playNext];
            }
        }
    }];
}

-(void)refreshMusicList{
    [self loadWithfishish:^(NSArray<XDMusicModel *> *muiscArray) {
        if(self.blockRefreshList){
            self.blockRefreshList(self,muiscArray);
        }
    }];
}

- (void)clearAllData {
    self.currentIndex = 0;
    self.player = nil;
    self.timeCount = 0;
    NSLog(@"clear data");
    [self stopTimer];
}
@end
