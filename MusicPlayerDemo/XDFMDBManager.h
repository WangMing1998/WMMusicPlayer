//
#pragma marks XDFMDBManager.h

//
#pragma marks Created by Mirco on 2016/10/31.
#pragma marks Copyright © 2016年 wangming. All rights reserved.



#define DateBasePath    [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"MusicInfo.sqlite"]

#import <Foundation/Foundation.h>
#import "XDPlayerDefine.h"
@class XDMusicModel;
#pragma marks创建视频列表数据表
static NSString *const createMusicStroeTable     = @"CREATE TABLE IF NOT EXISTS t_musicItemsInfo (%@ INTEGER  PRIMARY KEY, %@ TEXT NOT NULL, %@ TEXT NOT NULL, %@ TEXT NOT NULL,%@ INTEGER NOT NULL,%@ INTEGER NOT NULL,%@ INTEGER NOT NULL)";

#pragma marks插入音乐记录
static NSString * const InsertMusicItem     = @"INSERT into t_musicItemsInfo (musicID,musicName,musicArist,musicURL,musicPlayCount,musicTotalTime,musicSourceType) VALUES(%ld,%@,%@,%@,%ld,%ld,%ld)";

#pragma marks根据ID主键来更新播放次数
static NSString * const UpdateMusicItem     = @"UPDATE t_musicItemsInfo SET musicPlayCount = %ld WHERE musicID = %ld";


#pragma marks糊糊查询音乐条目
static NSString * const QueryMusicItem      = @"SELECT * FROM t_musicItemsInfo WHERE musicName like '%%%@%%'";

#pragma marks根据创建ID删除音乐条目
static NSString * const DeleteMusicItem     = @"DELETE FROM t_musicItemsInfo WHERE musicID = %@";


static NSString * const SelectMusicTable_Name    = @"SELECT * FROM t_musicItemsInfo ORDER BY musicName DESC";// 根据名称降序排序
static NSString * const SelectMusicTable_Count    = @"SELECT * FROM t_musicItemsInfo ORDER BY musicPlayCount DESC";// 根据播放次数降序排序

#pragma marks删除数据表
static NSString * const DeletedTable        = @"TRUNCATE TABLE %@";
#pragma marks清空数据表内容
static NSString *const clearTableDate       = @"DELETE FROM %@";


@interface XDFMDBManager : NSObject


#pragma marks 增加多条记录
+ (void)insertMusicItemArray:(NSArray<XDMusicModel *> *)modelArray;
#pragma marks 增加单条记录
+ (void)insertMusicItem:(XDMusicModel *)model;
#pragma marks 根据ID修改播放次数
+ (void)updateMusicItem:(XDMusicModel *)model;
#pragma marks 根据创建时间来删除视频
+ (void)deletedMusicItem:(NSString *)identifier;
#pragma marks 模糊查询数据
+ (NSArray *)selectMusicItemWithStr:(NSString *)str;


#pragma marks 查询所有数据
+ (NSArray<XDMusicModel *> *)selectedDataBaseTableWithName:(NSString *)tableName;
#pragma marks 测试方法，打印所有数据
+ (void)printDataBaseTableWithName:(NSString *)tableName;
#pragma marks 清空数据表
+ (void)clearTableDate:(NSString *)tableName;
#pragma marks 创建数据表
+ (void)createDataBaseTable:(NSString *)tableName;
#pragma marks 删除精据表
+ (void)deletedDataBaseTableWithName:(NSString *)tableName;
@end
