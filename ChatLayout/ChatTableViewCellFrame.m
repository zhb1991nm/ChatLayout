//
//  chatTableViewCellFrame.m
//  chatLayout
//
//  Created by 张浩波 on 14/12/25.
//  Copyright (c) 2014年 张浩波. All rights reserved.
//

#import "ChatTableViewCellFrame.h"
#import "ChatMessage.h"

@implementation ChatTableViewCellFrame

-(void)setChatMessage:(ChatMessage *)chatMessage{
    _chatMessage = chatMessage;
    
    // 0、获取屏幕宽度
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    // 1、计算时间的位置
    if (_showTime){
        
        CGFloat timeY = kMargin;
        CGSize timeSize = [chatMessage.time sizeWithFont:kTimeFont];
        CGFloat timeX = (screenW - timeSize.width) / 2;
        _timeF = CGRectMake(timeX, timeY, timeSize.width + kTimeMarginW, timeSize.height + kTimeMarginH);
    }
    // 2、计算头像位置
    CGFloat iconX = kMargin;
    // 2.1 如果是自己发得，头像在右边
    if (chatMessage.type == MessageTypeMe) {
        iconX = screenW - kMargin - kIconWH;
    }
    
    CGFloat iconY = CGRectGetMaxY(_timeF) + kMargin;
    _iconF = CGRectMake(iconX, iconY, kIconWH, kIconWH);
    
    // 3、计算内容位置
    CGFloat contentX = CGRectGetMaxX(_iconF) + kMargin;
    CGFloat contentY = iconY;
    CGSize contentSize = [chatMessage.content sizeWithFont:kContentFont constrainedToSize:CGSizeMake(kContentW, CGFLOAT_MAX)];
    
    if (chatMessage.type == MessageTypeMe) {
        contentX = iconX - kMargin - contentSize.width - kContentLeft - kContentRight;
        _resendF = CGRectMake(contentX - kResendWH - kResendRight, contentY + (contentSize.height + kContentTop + kContentBottom - kResendWH) / 2, kResendWH, kResendWH);
    }else{
        _resendF = CGRectZero;
    }
        
    
    _contentF = CGRectMake(contentX, contentY, contentSize.width + kContentLeft + kContentRight, contentSize.height + kContentTop + kContentBottom);
    
    // 4、计算高度
    _cellHeight = MAX(CGRectGetMaxY(_contentF), CGRectGetMaxY(_iconF))  + kMargin;
}

@end
