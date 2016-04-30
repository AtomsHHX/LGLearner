//
//  Utilities.h
//  Utility
//
//  Created by ZIYAO YANG on 15/8/20.
//  Copyright (c) 2015年 Ziyao Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utilities : NSObject

//根据key获取缓存userDefault
+ (id)getUserDefaults:(NSString *)key;
//根据key设置userDefault
+ (void)setUserDefaults:(NSString *)key content:(id)value;
//根据key删除缓存userDefault
+ (void)removeUserDefaults:(NSString *)key;
//获得venderID的UUID字符串
+ (NSString *)uniqueVendor;
//根据id获取控制器实例
+ (id)getStoryboardInstanceByIdentity:(NSString *)storyboard byIdentity:(NSString*)identity;
//弹出普通提示框
+ (void)popUpAlertViewWithMsg:(NSString *)msg andTitle:(NSString* )title onView:(UIViewController *)vc;
//获得保护膜
+ (UIActivityIndicatorView *)getCoverOnView:(UIView *)view;
//将浮点数转化为保留小数点后若干位数的字符串
+ (NSString *)notRounding:(float)price afterPoint:(int)position;
//根据URL下载图片并缓存
+ (UIImage *)imageUrl:(NSString *)url;
//根据文字内容自适应高度
+ (double)getTextHeight:(NSString *)text textFont:(UIFont *)textFont toViewRange:(int)range;
@end
