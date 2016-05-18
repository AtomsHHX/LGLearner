//
//  CalculationViewController.m
//  Learner
//
//  Created by lfc on 16/4/25.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import "CalculationViewController.h"

@interface CalculationViewController () {
    int count;
}

@end

@implementation CalculationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self item];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//查询题目
- (void)item {
    PFRelation *relationItem = [_testObj relationForKey:@"relationItem"];
    PFQuery *testQuery = [relationItem query];
    //[testQuery includeKey:@"pointerItemType"];
    [testQuery whereKey:@"pointerItemType" equalTo:_itemTypeObj];
    
    [testQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable itemObjects, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"ite = %lu",itemObjects.count);
            if (itemObjects.count == 0) {
                _contentLb.text = @"暂无内容";
            } else {
                _itemObjectForShow = itemObjects;
                count = 0;
                [self showItem];
            }
        } else {
            NSLog(@"itemError = %@",error.userInfo);
        }
    }];
}

- (void)showItem {
    PFObject *obj = _itemObjectForShow[count];
    _contentLb.text = obj[@"content"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
