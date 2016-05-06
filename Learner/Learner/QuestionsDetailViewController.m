//
//  QuestionsDetailViewController.m
//  Learner
//
//  Created by lfc on 16/4/19.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import "QuestionsDetailViewController.h"
#import "UIView+SDAutoLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface QuestionsDetailViewController ()<UITabBarControllerDelegate> {
    int count;
    UIImage *image;
}
//@property (strong , nonatomic) UILabel *problemLb;
//@property (strong , nonatomic) UIView *headerView;
@end

@implementation QuestionsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _optionObjectForShow = [NSMutableArray new];
    _tableView.tableFooterView = [UIView new];
    
    self.tabBarController.edgesForExtendedLayout = UIRectEdgeNone;
    
    //tableviewcell多选
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView.editing = !self.tableView.editing;
    
    //self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    
    _tableView.backgroundColor = [UIColor whiteColor];
    
    //初始化一个UIImageView对象，并将它添加到tableheaderView上
//    IV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//    IV.contentMode = UIViewContentModeScaleAspectFit;
//    [_headerView addSubview:IV];
    
    [self item];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//查询题目
- (void)item {
    UIActivityIndicatorView *AIV = [Utilities getCoverOnView:self.view];
    self.navigationController.view.userInteractionEnabled = NO;
    
    PFRelation *relationItem = [_testObj relationForKey:@"relationItem"];
    PFQuery *testQuery = [relationItem query];
    [testQuery whereKey:@"pointerItemType" equalTo:_itemTypeObj];
    
    [testQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable itemObjects, NSError * _Nullable error) {
        [AIV stopAnimating];
        self.navigationController.view.userInteractionEnabled = YES;
        if (!error) {
            //NSLog(@"ite = %lu",itemObjects.count);
            if (itemObjects.count == 0) {
                _problemLb.text = @"暂无内容";
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
    [self showOption];
    //[IV removeFromSuperview];
    self.navigationItem.title =  [NSString stringWithFormat:@"%d/%lu",count+1,(unsigned long)_itemObjectForShow.count];
    PFObject *itemObj = _itemObjectForShow[count];
    NSString *itemStr = itemObj[@"problem"];
    _problemLb.text = itemStr;
    _problemLb.height = [Utilities getTextHeight:itemStr textFont:_problemLb.font toViewRange:30];
    _problemLb.backgroundColor = [UIColor blueColor];
    if (itemObj[@"problemImage"] != nil) {
        NSLog(@"有图");
        PFFile *problemImageFile = itemObj[@"problemImage"];
        [problemImageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (!error) {
                image = [UIImage imageWithData:data];
                _problemIV.size = image.size;
                //_headerView.height = _problemIV.origin.y + _problemIV.size.height;
                _problemIV.image = image;
                _headerView.height = _problemIV.origin.y + _problemIV.size.height;
                _tableView.tableHeaderView = _headerView;

            }
        }];
        //_problemIV.size = image.size;
        NSString *problemImageURLStr = problemImageFile.url;
        NSURL *problemImageURL = [NSURL URLWithString:problemImageURLStr];
       // [_problemIV sd_setImageWithURL:problemImageURL placeholderImage:[UIImage imageNamed:@"Default"]];
        
        _headerView.height = _problemIV.origin.y + _problemIV.size.height;
        
    } else {
    _headerView.height = _problemLb.height + 11;
    }
    _tableView.tableHeaderView = _headerView;
}

- (void)showOption {
    UIActivityIndicatorView *AIV = [Utilities getCoverOnView:self.view];
    self.navigationController.view.userInteractionEnabled = NO;
    [_optionObjectForShow removeAllObjects];
    //此处itemObjects可以拿到题目表的数据
    PFObject *itemObj = _itemObjectForShow[count];
    PFRelation *relationOptiion = [itemObj relationForKey:@"relationOption"];
    PFQuery *itemQuery1 = [relationOptiion query];
    [itemQuery1 orderByAscending:@"content"];
    [itemQuery1 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable optionObjects, NSError * _Nullable error) {
        [AIV stopAnimating];
        self.navigationController.view.userInteractionEnabled = YES;

        if (!error) {
            _optionObjectForShow = [NSMutableArray arrayWithArray:optionObjects];;
            [_tableView reloadData];
                //此处optionObjects为选择题的选项
        } else {
                NSLog(@"optionError = %@",error.userInfo);
        }
            
    }];
        
    //这里是根据relationAnswer字段查到对应的Answer表里的内容
    PFRelation *relationAnswer = [itemObj relationForKey:@"relationAnswer"];
    PFQuery *itemQuery2 = [relationAnswer query];
    [itemQuery2 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable answerObjects, NSError * _Nullable error) {
        if (!error) {
                //此处optionObjects为选择题的答案
        } else {
                NSLog(@"answerError = %@",error.userInfo);
        }
            
    }];
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
    return _optionObjectForShow.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    PFObject * obj = _optionObjectForShow[indexPath.row];
    cell.textLabel.text = obj[@"content"];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    if ([obj[@"color"] isEqualToString:@"green"]) {
        //可自定义颜色
        //UIColor *color = [[UIColor alloc]initWithRed:0.0 green:0.0 blue:0.0 alpha:1];
        cell.selectedBackgroundView.backgroundColor = [UIColor greenColor];
    } else {
        cell.selectedBackgroundView.backgroundColor = [UIColor redColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //取消选中
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
     //PFObject * obj = _optionObjectForShow[indexPath.row];
    
}


- (IBAction)upAction:(UIBarButtonItem *)sender {
    _downBarBI.enabled = YES;
    if (count <= 0) {
        _upBarBI.enabled = NO;
        [Utilities popUpAlertViewWithMsg:@"已到第一页,不能再往前了！" andTitle:nil onView:self];
        
    } else {
        count --;
        [self showItem];
}

}

- (IBAction)downAction:(UIBarButtonItem *)sender {
    _upBarBI.enabled = YES;
    if (count >= _itemObjectForShow.count -1 ) {
        _downBarBI.enabled = NO;
        [Utilities popUpAlertViewWithMsg:@"已到最后一页，不能再往后了！" andTitle:nil onView:self];
    } else {
        count ++;
        [self showItem];
    }
}


@end
