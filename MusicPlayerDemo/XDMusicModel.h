//
//  XDMusicModel.h
//  MusicPlayerDemo
//
//  Created by Heaton on 2018/1/22.
//  Copyright © 2018年 WangMingDeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MPMediaItem;

typedef NS_ENUM(NSInteger, MusicSourceType) {
    MusicSourceTypeITunes = 0,// 本地音乐库
    MusicSourceTypeBundle = 1 // app自带音乐库
};



@interface XDMusicModel : NSObject
@property (copy, nonatomic) NSString *musicName;
@property (copy, nonatomic) NSURL *url;
@property (copy, nonatomic) NSString *artist;
@property (assign, nonatomic) NSTimeInterval totalTime;
@property (assign, nonatomic) NSInteger playCount;
@property (assign, nonatomic) NSInteger sortIndex;
@property (assign, nonatomic) NSInteger persistentID;
@property (assign, nonatomic) MusicSourceType sourceType;

+ (instancetype)musicWithMediaItem:(MPMediaItem *)mediaItem;
+ (instancetype)musicWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)musicWithBundlePath:(NSString *)bundlePath filename:(NSString *)filename;
@end
