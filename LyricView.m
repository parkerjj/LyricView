//
//  LyricView.m
//  SyncPlayer
//
//  Created by Parker on 15/1/13.
//  Copyright (c) 2015年 Parker. All rights reserved.
//

#import "LyricView.h"

@implementation LyricView
static NSInteger indexOfTime = 0;


- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setDelegate:self];
        [self setDataSource:self];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDelegate:self];
        [self setDataSource:self];
        [self setBackgroundColor:[UIColor clearColor]];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor, (id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor,nil];
    gradientLayer.locations = [NSArray arrayWithObjects:@0.12,@0.5,@0.78,nil];
    self.layer.mask = gradientLayer;

}


- (void)setLyricDataArray:(NSArray *)lyricDataArray{
    indexOfTime = 0;
    _time = 0;
    _lyricDataArray = lyricDataArray;
    [self reloadData];
}


- (void)setTime:(NSTimeInterval)time{
    _time = time;
    if ([self isDecelerating] || [self isTracking] || [self isDragging]) {
        return;
    }
    
    for (NSInteger i = indexOfTime; i<[_lyricDataArray count]; i++) {
        NSDictionary *dic=[_lyricDataArray objectAtIndex:i];
        if (dic){
            NSString *key = [dic.allKeys objectAtIndex:0];
            if ([key floatValue] > time) {
                //找到了该显示的这行
                indexOfTime = i-1;
                [self selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexOfTime inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                return;
            }
            
        }
    }
    indexOfTime = 0;
}

#pragma mark - DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_lyricDataArray == nil)
        return 0;
    
    NSUInteger count = [_lyricDataArray count];
    NSLog(@"Count = %d",count);
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LyricViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[LyricViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    NSDictionary *dic=[_lyricDataArray objectAtIndex:indexPath.row];

    if (dic){
        NSString *key = [dic.allKeys objectAtIndex:0];
        NSString *value = [dic objectForKey:key];
        [cell setText:value];
    }

    
    return cell;
}



@end


@implementation LyricViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor clearColor];
        [self setSelectedBackgroundView:bgColorView];
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, screenSize.width, self.frame.size.height)];
        [_textLabel setTextAlignment:NSTextAlignmentCenter];
        [_textLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)setText:(NSString *)text{
    _text = text;
    [_textLabel setText:text];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [_textLabel setTextColor:[UIColor greenColor]];
        [_textLabel setFont:[UIFont systemFontOfSize:14]];

    }else{
        [_textLabel setTextColor:[UIColor whiteColor]];
        [_textLabel setFont:[UIFont systemFontOfSize:12]];
    }
}


@end
