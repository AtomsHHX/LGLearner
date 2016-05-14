//
//  ItemTypeViewController.m
//  Learner
//
//  Created by lfc on 16/4/24.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import "ItemTypeViewController.h"
#import "QuestionsDetailViewController.h"
#import "CalculationViewController.h"

@interface ItemTypeViewController ()


@end

@implementation ItemTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _objectForShow = [NSMutableArray new];
    _tableView.tableFooterView = [[UIView alloc] init];
    self.navigationItem.title = @"题型选择";
    
    UIActivityIndicatorView *AIV = [Utilities getCoverOnView:self.view];
    self.navigationController.view.userInteractionEnabled = NO;
    
    PFQuery *query = [PFQuery queryWithClassName:@"ItemType"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [AIV stopAnimating];
        self.navigationController.view.userInteractionEnabled = YES;
        
        if (!error) {
            _objectForShow = [NSMutableArray arrayWithArray:objects];
            [_tableView reloadData];
        } else {
            NSLog(@"error = %@",error.userInfo);
        }
    }];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objectForShow.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    PFObject *obj = _objectForShow[indexPath.row];
    cell.textLabel.text = obj[@"type"];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QuestionsDetailViewController *QDVC = [Utilities getStoryboardInstanceByIdentity:@"Main" byIdentity:@"QuestionsDetail"];
    CalculationViewController *CVC = [Utilities getStoryboardInstanceByIdentity:@"Main" byIdentity:@"CalculationVC"];
    PFObject *obj = _objectForShow[indexPath.row];
    if ([obj[@"type"] isEqualToString:@"选择题"]) {
        QDVC.itemTypeObj = obj;
        QDVC.testObj = _testObj;
        [self.navigationController pushViewController:QDVC animated:YES];
    } else if ([obj[@"type"] isEqualToString:@"计算题"]) {
        CVC.itemTypeObj = obj;
        CVC.testObj = _testObj;
        [self.navigationController pushViewController:CVC animated:YES];
    } else {
        [Utilities popUpAlertViewWithMsg:@"暂无内容" andTitle:nil onView:self];
    }
    
    
}

@end
