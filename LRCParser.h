//
//  RLCParser.h
//  SyncPlayer
//
//  Created by Parker on 15/1/12.
//  Copyright (c) 2015年 Parker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRCParser : NSObject{
    
    NSMutableArray * tmpArray;
    
    
}

@property(nonatomic,retain)NSMutableArray * lrcArrayList;

-(id)init;

-(NSMutableArray *)parseLRC:(NSString *)lrcStr;

@end


@interface LRCData : NSObject
@property (nonatomic,strong) NSString *string;
@property (nonatomic) NSTimeInterval time;

@end