//
//  RLCParser.m
//  SyncPlayer
//
//  Created by Parker on 15/1/12.
//  Copyright (c) 2015年 Parker. All rights reserved.
//

#import "LRCParser.h"

@implementation LRCParser

-(id)init{
    
    self=[super init];
    
    if (self) {
        
        _lrcArrayList=[[NSMutableArray alloc]initWithCapacity:10];
        
        tmpArray=[[NSMutableArray alloc]initWithCapacity:10];
        
    }
    
    return self;
}

-(NSMutableArray *)parseLRC:(NSString *)lrcStr{
    
    NSArray * arr=[lrcStr componentsSeparatedByString:@"\n"];
    
    [_lrcArrayList removeAllObjects];
    
    [tmpArray removeAllObjects];
    
    for (NSString * str in arr) {
        
        [self parseLrcLine:str];
        
        [self parseTempArray:tmpArray];
        
    }
    
    [self sortAllItem:self.lrcArrayList];
    
    
    return self.lrcArrayList;
    
}


-(NSString*) parseLrcLine:(NSString *)sourceLineText
{
    if (!sourceLineText || sourceLineText.length <= 0)
        
        return nil;
    
    NSRange range = [sourceLineText rangeOfString:@"]"];
    
    if (range.length > 0)
    {
        
        NSString * time = [sourceLineText substringToIndex:range.location + 1];
        
        NSString * other = [sourceLineText substringFromIndex:range.location + 1];
        
        if (time && time.length > 0)
            
            [tmpArray addObject:time];
        
        if (other.length>1){
            
            [self parseLrcLine:other];
            
        }
        
        
        
    }else
    {
        [tmpArray addObject:sourceLineText];
    }
    
    
    return nil;
    
}



-(void) parseTempArray:(NSMutableArray *) tempArray
{
    int count;
    
    if (!tempArray || tempArray.count <= 0)
        return;
    NSString *value = [tempArray lastObject];
    if ([value hasPrefix:@"["])
    {
        
        if ([value hasPrefix:@"[ti:"]||[value hasPrefix:@"[ar:"]||[value hasPrefix:@"[al:"]||[value hasPrefix:@"[by:"]) {
            
            NSRange  range;
            
            range.location=4;
            
            range.length=value.length-1-4;
            
            value=[value substringWithRange:range];
            
        }else{
            
            value=@"";
        }
        
    }
    if (tempArray.count==1) {
        count=1;
    }else{
        
        count=tempArray.count-1;
    }
    
    for (int i = 0; i < count; i++)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        NSString * key = [tempArray objectAtIndex:(NSUInteger)i];
        NSString *secondKey = [self timeToSecond:key]; // 转换成以秒为单位的时间计数器
        
        [dic setObject:value forKey:secondKey];
        [self.lrcArrayList addObject:dic];
    }
    [tempArray removeAllObjects];
}
-(NSString *)timeToSecond:(NSString *)formatTime {
    if (!formatTime || formatTime.length <= 0){
        return @"0";
    }
    
    if ([formatTime rangeOfString:@"["].length <= 0 && [formatTime rangeOfString:@"]"].length <= 0){
        return @"0";
    }
    NSString * minutes = [formatTime substringWithRange:NSMakeRange(1, 2)];
    
    NSString *  second =@"0";
    
    if (formatTime.length==10) {
        
        NSUInteger length;
        
        NSUInteger position=4;
        
        length=formatTime.length-6;
        
        second  = [formatTime substringWithRange:NSMakeRange(position, length)];
        
    }
    
    float finishSecond = minutes.intValue * 60 + second.floatValue;
    
    return [NSString stringWithFormat:@"%f",finishSecond];
}

-(void)sortAllItem:(NSMutableArray *)array {
    
    if (!array || array.count <= 0)
        
        return;
    
    for (int i = 0; i < array.count - 1; i++)
    {
        
        for (int j = i + 1; j < array.count; j++)
        {
            
            id firstDic = [array objectAtIndex:(NSUInteger )i];
            
            id secondDic = [array objectAtIndex:(NSUInteger)j];
            
            if (firstDic && [firstDic isKindOfClass:[NSDictionary class]] && secondDic && [secondDic isKindOfClass:[NSDictionary class]])
            {
                
                NSString *firstTime = [[firstDic allKeys] objectAtIndex:0];
                
                NSString *secondTime = [[secondDic allKeys] objectAtIndex:0];
                
                BOOL b = firstTime.floatValue > secondTime.floatValue;
                
                if (b) // 第一句时间大于第二句，就要进行交换
                {
                    
                    [array replaceObjectAtIndex:(NSUInteger )i withObject:secondDic];
                    
                    [array replaceObjectAtIndex:(NSUInteger )j withObject:firstDic];
                    
                }
            }
        }
    }
}


@end



@implementation LRCData

@end
