//
//  chatTableViewCellFrame.h
//  chatLayout
//
//  Created by 张浩波 on 14/12/25.
//  Copyright (c) 2014年 张浩波. All rights reserved.
//

#define kMargin 10 //间隔
#define kIconWH 40 //头像宽高

#define kTimeMarginW 15 //时间文本与边框间隔宽度方向
#define kTimeMarginH 4 //时间文本与边框间隔高度方向

#define kContentTop 10 //文本内容与按钮上边缘间隔
#define kContentLeft 15 //文本内容与按钮左边缘间隔
#define kContentBottom 10 //文本内容与按钮下边缘间隔
#define kContentRight 15 //文本内容与按钮右边缘间隔

#define kTimeFont [UIFont systemFontOfSize:12] //时间字体
#define kContentFont [UIFont systemFontOfSize:16] //内容字体

#define kContentW ([UIScreen mainScreen].bounds.size.width - 2 * (kMargin + kIconWH + kContentLeft + kContentRight)) //内容宽度

#define kRefreshWH 25 //重发按钮宽高
#define kRefreshRight 10 //重发按钮与文本内容的间隔

#import <Foundation/Foundation.h>

#import "ChatMessage.h"

@interface ChatTableViewCellFrame : NSObject

@property (nonatomic, assign, readonly) CGRect iconF;

@property (nonatomic, assign, readonly) CGRect timeF;

@property (nonatomic, assign, readonly) CGRect contentF;

@property (nonatomic, assign, readonly) CGRect refreshF;

@property (nonatomic, assign, readonly) CGFloat cellHeight; //cell高度

@property (nonatomic, strong) ChatMessage *chatMessage;

@property (nonatomic, assign) BOOL showTime;

@end
