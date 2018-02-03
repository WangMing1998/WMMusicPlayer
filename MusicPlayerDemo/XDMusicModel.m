//
//  XDMusicModel.m
//  MusicPlayerDemo
//
//  Created by Heaton on 2018/1/22.
//  Copyright © 2018年 WangMingDeveloper. All rights reserved.
//

#import "XDMusicModel.h"
#import <CoreMedia/CoreMedia.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "XDPlayerDefine.h"
@implementation XDMusicModel

+ (instancetype)musicWithMediaItem:(MPMediaItem *)mediaItem{
    XDMusicModel *model = [XDMusicModel new];
    
    
    if([mediaItem.title isEqual:[NSNull null]] || mediaItem.title == nil){
        model.musicName = @"未知歌名";
    }else{
        model.musicName = mediaItem.title;
    }
    
    if([mediaItem.artist isEqual:[NSNull null]] || mediaItem.artist == nil){
        model.artist = @"未知歌名";
    }else{
        model.artist = mediaItem.artist;
    }
    model.persistentID = mediaItem.persistentID;// Music唯一ID
    model.url = mediaItem.assetURL;
    model.totalTime = mediaItem.playbackDuration;
    model.playCount = 0;
    model.sourceType = MusicSourceTypeITunes;
    NSLog(@"musicName:%@\nmusicArtist:%@\n",model.musicName,model.artist);
    return model;
}

+ (instancetype)musicWithBundlePath:(NSString *)bundlePath filename:(NSString *)filename {
    XDMusicModel *model = [XDMusicModel new];
    NSURL *url = [NSURL URLWithString:[[bundlePath stringByAppendingPathComponent:filename]stringByAppendingString:@".mp3"]];
    model.url = url;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    if([filename isEqual:[NSNull null]] || filename == nil){
        model.musicName = @"未获取到歌名";
    }else{
        model.musicName = filename;
    }
    model.artist =@"未知歌名";
    model.persistentID = [self getRandomNumber:0 to:9000];
    model.totalTime = player.duration;
    model.sourceType = MusicSourceTypeBundle;
    model.playCount = 0;
    //    model.addDate = [[NSDate date] timeIntervalSince1970];
    return model;
}

+(instancetype)musicWithDictionary:(NSDictionary *)dictionary{
    XDMusicModel *model = [XDMusicModel new];
    
    model.persistentID = [dictionary[MUSIC_ID] integerValue];
    model.musicName = dictionary[MUSIC_NAME];
    model.artist = dictionary[MUSIC_ARTIST];
    
    // 要判断是沙盒还是bundle的
    if([dictionary[MUSIC_SOURCETYPE] integerValue] == MusicSourceTypeITunes){
        model.url = [NSURL URLWithString:dictionary[MUSIC_ASERTURL]];
        model.sourceType = MusicSourceTypeITunes;
    }else{
        NSString *folderPath = [[NSBundle mainBundle] pathForResource:@"XDMusicBundle" ofType:@"bundle"];
        model.url = [NSURL fileURLWithPath:[folderPath stringByAppendingPathComponent:[dictionary[MUSIC_NAME] stringByAppendingString:@".mp3"]]];
        model.sourceType = MusicSourceTypeBundle;
        NSLog(@"%@",[dictionary[MUSIC_NAME] stringByAppendingString:@".mp3"]);
    }
    
    model.playCount = [dictionary[MUSIC_PLAYCOUNT] integerValue];
    model.totalTime = [dictionary[MUSIC_TOTALTIME] integerValue];
    model.sourceType = [dictionary[MUSIC_SOURCETYPE] integerValue];
    return model;
}

+(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)))+20000;
}
@end

