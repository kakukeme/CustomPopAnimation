//
//  PopAnimation.m
//  CustomPopAnimation
//
//  Created by fenghuo on 15/6/8.
//  Copyright (c) 2015年 game. All rights reserved.
//

#import "PopAnimation.h"

/**
 *  自定义转场动画
 */

@interface PopAnimation () 

// transitionContext你可以看作是一个工具，用来获取一系列动画执行相关的对象，并且通知系统,动画是否完成等功能。
@property (nonatomic, strong) id <UIViewControllerContextTransitioning> transitionContext;

@end

@implementation PopAnimation

// 这个方法返回动画执行的时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 获取动画来自的那个控制器
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    // 获取转场到的那个控制器
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    /**
     *  转场动画是两个控制器视图之间的动画，需要一个containerView来作为一个“舞台”，让动画执行。
     */
    UIView *containerView = [transitionContext containerView];
    
    // toVC.view放到fromVC之下；pop后，变成第一个；
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    // 执行动画,我们让fromVC的视图移动到屏幕最右侧
    [UIView animateWithDuration:duration animations:^{
        
        fromViewController.view.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
        
    } completion:^(BOOL finished) {
        
        // 当你的动画执行完成，这个方法必须要调用，否则系统会认为你的其余任何操作都在动画执行过程中。
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    
    
    _transitionContext = transitionContext;
    
    //----------------pop动画一-------------------------//
    
    /*
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:containerView cache:YES];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
    [UIView commitAnimations];
    [containerView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    */
    
    //----------------pop动画二-------------------------//
    
    /*
    CATransition *tr = [CATransition animation];
    tr.type = @"cube";
    tr.subtype = @"fromLeft";
    tr.duration = duration;
    tr.removedOnCompletion = NO;
    tr.fillMode = kCAFillModeForwards;
    tr.delegate = self;
    [containerView.layer addAnimation:tr forKey:nil];
    [containerView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
     */
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [_transitionContext completeTransition:!_transitionContext.transitionWasCancelled];
}



@end
