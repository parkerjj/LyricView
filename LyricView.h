//
//  LyricView.h
//  SyncPlayer
//
//  Created by Parker on 15/1/13.
//  Copyright (c) 2015年 Parker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LyricView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *lyricDataArray;
@property (nonatomic) NSTimeInterval time;

@end



@interface LyricViewCell : UITableViewCell{
    UILabel *_textLabel;
}
@property (nonatomic,strong) NSString *text;
@end