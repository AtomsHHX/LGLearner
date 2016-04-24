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
    [_tableView beginUpdates];
    _problemLb.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@",@"ad",@"aa",@"ad",@"ad",@"ad",@"ad",@"ad",@"ad"];
    CGRect newFrame = _problemLb.frame;
    NSLog(@"%f",newFrame.size.height);
    _headerView.frame = newFrame;
    [_tableView setTableHeaderView:_headerView];
    [_tableView endUpdates];
    //    if (_itemObjects == nil) {
//        _problemLb.text = @"暂无内容";
//    } else {
//    count = 0;
//    [self showItem];
//    }
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

//- (void)showItem {
//    PFObject *itemObj = _itemObjects[count];
//    _problemLb.text = itemObj[@"problem"];
//    if (_optionObjects == nil) {
//        _optionALb.text = @"暂无内容";
//    } else {
//        [self showOption];
//    }
//
//
//}
//
//- (void)showOption {
//   // NSLog(@"%@",_optionObjects);
//    PFObject *optionObjA = _optionObjects[0];
//    _optionALb.text = [NSString stringWithFormat:@"A. %@",optionObjA[@"content"]];
//    PFObject *optionObjB = _optionObjects[1];
//    _optionBLb.text = [NSString stringWithFormat:@"B. %@",optionObjB[@"content"]];
//    PFObject *optionObjC = _optionObjects[2];
//    _optionCLb.text = [NSString stringWithFormat:@"C. %@",optionObjC[@"content"]];
//    PFObject *optionObjD = _optionObjects[3];
//    _optionDLb.text = [NSString stringWithFormat:@"D. %@",optionObjD[@"content"]];
//}

//- (IBAction)upAction:(UIButton *)sender forEvent:(UIEvent *)event {
//    if (count <= 0) {
//        NSLog(@"到头上了%d",count);
//    } else {
//        count --;
//        [self showItem];
//    }
//    
//}
//
//- (IBAction)downAction:(UIButton *)sender forEvent:(UIEvent *)event {
//    if (count > _itemObjects.count -1) {
//        NSLog(@"itemcount = %lu",(unsigned long)_itemObjects.count);
//        NSLog(@"到尾巴了%d",count);
//    } else {
//         count ++;
//        [self showItem];
//    }
//   
//}
@end
