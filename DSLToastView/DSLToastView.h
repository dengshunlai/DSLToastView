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

typedef NS_ENUM(NSInteger, DSLToastViewPosition) {
    DSLToastViewPositionCenter,
    DSLToastViewPositionBottom,
    DSLToastViewPositionTop
};

@class DSLToastView;

typedef void(^DSLToastViewConfigureBlock)(DSLToastView *sharedToast);

@interface DSLToastView : UIView

/**
 *  设置文本属性
 */
@property (nonatomic, strong) NSDictionary *textAttributes;

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
 *  距离底部的间距，DSLToastViewPositionBottom 时有效
 */
@property (nonatomic, assign) CGFloat bottomSpace;

/**
 *  距离顶部的间距，DSLToastViewPositionTop 时有效
 */
@property (nonatomic, assign) CGFloat topSpace;

/**
 显示

 @param text 文本
 */
+ (void)toastWithText:(NSString *)text;

/**
 显示

 @param attributedText 富文本
 */
+ (void)toastWithAttributedText:(NSAttributedString *)attributedText;

/**
 显示

 @param text  文本
 @param delay 延迟秒数
 */
+ (void)toastWithText:(NSString *)text
                delay:(CGFloat)delay;

/**
 显示

 @param text     文本
 @param stayTime 停留秒数
 */
+ (void)toastWithText:(NSString *)text
             stayTime:(CGFloat)stayTime;

/**
 显示

 @param text     文本
 @param position 位置
 */
+ (void)toastWithText:(NSString *)text
             position:(DSLToastViewPosition)position;

/**
 显示

 @param text     文本
 @param stayTime 停留秒数
 @param position 位置
 */
+ (void)toastWithText:(NSString *)text
             stayTime:(CGFloat)stayTime
             position:(DSLToastViewPosition)position;

/**
 显示

 @param text     文本
 @param position 位置
 @param yOffset  y偏移
 */
+ (void)toastWithText:(NSString *)text
             position:(DSLToastViewPosition)position
              yOffset:(CGFloat)yOffset;

/**
 显示

 @param text     文本
 @param delay    延迟秒数
 @param stayTime 停留秒数
 @param position 位置
 @param yOffset  y偏移
 */
+ (void)toastWithText:(NSString *)text
                delay:(CGFloat)delay
             stayTime:(CGFloat)stayTime
             position:(DSLToastViewPosition)position
              yOffset:(CGFloat)yOffset;

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
