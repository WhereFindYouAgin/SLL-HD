//
//  DealTool.m
//  SLL美团HD
//
//  Created by sll on 2017/10/27.
//  Copyright © 2017年 sll. All rights reserved.
//

#import "DealTool.h"

#import "Deal.h"

#import "FMDB.h"

@implementation DealTool

static FMDatabase *_db;

+(void)initialize{
    // 1.打开数据库
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"deal.sqlite"];
    _db = [FMDatabase databaseWithPath:file];
    if (![_db open]) return;
    //创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_collect_deal(id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);"];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_recent_deal(id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);"];
}

+(NSArray*)collectDeals:(int)page{
    int size = 20;
    int pos = (page - 1) * size;
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_collect_deal ORDER BY id DESC LIMIT %d,%d;", pos, size];
    NSMutableArray *deals = [NSMutableArray array];
    while (set.next) {
        Deal *deal = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"deal"]];
        [deals addObject:deal];
    }
    return deals;
    
}

+ (void)addCollectDeal:(Deal *)deal{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deal];
    [_db executeUpdateWithFormat:@"INSERT INTO t_collect_deal(deal, deal_id) VALUES(%@, %@);", data, deal.deal_id];
}

+(void)removeCollectDeal:(Deal *)deal{
    [_db executeUpdateWithFormat:@"DELETE FROM t_collect_deal WHERE deal_id = %@;", deal.deal_id];
}

+ (BOOL)isCollected:(Deal *)deal{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal WHERE deal_id = %@;", deal.deal_id];
    [set next];
    return  [set intForColumn:@"deal_count"] == 1;
}
+ (int)collectDealsCount{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal;"];
    [set next];
    return [set intForColumn:@"deal_count"];
    
}

@end
