//
//  ViewController.m
//  RuntimeCrash
//
//  Created by N3210 on 2018/5/4.
//  Copyright © 2018年 N3210. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self testArray];
    [self testDic];
    NSLog(@"sdf");
}

- (void)testArray{
    NSArray *array=@[@"sdf",@"ssdfds"];
    [array objectAtIndex:2];
}

- (void)testDic{
    NSString *nilKey=nil;
    NSString *nilValue=nil;
    NSDictionary *dict =@{@"sdf":nilKey};
    NSDictionary *dict2 =@{nilValue:@"sdf"};
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
