//
//  ChatTableViewCell.h
//  ChatLayout
//
//  Created by 张浩波 on 14/12/25.
//  Copyright (c) 2014年 张浩波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatTableViewCellFrame.h"

@interface ChatTableViewCell : UITableViewCell

@property (nonatomic,strong) ChatTableViewCellFrame *chatCellFrame;

@property (nonatomic,assign) MessageSendStatusType statusType;

@end
