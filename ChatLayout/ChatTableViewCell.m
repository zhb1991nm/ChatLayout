//
//  chatTableViewCell.m
//  chatLayout
//
//  Created by 张浩波 on 14/12/25.
//  Copyright (c) 2014年 张浩波. All rights reserved.
//

#import "ChatTableViewCell.h"
#import "ChatMessage.h"
#import "ChatTableViewCellFrame.h"

@interface ChatTableViewCell(){
    UIButton    *_timeBtn;
    UIButton *_iconView;
    UIButton    *_contentBtn;
    UIButton *_refreshBtn;
}

@end

@implementation ChatTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // 1、创建时间按钮
        _timeBtn = [[UIButton alloc] init];
        [_timeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _timeBtn.titleLabel.font = kTimeFont;
        _timeBtn.enabled = NO;
        [_timeBtn setBackgroundColor:[UIColor lightGrayColor]];
        _timeBtn.layer.cornerRadius = 3.0f;
        [self.contentView addSubview:_timeBtn];
        
        // 2、创建头像
        _iconView = [[UIButton alloc] init];
        [self.contentView addSubview:_iconView];
        
        // 3、创建内容
        _contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        _contentBtn.titleLabel.font = kContentFont;
        _contentBtn.titleLabel.numberOfLines = 0;
        
        [self.contentView addSubview:_contentBtn];
        // 4、创建重发按钮
        _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshBtn setImage:[UIImage imageNamed:@"chat_refresh.png"] forState:UIControlStateNormal];
        _refreshBtn.hidden = YES;
        [self.contentView addSubview:_refreshBtn];
    }
    return self;
}

-(void)setChatCellFrame:(ChatTableViewCellFrame *)chatCellFrame{
    _chatCellFrame = chatCellFrame;
    ChatMessage *message = chatCellFrame.chatMessage;
    
    // 1、设置时间
    [_timeBtn setTitle:message.time forState:UIControlStateNormal];
    
    _timeBtn.frame = chatCellFrame.timeF;
    
    // 2、设置头像
    [_iconView setImage:[UIImage imageNamed:message.icon] forState:UIControlStateNormal];
    _iconView.frame = chatCellFrame.iconF;
    
    // 3、设置内容
    [_contentBtn setTitle:message.content forState:UIControlStateNormal];
    _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentLeft, kContentBottom, kContentRight);
    _contentBtn.frame = chatCellFrame.contentF;
    
    if (message.type == MessageTypeMe) {
        _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentRight, kContentBottom, kContentLeft);
    }
    
    UIImage *normal;
    if (message.type == MessageTypeMe) {
        normal = [UIImage scaledImage:@"chat_to1.png" size:CGSizeMake(142.0f / 3.0f, 40.0f)];//47.333 * 40
        
        CGFloat top = 30; // 顶端盖高度
        CGFloat bottom = 8 ; // 底端盖高度
        CGFloat left = 10; // 左端盖宽度
        CGFloat right = 10; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        // 指定为拉伸模式，伸缩后重新赋值
        normal = [normal resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        
        _refreshBtn.hidden = NO;
        _refreshBtn.frame = chatCellFrame.refreshF;
    }else{
        normal = [UIImage scaledImage:@"chat_from.png" size:CGSizeMake(142.0f / 3.0f, 40.0f)];//47.333 * 40
        
        CGFloat top = 30; // 顶端盖高度
        CGFloat bottom = 8 ; // 底端盖高度
        CGFloat left = 10; // 左端盖宽度
        CGFloat right = 10; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        // 指定为拉伸模式，伸缩后重新赋值
        normal = [normal resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        _refreshBtn.hidden = YES;
    }
    [_contentBtn setBackgroundImage:normal forState:UIControlStateNormal];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
