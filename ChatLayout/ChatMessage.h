//
//  ChatMessage.h
//  ChatLayout
//
//  Created by 张浩波 on 14/12/25.
//  Copyright (c) 2014年 张浩波. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    MessageTypeMe = 0, // 自己发的
    MessageTypeOther = 1 //别人发得
    
} MessageType;

typedef enum {
    MessageSendStatusType_failed = -1, //发送失败
    MessageSendStatusType_waiting = 0, //发送中
    MessageSendStatusType_success = 1 //发送成功
    
} MessageSendStatusType;

@interface ChatMessage : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) MessageType type;
@property (nonatomic, assign) MessageSendStatusType statusType;
@property (nonatomic, copy) NSDictionary *dict;

@end
