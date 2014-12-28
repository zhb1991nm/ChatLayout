//
//  ChatTableViewCell.h
//  ChatLayout
//
//  Created by 张浩波 on 14/12/25.
//  Copyright (c) 2014年 张浩波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatTableViewCellFrame.h"

@class ChatTableViewCell;

@protocol ChatTableViewCellDelegate <NSObject>

-(void)chatTableViewCell:(ChatTableViewCell *)cell didOnClickHeadIcon:(MessageType)messageType;//头像点击事件

-(void)chatTableViewCell:(ChatTableViewCell *)cell didOnClickResendButton:(ChatMessage *)chatMessage;//重发事件

-(void)chatTableViewCell:(ChatTableViewCell *)cell didLongPressedOnContentButton:(ChatMessage *)chatMessage;//长按事件

@end

@interface ChatTableViewCell : UITableViewCell

@property (nonatomic,strong) ChatTableViewCellFrame *chatCellFrame;

@property (nonatomic,assign) id<ChatTableViewCellDelegate> delegate;

@end
