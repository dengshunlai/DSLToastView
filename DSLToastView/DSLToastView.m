//
//  DSLToastView.m
//  DSLToastViewDemo
//
//  Created by 邓顺来 on 16/1/22.
//  Copyright © 2016年 邓顺来. All rights reserved.
//

#import "DSLToastView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenCenter CGPointMake(kScreenWidth / 2, kScreenHeight / 2)

static CGFloat const kFontSize = 17;
static CGFloat const kWidthExtra = 60;
static CGFloat const kHeightExtra = 20;
static CGFloat const kWidthCompensate = 0;
static CGFloat const kHeightCompensate = 0;
static CGFloat const kYOffset = 0;
static CGFloat const kCornerRadius = 10;
static CGFloat const kFadeDismissAnimationDuration = 0.3;
static CGFloat const kFadeStartAnimationDuration = 0.2;
static CGFloat const kStayTime = 1;
static CGFloat const kBottomSpace = 49;

static DSLToastView *_sharedToast;


@interface DSLToastView () <CAAnimationDelegate>

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) BOOL isToastStaying;

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
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:text attributes:toast.textAttributes];
    [self toastWithAttributedText:attrStr isCenter:YES];
}

+ (void)bottomToastWithText:(NSString *)text
{
    DSLToastView *toast = [DSLToastView sharedInstance];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:text attributes:toast.textAttributes];
    [self toastWithAttributedText:attrStr isCenter:NO];
}

+ (void)toastWithAttributedText:(NSAttributedString *)attributedText
{
    [self toastWithAttributedText:attributedText isCenter:YES];
}

+ (void)bottomToastWithAttributedText:(NSAttributedString *)attributedText
{
    [self toastWithAttributedText:attributedText isCenter:NO];
}

+ (void)toastWithText:(NSString *)text after:(CGFloat)second
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self toastWithText:text];
    });
}

+ (void)bottomToastWithText:(NSString *)text after:(CGFloat)second
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self bottomToastWithText:text];
    });
}

+ (void)toastWithAttributedText:(NSAttributedString *)attributedText isCenter:(BOOL)isCenter;
{
    DSLToastView *toast = [DSLToastView sharedInstance];
    toast.text = attributedText;
    toast.frame = CGRectMake(0, 0, toast.width, toast.height);
    CGPoint center = kScreenCenter;
    if (isCenter) {
        center.y += toast.yOffset;
    } else {
        center.y = kScreenHeight - kBottomSpace - toast.height / 2;
        center.y += toast.yOffset;
    }
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
    
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
    para.paragraphSpacing = 5;
    para.alignment = NSTextAlignmentCenter;
    
    _fontSize = kFontSize;
    _isToastStaying = NO;
    _fadeStartAnimationDuration = kFadeStartAnimationDuration;
    _fadeDismissAnimationDuration = kFadeDismissAnimationDuration;
    _stayTime = kStayTime;
    _widthCompensate = kWidthCompensate;
    _heightCompensate = kHeightCompensate;
    _yOffset = kYOffset;
    _textColor = [UIColor whiteColor];
    _textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:_fontSize],
                        NSForegroundColorAttributeName:_textColor,
                        NSParagraphStyleAttributeName:para}.mutableCopy;

    [self creatLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _label.frame = CGRectMake(0, 5, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 10);
}

#pragma mark - Instance method

+ (void)configureToastWithBlock:(DSLToastViewConfigureBlock)block
{
    block([DSLToastView sharedInstance]);
}

+ (void)reset
{
    [[DSLToastView sharedInstance] initialization];
}

#pragma mark - Set method

- (void)setText:(NSAttributedString *)text
{
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
    
    _label.attributedText = text;
    
    if (textRect.size.width + kWidthExtra < kScreenWidth - 20) {
        _width = ceil(textRect.size.width + kWidthExtra + _widthCompensate);
    } else {
        _width = kScreenWidth - 20;
    }
    _height = ceil(textRect.size.height + kHeightExtra + _heightCompensate);
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    NSMutableDictionary *temp = _textAttributes.mutableCopy;
    temp[NSForegroundColorAttributeName] = textColor;
    _textAttributes = temp;
}

- (void)setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
    NSMutableDictionary *temp = _textAttributes.mutableCopy;
    temp[NSFontAttributeName] = [UIFont systemFontOfSize:fontSize];
    _textAttributes = temp;
}

#pragma mark - Create UI

- (void)creatLabel
{
    if (_label) {
        return;
    }
    _label = [[UILabel alloc] init];
    _label.backgroundColor = [UIColor clearColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor whiteColor];
    _label.numberOfLines = 0;
    
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
        [self.layer removeAnimationForKey:@"appear"];
        [self performSelector:@selector(dismissToast) withObject:nil afterDelay:_stayTime inModes:@[NSRunLoopCommonModes]];
        _isToastStaying = YES;
    }
    else if ([self.layer animationForKey:@"dismiss"] == anim) {
        [self.layer removeAnimationForKey:@"dismiss"];
        [self removeFromSuperview];
    }
}

@end
