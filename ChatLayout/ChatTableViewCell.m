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
    UIButton *_resendBtn;
    UIActivityIndicatorView *_loadingIndicator;
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
        
        [_iconView addTarget:self action:@selector(iconButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_iconView];
        
        // 3、创建内容
        _contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        _contentBtn.titleLabel.font = kContentFont;
        _contentBtn.titleLabel.numberOfLines = 0;
        
        [self.contentView addSubview:_contentBtn];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(contentBtnLong:)];
        longPress.minimumPressDuration = 0.8; //定义按的时间
        [_contentBtn addGestureRecognizer:longPress];
        
        // 4、创建重发按钮
        _resendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resendBtn setImage:[UIImage imageNamed:@"chat_refresh.png"] forState:UIControlStateNormal];
        _resendBtn.hidden = YES;
        [_resendBtn addTarget:self action:@selector(resendBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_resendBtn];
        // 5、等待动画
        _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadingIndicator.hidesWhenStopped = YES;
        [self.contentView addSubview:_loadingIndicator];
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
        normal = [UIImage scaledImage:@"chat_to.png" size:CGSizeMake(142.0f / 3.0f, 40.0f)];//47.333 * 40
        
        CGFloat top = 30; // 顶端盖高度
        CGFloat bottom = 8 ; // 底端盖高度
        CGFloat left = 10; // 左端盖宽度
        CGFloat right = 10; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        // 指定为拉伸模式，伸缩后重新赋值
        normal = [normal resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        _resendBtn.frame = chatCellFrame.resendF;
        _loadingIndicator.center = _resendBtn.center;
        
        switch (self.chatCellFrame.chatMessage.statusType) {
            case MessageSendStatusType_failed:
                [_loadingIndicator stopAnimating];
                _resendBtn.hidden = NO;
                break;
                
            case MessageSendStatusType_success:
                [_loadingIndicator stopAnimating];
                _resendBtn.hidden = YES;
                break;
                
            case MessageSendStatusType_waiting:
                [_loadingIndicator startAnimating];
                _resendBtn.hidden = YES;
                break;
            default:
                break;
        }
        
    }else{
        normal = [UIImage scaledImage:@"chat_from.png" size:CGSizeMake(142.0f / 3.0f, 40.0f)];//47.333 * 40
        
        CGFloat top = 30; // 顶端盖高度
        CGFloat bottom = 8 ; // 底端盖高度
        CGFloat left = 10; // 左端盖宽度
        CGFloat right = 10; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        // 指定为拉伸模式，伸缩后重新赋值
        normal = [normal resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        
        [_loadingIndicator stopAnimating];
        _resendBtn.hidden = YES;
    }
    [_contentBtn setBackgroundImage:normal forState:UIControlStateNormal];
    
    
}

-(void)iconButtonOnClick:(UIButton *)sender{
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(chatTableViewCell:didOnClickHeadIcon:)]) {
            [self.delegate chatTableViewCell:self didOnClickHeadIcon:self.chatCellFrame.chatMessage.type];
        }
    }
}

-(void)contentBtnLong:(UIButton *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(chatTableViewCell:didLongPressedOnContentButton:)]) {
                [self.delegate chatTableViewCell:self didLongPressedOnContentButton:self.chatCellFrame.chatMessage];
            }
        }
    }
}

-(void)resendBtnOnClick:(UIButton *)sender{
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(chatTableViewCell:didOnClickResendButton:)]) {
            [self.delegate chatTableViewCell:self didOnClickResendButton:self.chatCellFrame.chatMessage];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
