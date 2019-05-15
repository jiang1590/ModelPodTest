//
//  ViewController.m
//  ReactiveCocoaDemo
//
//  Created by UTWL_IOS_iMac on 2019/5/14.
//  Copyright © 2019 UTWL_IOS_iMac. All rights reserved.
//

#import "ViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self signalSwitch];
    
}
//uppercaseString use map
- (void)uppercaseString {
    
    RACSequence *sequence = [@[@"you", @"are", @"beautiful"] rac_sequence];
    
    RACSignal *signal =  sequence.signal;
    
    RACSignal *capitalizedSignal = [signal map:^id(NSString * value) {
        return [value capitalizedString];
    }];
    
    [signal subscribeNext:^(NSString * x) {
        NSLog(@"signal --- %@", x);
    }];
    
    [capitalizedSignal subscribeNext:^(NSString * x) {
        NSLog(@"capitalizedSignal --- %@", x);
    }];
}
//信号开关Switch
- (void)signalSwitch {
    //创建3个自定义信号
    RACSubject *google = [RACSubject subject];
    RACSubject *baidu = [RACSubject subject];
    RACSubject *signalOfSignal = [RACSubject subject];
    
    //获取开关信号
    RACSignal *switchSignal = [signalOfSignal switchToLatest];
    
    //对通过开关的信号进行操作
    [[switchSignal  map:^id(NSString * value) {
        return [@"https//www." stringByAppendingFormat:@"%@", value];
    }] subscribeNext:^(NSString * x) {
        NSLog(@"hello----%@", x);
    }];
    
    
    //通过开关打开baidu
    [signalOfSignal sendNext:baidu];
    [baidu sendNext:@"baidu.com"];
    [google sendNext:@"google.com"];
    
    //通过开关打开google
    [signalOfSignal sendNext:google];
    [baidu sendNext:@"baidu.com/"];
    [google sendNext:@"google.com/"];
}
@end
