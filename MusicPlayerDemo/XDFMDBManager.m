//
//  XDFMDBManager.m
//  XDNusicPlayerDemo
//
//  Created by Mirco on 2016/10/31.
//  Copyright © 2016年 wangming. All rights reserved.
//

#import "XDFMDBManager.h"
#import "FMDatabase.h"
#import "XDMusicModel.h"
#import <objc/runtime.h>
@implementation XDFMDBManager

+ (void)createDataBaseTable:(NSString *)tableName
{
    BOOL result = NO;
    FMDatabase *db = [FMDatabase databaseWithPath:DateBasePath];// 有则打开，无则创建
    NSLog(@"VideoTable数据库所在的位置:%@\n",DateBasePath);
    if([db open])// 创表
    {
        NSString *sql = nil;
        if([tableName isEqualToString:MUSIC_TABLE_NAME]){// MUSIC_ID 为主键
           sql = [NSString stringWithFormat:createMusicStroeTable,MUSIC_ID,MUSIC_NAME,MUSIC_ARTIST,MUSIC_ASERTURL,MUSIC_URL,MUSIC_PLAYCOUNT,MUSIC_TOTALTIME,MUSIC_SOURCETYPE];
        }
        result =  [db executeUpdate:sql];
        
    }else{
        NSLog(@"error when open dataBase");
    }
    NSLog(@"%@%@\n",tableName,result?@"数据表创建成功":@"数据表创建失败");
}



#pragma mark 增加多条记录
+ (void)insertMusicItemArray:(NSArray<XDMusicModel *> *)modelArray
{
    FMDatabase *database = [FMDatabase databaseWithPath:DateBasePath];
    [database open];
    [database beginTransaction];
    for(XDMusicModel *model in modelArray)
    {
        
        [database executeUpdateWithFormat:InsertMusicItem,
                                          model.persistentID,
                                          model.musicName,
                                          model.artist,
                                          [NSString stringWithFormat:@"%@",model.url],
                                          model.playCount,
                                          (NSInteger)model.totalTime,
                                          model.sourceType
                                          ];// 要按建表顺序一致
    
    }
    [database commit];
    [database close];
}

#pragma mark 增加单条记录
+ (void)insertMusicItem:(XDMusicModel *)model
{
    FMDatabase *database = [FMDatabase databaseWithPath:DateBasePath];
    [database open];
    [database beginTransaction];
    [database executeUpdateWithFormat:InsertMusicItem,
                                     model.persistentID,
                                     model.musicName,
                                     model.artist,
                                     [NSString stringWithFormat:@"%@",model.url],
                                     model.playCount,
                                     (NSInteger)model.totalTime,
                                     model.sourceType
                                     ];// 要按建表顺序一致
    NSLog(@"%@",[NSString stringWithFormat:@"%@",model.url.absoluteString]);
    [database commit];
    [database close];
}


+ (void)updateMusicItem:(XDMusicModel *)model
{
    FMDatabase *database = [FMDatabase databaseWithPath:DateBasePath];
    [database open];
    [database beginTransaction];
    [database executeUpdateWithFormat:UpdateMusicItem,model.playCount,model.persistentID];
    [database commit];
    [database close];
}

#pragma mark 根据创建时间来删除视频
+ (void)deletedVideoItem:(NSString *)identifier
{
    FMDatabase *database = [FMDatabase databaseWithPath:DateBasePath];
    [database open];
    [database executeUpdateWithFormat:DeleteMusicItem,identifier];
    [database close];
}

#pragma mark 模糊查询数据
+ (NSArray *)selectMusicItemWithStr:(NSString *)str
{
    NSMutableArray *musicItems = [NSMutableArray array];
    FMDatabase *database = [FMDatabase databaseWithPath:DateBasePath];
    [database open];
    NSString *selcectSql = [NSString stringWithFormat:QueryMusicItem,str];
    FMResultSet *result = [database executeQuery:selcectSql];
    while (result.next) {
        NSDictionary *dict = result.resultDictionary;
        XDMusicModel *model = [XDMusicModel musicWithDictionary:dict];
        [musicItems addObject:model];
    }
    [result close];
    [database close];
    return [musicItems copy];
}


//-------------------------------公有方法-------------------------------//
#pragma mark 查询所有数据
+ (NSArray<XDMusicModel *> *)selectedDataBaseTableWithName:(NSString *)tableName
{
    NSMutableArray *musicItems = [NSMutableArray array];
    FMDatabase *database = [FMDatabase databaseWithPath:DateBasePath];
    [database open];
    FMResultSet *result = [database executeQuery:SelectMusicTable_Name];
    while (result.next) {
        NSDictionary *dict = result.resultDictionary;
        XDMusicModel *model = [XDMusicModel musicWithDictionary:dict];;
        NSLog(@"%@",model);
        [musicItems addObject:model];
    }
    [result close];
    [database close];
    return [musicItems copy];
}

#pragma mark 测试方法，打印所有数据
+ (void)printDataBaseTableWithName:(NSString *)tableName
{
    FMDatabase *dataBase = [FMDatabase databaseWithPath:DateBasePath];
    [dataBase open];
    FMResultSet *result = [dataBase executeQuery:SelectMusicTable_Name];
    while(result.next)
    {
        
        NSDictionary *dict = result.resultDictionary;
        NSLog(@"%@",dict);
    }
    [result close];
    [dataBase close];
}

#pragma mark 删除所有记录数据
+ (void)deletedDataBaseTableWithName:(NSString *)tableName
{
    FMDatabase *database = [FMDatabase databaseWithPath:DateBasePath];
    [database open];
    BOOL ret = [database executeUpdateWithFormat:DeletedTable,tableName];
    NSLog(@"%@%@",tableName,ret?@"表删除成功":@"表删除失败");
    [database close];
}


+ (void)clearTableDate:(NSString *)tableName
{
    FMDatabase *database = [FMDatabase databaseWithPath:DateBasePath];
    [database open];
    //DELETE FROM t_liveInfo
    NSString *sql = [NSString stringWithFormat:clearTableDate,tableName];
    BOOL ret = [database executeUpdate:sql];
    NSLog(@"%@%@",tableName,ret?@"数据表清空成功":@"数据表清空失败");
    [database close];
}

@end
