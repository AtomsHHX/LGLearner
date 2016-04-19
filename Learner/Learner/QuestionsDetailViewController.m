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

- (IBAction)upAction:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)downAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
