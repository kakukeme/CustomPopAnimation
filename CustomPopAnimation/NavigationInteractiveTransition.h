//
//  NavigationInteractiveTransition.h
//  CustomPopAnimation
//
//  Created by fenghuo on 15/6/8.
//  Copyright (c) 2015年 game. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIViewController, UIPercentDrivenInteractiveTransition;

@interface NavigationInteractiveTransition : NSObject <UINavigationControllerDelegate>

- (instancetype)initWithViewController:(UIViewController *)vc;

- (void)handleControllerPop:(UIPanGestureRecognizer *)recognizer;


- (UIPercentDrivenInteractiveTransition *)interactivePopTransition;

@end
