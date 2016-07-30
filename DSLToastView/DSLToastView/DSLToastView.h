//
//  DSLToastView.h
//  DSLToastViewDemo
//
//  Created by 邓顺来 on 16/1/22.
//  Copyright © 2016年 邓顺来. All rights reserved.
//

/*********************************************************************************
 *
 * 用法：[DSLToastView toastWithText:@"文本"];
 * 该控件是一个单例
 * 感谢您的使用！
 * 与我联系：mu3305495@163.com
 *
 *********************************************************************************/

#import <UIKit/UIKit.h>

@class DSLToastView;

typedef void(^DSLToastViewConfigureBlock)(DSLToastView *sharedToast);

typedef NS_ENUM(NSUInteger, DSLToastViewStyle) {
    
    DSLToastViewStyleBlack,
    DSLToastViewStyleWhite,
};

@interface DSLToastView : UIView

/**
 *  设置文本属性
 */
@property (nonatomic, strong) NSDictionary *textAttributes;

/**
 *  y坐标的偏移量，默认为0
 */
@property (nonatomic, assign) CGFloat yOffset;

/**
 *  字体大小，默认17
 */
@property (nonatomic, assign) CGFloat fontSize;

/**
 *  宽的补偿，默认为0，小于0变窄，大于0变宽
 */
@property (nonatomic, assign) CGFloat widthCompensate;

/**
 *  高的补偿，默认为0，小于0变窄，大于0变宽
 */
@property (nonatomic, assign) CGFloat heightCompensate;

/**
 *  文本颜色
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 *  渐显动画的时间长度，默认0.2
 */
@property (nonatomic, assign) CGFloat fadeStartAnimationDuration;

/**
 *  渐灭动画的时间长度，默认0.3
 */
@property (nonatomic, assign) CGFloat fadeDismissAnimationDuration;

/**
 *  toast停留显示的时间长度，默认1，上述三个时间之和为toast的整个显示时长
 */
@property (nonatomic, assign) CGFloat stayTime;

/**
 *  toast显示方法
 *
 *  @param text 显示的文本
 */
+ (void)toastWithText:(NSString *)text;

/**
 *  toast显示方法
 *
 *  @param attributedText 显示的属性文本
 */
+ (void)toastWithAttributedText:(NSAttributedString *)attributedText;

/**
 *  toast显示在底部
 *
 *  @param text 文本
 */
+ (void)bottomToastWithText:(NSString *)text;

/**
 *  toast显示在底部
 *
 *  @param attributedText 属性文本
 */
+ (void)bottomToastWithAttributedText:(NSAttributedString *)attributedText;

/**
 *  延迟second秒后再显示toast
 *
 *  @param text   文本
 *  @param second 延迟的秒数
 */
+ (void)toastWithText:(NSString *)text after:(CGFloat)second;

/**
 *  延迟second秒后再在底部显示toast
 *
 *  @param text   文本
 *  @param second 延迟的秒数
 */
+ (void)bottomToastWithText:(NSString *)text after:(CGFloat)second;

/**
 *  toast配置属性用此block，该控件是一个单例，block中会传入该单例以供配置
 *  例：
 *  [DSLToastView configureToastWithBlock:^(DSLToastView *sharedToast) {
 *      sharedToast.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.6];
 *      sharedToast.textColor = [UIColor whiteColor];
 *      sharedToast.layer.cornerRadius = 25;
 *      sharedToast.yOffset = 0;
 *  }];
 *
 *  @param block 配置block
 */
+ (void)configureToastWithBlock:(DSLToastViewConfigureBlock)block;

/**
 *  重置toast的所有属性
 */
+ (void)reset;

@end
