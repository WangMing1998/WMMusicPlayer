//
//  readMe.h
//  MusicPlayerDemo
//
//  Created by Heaton on 2018/1/23.
//  Copyright © 2018年 WangMingDeveloper. All rights reserved.
//

#ifndef readMe_h
#define readMe_h
/*
 
 未试验
 self.audioPlayer.meteringEnabled = YES;
 取波形幅度值
 
 [self.audioPlayer updateMeters];//更新
 float peakPower = [self.audioPlayer averagePowerForChannel:0];//分贝
 double peakPowerForChannel = pow(10, (0.05 * peakPower));//波形幅度
 [pointArr addObject:[NSNumber numberWithDouble:peakPowerForChannel]];
 
 用定时器      每秒钟取5000个点
 
 取满100个 就用这100个点去画图  这样每秒钟就更新50次;
 
 这样数据有了 你用张背景图 放后面 数据在前面画动态的点就可以了
 
 */

#endif /* readMe_h */
