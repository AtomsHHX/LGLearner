//
//  QuestionsDetailViewController.m
//  Learner
//
//  Created by lfc on 16/4/19.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import "QuestionsDetailViewController.h"
#import "UIView+SDAutoLayout.h"

@interface QuestionsDetailViewController () {
    int count;
}
//@property (strong , nonatomic) UILabel *problemLb;
//@property (strong , nonatomic) UIView *headerView;
@end

@implementation QuestionsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _optionObjectForShow = [NSMutableArray new];
    self.navigationItem.title = @"选择题";
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
    //[testQuery whereKey:@"type" equalTo:_itemType];
    
    [testQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable itemObjects, NSError * _Nullable error) {
        if (!error) {
           // NSLog(@"itob = %@",itemObjects);
            _itemObjectForShow = itemObjects;
            [self showOption];
            if (_itemObjectForShow == nil) {
                _problemLb.text = @"暂无内容";
            } else {
                count = 0;
                [self showItem];
            }
        } else {
            NSLog(@"itemError = %@",error.userInfo);
        }
    }];
}

- (void)showItem {
    
    PFObject *itemObj = _itemObjectForShow[count];
    NSString *itemStr = itemObj[@"problem"];
    NSLog(@"%@",itemStr);
    CGSize maxSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width - 30, 1000);
    CGSize contentLabelSize = [itemStr boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_problemLb.font} context:nil].size;
    _headerView.height = contentLabelSize.height ;
    _tableView.tableHeaderView = _headerView;
    _problemLb.text = itemStr;
    //_problemLb.sd_layout.autoHeightRatio(0);
}

- (void)showOption {
    [_optionObjectForShow removeAllObjects];
    //此处itemObjects可以拿到题目表的数据
    PFObject *itemObj = _itemObjectForShow[count];
    PFRelation *relationOptiion = [itemObj relationForKey:@"relationOption"];
    PFQuery *itemQuery1 = [relationOptiion query];
    [itemQuery1 orderByAscending:@"content"];
    [itemQuery1 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable optionObjects, NSError * _Nullable error) {
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _optionObjectForShow.count;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    
//    return 10;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    PFObject * obj = _optionObjectForShow[indexPath.row];
    cell.textLabel.text = obj[@"content"];
    NSLog(@"%@",obj[@"content"]);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
