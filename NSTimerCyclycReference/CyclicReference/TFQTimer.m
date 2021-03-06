//
//  TFQTimer.m
//  TFQCyclycReference
//
//  Created by 王立志 on 2018/6/19.
//  Copyright © 2018年 Thread_Fight_Queue. All rights reserved.
//

#import "TFQTimer.h"

@interface TFQTimer ()

@property (nonatomic, strong)NSTimer *timer;

@end

@implementation TFQTimer

- (instancetype)initWithTimeInterval:(NSTimeInterval)interval Target:(id)target andSelector:(SEL)selector{
    if(self == [super init]){
        self.target = target;
        self.selector = selector;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(dosomething) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)dosomething{
    //为了不阻挡主线程，所以要异步。
    dispatch_async(dispatch_get_main_queue(), ^{
        id target = self.target;
        SEL selector = self.selector;
        if([target respondsToSelector:selector]){
            //解释参考另一个demo https://github.com/LiZhiDaDa/TFQWeakTimer
            //[target performSelector:selector withObject:nil];
            IMP imp = [target methodForSelector:selector];
            void (*func)(id, SEL) = (void *)imp;
            func(target, selector);
        }
    });
}

- (void)closeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)dealloc{
    NSLog(@"TFQTimer dealloc");
}

@end
