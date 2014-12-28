//
//  ViewController.h
//  ChatLayout
//
//  Created by 张浩波 on 14/12/25.
//  Copyright (c) 2014年 张浩波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@end

typedef void (^TapBlock)(void);

@interface TapView : UIView

-(id)initWithFrame:(CGRect)frame tapBlock:(TapBlock)tapBlock;

@end