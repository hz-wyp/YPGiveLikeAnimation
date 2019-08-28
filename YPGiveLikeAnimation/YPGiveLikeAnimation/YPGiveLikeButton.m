//
//  YPGiveLikeButton.m
//  YPGiveLikeAnimation
//
//  Created by 王艳苹 on 2019/8/24.
//  Copyright © 2019 esk. All rights reserved.
//

#import "YPGiveLikeButton.h"
static CGFloat const duration = 0.5;

@interface YPGiveLikeButton ()<CAAnimationDelegate>

@property (nonatomic,strong) UIImageView *beforeImageView;
@property (nonatomic,strong) UIImageView *afterImageView;
    
@end

@implementation YPGiveLikeButton

- (instancetype)initWithFrame:(CGRect)frame image:(NSString *)image selectedImage:(NSString *)selectedImage {
    if (self = [super initWithFrame:frame]) {
        self.selected = NO;
        self.beforeImageView.image = [UIImage imageNamed:image];
        self.afterImageView.image = [UIImage imageNamed:selectedImage];
    }
    return self;
}
    
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.selected = NO;
        self.beforeImageView.backgroundColor = [UIColor yellowColor];
        self.afterImageView.backgroundColor = [UIColor greenColor];
    }
    return self;
}
    
- (void)layoutSubviews{
    [super layoutSubviews];
    self.beforeImageView.frame = self.bounds;
    self.afterImageView.frame = self.bounds;
}
    
- (void)beforeAction:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickInGiveLikeButton:)]) {
        [self.delegate clickInGiveLikeButton:self];
    }
    //可以自主调用动画开始的时间,如果需要在代理中的网络结束后开始动画,请注释[self startAnimation]; 手动调用动画
    [self startAnimation];
}
    
- (void)afterAction:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickInGiveLikeButton:)]) {
        [self.delegate clickInGiveLikeButton:self];
    }
    //可以自主调用动画开始的时间,如果需要在代理中的网络结束后开始动画,请注释[self cancelAnimation]; 手动调用动画
    [self cancelAnimation];
}
    
- (void)startAnimation{
    CGFloat length = 4;
    CGFloat width = 30;
    for (int i = 0; i < 6; i++) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.position = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
        layer.fillColor = self.color.CGColor;
        layer.strokeColor = [UIColor clearColor].CGColor;
        //画小三角
        UIBezierPath *startPath = [UIBezierPath bezierPath];
        [startPath moveToPoint:CGPointMake((-length) * 0.5, -width)];
        [startPath addLineToPoint:CGPointMake((length) * 0.5, -width)];
        [startPath addLineToPoint:CGPointMake(0, 0)];
        [startPath addLineToPoint:CGPointMake((- length) * 0.5, -width)];
        
        layer.path = startPath.CGPath;
        layer.transform = CATransform3DMakeRotation(M_PI / 3.0f * i, 0.0, 0.0, 1.0);
        [self.layer addSublayer:layer];
        //伸缩动画
        CABasicAnimation *scralAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scralAnimation.fromValue = @(0.0);;
        scralAnimation.toValue = @(1.0);
        scralAnimation.duration = duration * 0.2;
        
        //路径动画
        UIBezierPath *endPath = [UIBezierPath bezierPath];
        [endPath moveToPoint:CGPointMake(( -length) * 0.5, -width)];
        [endPath addLineToPoint:CGPointMake((length) * 0.5, -width)];
        [endPath addLineToPoint:CGPointMake(0, -width)];
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        pathAnimation.fromValue = (__bridge id)layer.path;
        pathAnimation.toValue = (__bridge id)endPath.CGPath;
        pathAnimation.beginTime = duration * 0.2;
        pathAnimation.duration = duration * 0.8;
        
        CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
        groupAnimation.animations = @[pathAnimation,scralAnimation];
        groupAnimation.fillMode = kCAFillModeForwards;
        groupAnimation.duration = duration;
        groupAnimation.removedOnCompletion = NO;//完成后是否移除
        groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        groupAnimation.delegate = self;
        [layer addAnimation:groupAnimation forKey:@"groupAnimation"];
    }
    [self performSelector:@selector(rotationAnimation) withObject:nil afterDelay:duration * 0.5];
}

- (void)rotationAnimation{
    self.selected = YES;
    self.afterImageView.userInteractionEnabled = NO;
    CAKeyframeAnimation *rotateAnima = [CAKeyframeAnimation  animationWithKeyPath:@"transform.rotation.z"];
    rotateAnima.values = @[@0.0, @(M_PI * 0.15), @(0.0)];
    rotateAnima.duration = duration * 0.5;
    rotateAnima.repeatCount = 1;
    rotateAnima.beginTime = CACurrentMediaTime();
    rotateAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotateAnima.delegate = self;

    [self.afterImageView.layer addAnimation:rotateAnima forKey:@"rotationAnimation"];
}

- (void)clearSubLayer{
    for (int i = 0; i < self.layer.sublayers.count; i++) {
        if ([self.layer.sublayers[i] isKindOfClass:[CAShapeLayer class]]) {
            [self.layer.sublayers[i] removeFromSuperlayer];
        }
    }
}

- (void)cancelAnimation{
    self.beforeImageView.hidden = NO;
    [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.afterImageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-M_PI_4), 0.1f, 0.1f);
    }completion:^(BOOL finished) {
        self.selected = NO;
        self.afterImageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    }];
}
    
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag && [anim isKindOfClass:[CAKeyframeAnimation class]]) {
        self.afterImageView.userInteractionEnabled = YES;
    }
    [self clearSubLayer];
}

- (void)addTapToView:(UIView *)toView action:(SEL)action{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:action];
    [toView addGestureRecognizer:tap];
}

- (void)setImage:(NSString *)image{
    _image = image;
    self.beforeImageView.image = [UIImage imageNamed:image];
}
    
- (void)setSelectedImage:(NSString *)selectedImage{
    _selectedImage = selectedImage;
    self.afterImageView.image = [UIImage imageNamed:selectedImage];
}
    
- (void)setSelected:(BOOL)selected{
    _selected = selected;
    if (!selected) {
        self.beforeImageView.hidden = NO;
        self.beforeImageView.userInteractionEnabled = YES;
        self.afterImageView.hidden = YES;
        self.afterImageView.userInteractionEnabled = NO;
    }else{
        self.beforeImageView.hidden = YES;
        self.beforeImageView.userInteractionEnabled = NO;
        self.afterImageView.hidden = NO;
        self.afterImageView.userInteractionEnabled = YES;
    }
}
    
- (UIImageView *)beforeImageView{
    if (!_beforeImageView) {
        _beforeImageView = [[UIImageView alloc]init];
        _beforeImageView.contentMode = UIViewContentModeCenter;
        _beforeImageView.backgroundColor = [UIColor clearColor];
        [self addTapToView:_beforeImageView action:@selector(beforeAction:)];
        [self addSubview:_beforeImageView];
    }
    return _beforeImageView;
}
    
- (UIImageView *)afterImageView{
    if (!_afterImageView) {
        _afterImageView = [[UIImageView alloc]init];
        _afterImageView.contentMode = UIViewContentModeCenter;
        [self addTapToView:_afterImageView action:@selector(afterAction:)];
        _afterImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_afterImageView];
    }
    return _afterImageView;
}

- (UIColor *)color{
    if (!_color) {
        _color = [UIColor redColor];
    }
    return _color;
}

@end
