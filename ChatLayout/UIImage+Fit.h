//
//  UIImage+Fit.h
//  SinaWeibo
//
//  Created by mj on 13-8-19.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Fit)
#pragma mark 返回拉伸好的图片
+ (UIImage *)resizeImage:(NSString *)imgName;
- (UIImage *)resizeImage;

+(UIImage *)scaledImage:(NSString *)imgName size:(CGSize)size;
- (UIImage *)scaleToSize:(CGSize)size;

+ (UIImage *)createImageWithColor:(UIColor *)color;
@end
