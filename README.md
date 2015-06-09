

##轻松学习之 iOS利用Runtime自定义控制器POP手势动画


[Cocoachina地址]
http://www.cocoachina.com/ios/20150605/12042.html

[作者简书地址]
http://www.jianshu.com/p/d39f7d22db6c


####Xcode工程创建多个target

CustomPopAnimation中，通过复制Target；
使用宏定义生成不同的Target，
OTHER_CFLAGS = -DUSE_方案一;


####Runtime+KVC 

    NSLog(@"---%@", self.interactivePopGestureRecognizer);
    
    unsigned int count = 0;
    
    // 获取类成员变量列表，count为类成员数量
    Ivar *var = class_copyIvarList([UIGestureRecognizer class], &count);
    for (int i = 0; i < count; i++) {
        Ivar _var = *(var+i);
        NSLog(@"%s", ivar_getTypeEncoding(_var));
        NSLog(@"%s", ivar_getName(_var));
    }

    NSMutableArray *_targets = [gesture valueForKey:@"_targets"];
    NSLog(@"%@", _targets);
    NSLog(@"%@", _targets[0]);



