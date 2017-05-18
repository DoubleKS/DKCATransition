//
//  DKCATransition.m
//  转场动画
//
//  Created by doublek on 2017/5/13.
//  Copyright © 2017年 doublek. All rights reserved.
//

#import "DKCATransition.h"

@interface DKCATransition ()<UIViewControllerAnimatedTransitioning,CAAnimationDelegate>


@property(nonatomic,weak)id<UIViewControllerContextTransitioning> transitoningContext;

@property(nonatomic,assign)BOOL isPresent;

@end

@implementation DKCATransition

#pragma mark - UIViewControllerTransitioningDelegate代理方法
//展现视图
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    self.isPresent = YES;
    return self;
}
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    //解除视图
    self.isPresent = NO;
    return self;
}

#pragma mark - UIViewControllerContextTransitioning代理方法
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    
    return 2;
}

//转场动画真正表演的舞台
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    //获取上下文的容器视图
    UIView *containView = transitionContext.containerView;
    //获取上下文的目标视图
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    UIView *view = self.isPresent ? toView : fromView;
    [containView addSubview:view];
    
    [self animationWithView:view];
    
    self.transitoningContext = transitionContext;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    //动画结束之后会解除转场动画
    //5.非常重要：一定要完成转场,否则系统会一直等待完成转场，此时会拦截所有的交互时间
    [self.transitoningContext completeTransition:YES];
}

-(void)animationWithView:(UIView*)view {
    
    //创建图形图层
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc]init];
    
    CGFloat mergin = 20;
    CGFloat radiu = 25;
    
    CGRect starRect = CGRectMake(view.bounds.size.width - mergin - radiu*2, mergin , radiu*2, radiu*2);
    
    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:starRect];
    
    CGFloat sWidth = view.frame.size.width;
    CGFloat sHeight = view.frame.size.height;
    
    //结束圆的半径
    CGFloat endRadius = sqrtf(sWidth*sWidth +sHeight*sHeight);

    CGRect endRect = CGRectInset(starRect, -(endRadius), -endRadius);
    
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:endRect];
    
    shapeLayer.fillColor = [UIColor blueColor].CGColor;
    shapeLayer.path = startPath.CGPath;
    
    view.layer.mask = shapeLayer;
    
    [self animationWithStartPath:startPath endPath:endPath ShapeLayer:shapeLayer];
    
}

-(void)animationWithStartPath:(UIBezierPath *)starPath endPath:(UIBezierPath *)endPath ShapeLayer:(CAShapeLayer *)shapeLayer {
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    
    basicAnimation.duration = [self transitionDuration:self.transitoningContext];
    
    basicAnimation.delegate = self;
    
    
    if (self.isPresent == YES) {
        
        basicAnimation.fromValue = (__bridge id _Nullable)(starPath.CGPath);
        basicAnimation.toValue = (__bridge id _Nullable)(endPath.CGPath);
    } else{
        
        basicAnimation.fromValue = (__bridge id _Nullable)(endPath.CGPath);
        basicAnimation.toValue = (__bridge id _Nullable)(starPath.CGPath);
    }
    //4.设置动画执行完毕不恢复  1.设置填充模式为向前填充  2.设置动画完成移除属性removedOnCompletion为NO
    basicAnimation.fillMode = kCAFillModeForwards;
    basicAnimation.removedOnCompletion = NO;
    
    //4.执行动画   谁要执行动画就将动画添加到谁身上
    [shapeLayer addAnimation:basicAnimation forKey:nil];
}

@end
