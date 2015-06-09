//
//  Nav.m
//  CustomPopAnimation
//
//  Created by fenghuo on 15/6/8.
//  Copyright (c) 2015年 game. All rights reserved.
//

#import "Nav.h"

#import "NavigationInteractiveTransition.h"

#import <objc/runtime.h>

@interface Nav () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *popRecognizer;

// 方案一不需要的变量
@property (nonatomic, strong) NavigationInteractiveTransition *navT;

@end

@implementation Nav

- (void)Debug
{
    NSLog(@"---%@", self.interactivePopGestureRecognizer);
    
    unsigned int count = 0;
    
    // 获取类成员变量列表，count为类成员数量
    Ivar *var = class_copyIvarList([UIGestureRecognizer class], &count);
    for (int i = 0; i < count; i++) {
        Ivar _var = *(var+i);
        NSLog(@"%s", ivar_getTypeEncoding(_var));
        NSLog(@"%s", ivar_getName(_var));
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIGestureRecognizer *gesture = self.interactivePopGestureRecognizer;
    
    // 获取系统原始手势view，并把原始手手势关闭
    gesture.enabled = NO;
    UIView *gestureView = gesture.view;
    
    
    UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] init];
    popRecognizer.delegate = self;
    popRecognizer.maximumNumberOfTouches = 1;
    
    [gestureView addGestureRecognizer:popRecognizer];   // 原来的手势view，添加新的手势
    
#ifdef USE_方案一
    
    _navT = [[NavigationInteractiveTransition alloc] initWithViewController:self];
    [popRecognizer addTarget:_navT action:@selector(handleControllerPop:)];
    
#elif USE_方案二
    
    /**
     *  Runtime+KVC，获取系统原有的target，和action；
     *  加到我们自己创建的手势UIPanGestureRecognizer
     */
    
    
    /*
    // runtime相关测试
    [self Debug];
    
    NSMutableArray *_targets = [gesture valueForKey:@"_targets"];
    NSLog(@"%@", _targets);
    NSLog(@"%@", _targets[0]);
    */
    
    // 获取系统手势的target数组
    NSMutableArray *_targets = [gesture valueForKey:@"_targets"];
    
    // 获取它的唯一对象，我们知道它是一个叫UIGestureRecognizerTarget的私有类，它有一个属性叫_target
    id gestureRecognizerTarget = [_targets firstObject];
    
    // 获取_target:_UINavigationInteractiveTransition，它有一个方法叫handleNavigationTransition:
    id navigationInteractiveTransition = [gestureRecognizerTarget valueForKey:@"_target"];
    
    // 通过前面的打印，我们从控制台获取出来它的方法签名。
    SEL handleTransition = NSSelectorFromString(@"handleNavigationTransition:");
    
    // 创建一个与系统一模一样的手势，我们只把它的类改为UIPanGestureRecognizer
    [popRecognizer addTarget:navigationInteractiveTransition action:handleTransition];
    
#endif 
    
}



- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 这里有两个条件不允许手势执行，1、当前控制器为根控制器；2、如果这个push、pop动画正在执行（私有属性）
    return self.viewControllers.count != 1 && ![[self valueForKey:@"_isTransitioning"] boolValue];
}




@end
