//
//  DSLToastView.h
//  DSLToastViewDemo
//
//  Created by dengshunlai on 16/1/22.
//  Copyright © 2016年 dengshunlai. All rights reserved.
//

/*********************************************************************************
 *
 *
 * 该控件是一个单例
 * 感谢您的使用！
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
 *  文本
 */
@property (nonatomic, strong) NSString *text;

/**
 *  字体大小，默认17，根据文本和字体大小自动确定适合的宽度
 */
@property (nonatomic, assign) CGFloat fontSize;

/**
 *  高
 */
@property (nonatomic, assign) CGFloat height;

/**
 *  宽的补偿，默认为0，小于0变窄，大于0变宽
 */
@property (nonatomic, assign) CGFloat widthCompensate;

/**
 *  y坐标的偏移量，默认为0，在屏幕中间显示
 */
@property (nonatomic, assign) CGFloat yOffset;

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

//@property (nonatomic, assign) DSLToastViewStyle style;

/**
 *  toast显示的方法
 *
 *  @param text 显示的文本
 */
+ (void)toastWithText:(NSString *)text;

/**
 *  toast配置属性用此block，该控件是一个单例，block中会传入该单例以供配置
 *  例：
 *  [DSLToastView configureToastWithBlock:^(DSLToastView *sharedToast) {
 *      sharedToast.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.6];
 *      sharedToast.textColor = [UIColor whiteColor];
 *      sharedToast.height = 88;
 *      sharedToast.layer.cornerRadius = 25;
 *      sharedToast.yOffset = 0;
 *  }];
 *
 *  @param block 配置block
 */
+ (void)configureToastWithBlock:(DSLToastViewConfigureBlock)block;

@end
