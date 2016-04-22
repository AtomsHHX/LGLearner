//
//  QuestionsDetailViewController.m
//  Learner
//
//  Created by lfc on 16/4/19.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import "QuestionsDetailViewController.h"

@interface QuestionsDetailViewController () {
    int count;
}

@end

@implementation QuestionsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"选择题";
    if (_itemObjects == nil) {
        _problemLb.text = @"暂无内容";
    } else {
    count = 0;
    [self showItem];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)showItem {
        PFObject *itemObj = _itemObjects[count];
        _problemLb.text = itemObj[@"problem"];
}

- (IBAction)upAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if (count <= 0) {
        NSLog(@"到头上了%d",count);
    } else {
        count --;
        [self showItem];
    }
    
}

- (IBAction)downAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if (count >= _itemObjects.count) {
        NSLog(@"itemcount = %lu",(unsigned long)_itemObjects.count);
        NSLog(@"到尾巴了%d",count);
    } else {
         count ++;
        [self showItem];
    }
   
}
@end
