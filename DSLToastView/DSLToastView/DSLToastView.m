//
//  DSLToastView.m
//  DSLToastViewDemo
//
//  Created by dengshunlai on 16/1/22.
//  Copyright © 2016年 dengshunlai. All rights reserved.
//

#import "DSLToastView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenCenter CGPointMake(kScreenWidth / 2, kScreenHeight / 2)

static CGFloat const kFontSize = 17;
static CGFloat const kHeight = 40;
static CGFloat const kWidthExtra = 60;
static CGFloat const kWidthCompensate = 0;
static CGFloat const kYOffset = 0;
static CGFloat const kCornerRadius = 10;
static CGFloat const kFadeDismissAnimationDuration = 0.3;
static CGFloat const kFadeStartAnimationDuration = 0.2;
static CGFloat const kStayTime = 1;

static DSLToastView *_sharedToast;


@interface DSLToastView ()

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) BOOL isToastStaying;

@property (nonatomic, copy) DSLToastViewConfigureBlock configureBlock;

@end


@implementation DSLToastView

#pragma mark - Life cycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

+ (instancetype)sharedInstance
{
    if (!_sharedToast) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedToast = [[DSLToastView alloc] init];
        });
    }
    return _sharedToast;
}

+ (void)toastWithText:(NSString *)text
{
    DSLToastView *toast = [DSLToastView sharedInstance];
    toast.text = text;
    toast.frame = CGRectMake(0, 0, toast.width, toast.height);
    CGPoint center = kScreenCenter;
    center.y = center.y + toast.yOffset;
    toast.center = center;
    [[UIApplication sharedApplication].keyWindow addSubview:toast];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:toast selector:@selector(dismissToast) object:nil];
    [toast.layer removeAnimationForKey:@"dismiss"];
    [toast.layer removeAnimationForKey:@"appear"];
    
    if (toast.isToastStaying) {
        [toast performSelector:@selector(dismissToast) withObject:nil afterDelay:toast.stayTime inModes:@[NSRunLoopCommonModes]];
    } else {
        [toast appearToast];
    }
}

- (void)initialization
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.layer.cornerRadius = kCornerRadius;
    self.layer.masksToBounds = YES;
    
    _height = kHeight;
    _fontSize = kFontSize;
    _isToastStaying = NO;
    _fadeStartAnimationDuration = kFadeStartAnimationDuration;
    _fadeDismissAnimationDuration = kFadeDismissAnimationDuration;
    _stayTime = kStayTime;
    _widthCompensate = kWidthCompensate;
    _yOffset = kYOffset;

    [self creatLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _label.frame = self.bounds;
}

- (void)drawRect:(CGRect)rect
{
    ;
}

#pragma mark - Instance method

+ (void)configureToastWithBlock:(DSLToastViewConfigureBlock)block
{
    [DSLToastView sharedInstance].configureBlock = block;//
    block([DSLToastView sharedInstance]);
}

#pragma mark - Set method

- (void)setText:(NSString *)text
{
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(kScreenWidth, kHeight)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kFontSize]}
                                         context:nil];
    _text = text;
    _label.text = _text;
    
    if (textRect.size.width + kWidthExtra < kScreenWidth - 20) {
        
        _width = textRect.size.width + kWidthExtra + _widthCompensate;
    }
    else {
        _width = kScreenWidth - 20;
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    _label.textColor = _textColor;
}

- (void)setHeight:(CGFloat)height
{
    _height = height;
}

#pragma mark - Create UI

- (void)creatLabel
{
    _label = [[UILabel alloc] init];
    _label.backgroundColor = [UIColor clearColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor whiteColor];
    
    [self addSubview:_label];
}

#pragma mark - Other method

- (void)appearToast
{
    CABasicAnimation *appear = [CABasicAnimation animationWithKeyPath:@"opacity"];
    appear.fromValue = @(0);
    appear.toValue = @(1);
    appear.duration = _fadeStartAnimationDuration;
    appear.removedOnCompletion = NO;
    appear.fillMode = kCAFillModeForwards;
    appear.delegate = self;
    
    [self.layer addAnimation:appear forKey:@"appear"];
}

#pragma mark - Target method

- (void)dismissToast
{
    _isToastStaying = NO;
    
    CABasicAnimation *dismiss = [CABasicAnimation animationWithKeyPath:@"opacity"];
    dismiss.fromValue = @(1);
    dismiss.toValue = @(0);
    dismiss.duration = _fadeDismissAnimationDuration;
    dismiss.removedOnCompletion = NO;
    dismiss.fillMode = kCAFillModeForwards;
    dismiss.delegate = self;
    
    [self.layer addAnimation:dismiss forKey:@"dismiss"];
}

#pragma mark - Animation delegate

- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag
{
    if ([self.layer animationForKey:@"appear"] == anim) {
        
        [self.layer removeAnimationForKey:@"appear"];//NSDefaultRunLoopMode;UITrackingRunLoopMode;NSRunLoopCommonModes;
        [self performSelector:@selector(dismissToast) withObject:nil afterDelay:kStayTime inModes:@[NSRunLoopCommonModes]];
        _isToastStaying = YES;
    }
    else if ([self.layer animationForKey:@"dismiss"] == anim) {
        
        [self.layer removeAnimationForKey:@"dismiss"];
        [self removeFromSuperview];
    }
}

@end
