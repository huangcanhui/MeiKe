//
//  CHNetString.m
//  Calendar
//
//  Created by huangcanhui on 2017/12/8.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHNetString.h"

@implementation CHNetString
+ (NSString *)isValueInNetAddress:(NSString *)obj
{
    NSString *imageName = @"";
    if ([obj hasPrefix:@"http"]) { //是以http为开头
        return obj;
    } else if ([obj isEqualToString:@""]) {
        return imageName;
    } else {
        return [NSString stringWithFormat:@"http://static.ymstars.com/%@", obj];
    }
    return nil;
}


+ (NSString *)circleRace:(NSString *)membercount
{
    float memNum = [membercount intValue] / 2;
    float count = log2((int)memNum);
    return  [NSString stringWithFormat:@"%d", (int)pow(2, (int)count)];
}

+ (NSString *)circleTeamRaceCount:(NSString *)membercount
{
    //组数
    NSString *teams = [self circleRace:membercount];
    
    int interger = [membercount intValue] / [teams intValue];
    NSMutableArray *arrayM = [NSMutableArray array];
    
    for (int i = 0; i < [teams intValue]; i++) {
        [arrayM addObject:[NSString stringWithFormat:@"%d", interger]];
    }
    
    int remainder = [membercount integerValue] % [teams intValue];
    for (int i = 0; i < remainder; i++) {
        [arrayM replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d", interger + 1]];
    }
    
    int mathCount = 0;
    for (NSString *teamsCount in arrayM) {
        int count = [self calculateMath:teamsCount];
        mathCount = mathCount + count;
    }
    
    return [NSString stringWithFormat:@"%d", mathCount + [teams intValue] - 1];
}

+ (int)calculateMath:(NSString *)team
{
    int count = [team intValue] - 1;
    return count + count * (count - 1) / 2;
}

+ (NSString *)knockOutRace:(NSString *)membercount
{
    float memNum = [membercount intValue] / 2;
    int a = ceil(memNum); //向上取整
    float team = log2(a);
    return  [NSString stringWithFormat:@"%d", (int)pow(2, ceil(team))];
}


@end
