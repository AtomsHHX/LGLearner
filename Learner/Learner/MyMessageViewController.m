//
//  MyMessageViewController.m
//  Learner
//
//  Created by admin on 16/4/19.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import "MyMessageViewController.h"
#import "detailMessageViewController.h"
@interface MyMessageViewController ()<UIScrollViewDelegate>
@property (strong , nonatomic) NSMutableArray *objectsForShow;
@property (strong , nonatomic) NSMutableArray *oneShow;
@property (strong, nonatomic) NSMutableArray *twoShow;

@property (strong, nonatomic) NSArray *forShow;

@end

@implementation MyMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView.tableFooterView = [UIView new];
    _objectsForShow = [NSMutableArray new];
    _oneShow = [NSMutableArray new];
    _twoShow = [NSMutableArray new];
    [self selectProblem];
    [_messageSegment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
}
- (void)change:(UISegmentedControl *)segmentedControl {
    [self selectProblem];
    //    if (segmentedControl.selectedSegmentIndex == 0) {
    //        _forShow = _oneShow;
    //    } else {
    //        _forShow = _twoShow;
    //    }
    
}
//根据用户名获取到当前用户有关的问题和回答
- (void)getProblem{
    //拿到当前登录的用户
    PFUser *currentUser = [PFUser currentUser];
    PFRelation *relationProblem = [currentUser relationForKey:@"relationProblem"];
    PFQuery *query = [relationProblem query];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable myProblemObjects, NSError * _Nullable error) {
        if (!error) {
            //可拿到该用户所有的问题，对每条问题遍历（如果每条问题对应的relationComment字段里面有数据(或者数据更新了)，说明有人回复了）
            for (PFObject *myProblemObj in myProblemObjects) {
                PFRelation *relationComment = myProblemObj[@"relationComment"];
                PFQuery *query2 = [relationComment query];
                [query2 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable myCommentobjects, NSError * _Nullable error) {
                    if (!error) {
                        NSLog(@"myCommentobjects = %@",myCommentobjects);
                    } else {
                        
                    }
                }];
            }
        } else {
            NSLog(@"error = %@",error.userInfo);
        }
    }];
}
- (void)getAnwser{
    //拿到当前登录的用户
    PFUser *currentUser = [PFUser currentUser];
    PFRelation *relationComment = [currentUser relationForKey:@"relationComment"];
    PFQuery *query = [relationComment query];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable myCommentObjects, NSError * _Nullable error) {
        if (!error) {
            //可拿到该用户所有的评论，对每条评论遍历（如果每条评论对应的relationAdditionalComment字段里面有数据，说明有人回复了）
            for (PFObject *myCommentObj in myCommentObjects) {
                PFRelation *relationAdditionalComment = myCommentObj[@"relationAdditionalComment"];
                PFQuery *query2 = [relationAdditionalComment query];
                [query2 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable myAdditionalCommentobjects, NSError * _Nullable error) {
                    if (!error) {
                        NSLog(@"myAdditionalCommentobjects = %@",myAdditionalCommentobjects);
                    } else {
                        
                    }
                }];
            }
        } else {
            NSLog(@"error = %@",error.userInfo);
        }
    }];
}
//查询问题表Problem
- (void)selectProblem {
    [_oneShow removeAllObjects];
    [_twoShow removeAllObjects];
    PFQuery *problemQuery = [PFQuery queryWithClassName:@"Problem"];
    [problemQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable problemObjects, NSError * _Nullable error) {
        if (!error) {
            //查询到所有问题
            _oneShow = [NSMutableArray arrayWithArray:problemObjects];
            [_tableView reloadData];
            NSLog(@"%lu",problemObjects.count);
            for (PFObject * problemObj in problemObjects) {
                PFRelation *relationComment = [problemObj relationForKey:@"relationComment"];
                PFQuery *commentQuery = [relationComment query];
                [commentQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable commentObjects, NSError * _Nullable error) {
                    if (!error) {
                        _twoShow = [NSMutableArray arrayWithArray:commentObjects];
                        [_tableView reloadData];
                        //这里查询每个问题所对应的评论
                        NSLog(@"%@",commentObjects);
                    } else {
                        NSLog(@"error = %@",error.userInfo);
                    }
                }];
            }
        } else {
            NSLog(@"error = %@",error.userInfo);
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
   // PFObject *obj = _objectsForShow[indexPath.row];
//    NSString *name = obj[@"name"];
//    cell.textLabel.text = name;
//    PFUser *currentUser = [PFUser currentUser];
//    NSString *imageString = [NSString stringWithFormat:@"%@",currentUser.username];//用户头像
//    NSURL *url = [[NSURL alloc] initWithString:imageString];
//    NSData *data =[[NSData alloc] initWithContentsOfURL:url];
//    UIImage *image = [[UIImage alloc] initWithData:data];
           PFObject *obj = _oneShow[indexPath.row];
        cell.textLabel.text =  obj[@"title"];
        NSLog(@"%@",obj[@"title"]);
   
//        PFObject *obj = _twoShow[indexPath.row];
//        cell.textLabel.text =  obj[@"content"];
//        NSLog(@"%@",obj[@"content"]);
  
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    detailMessageViewController *go = [Utilities getStoryboardInstanceByIdentity:@"Main" byIdentity:@"detail"];
    [self.navigationController pushViewController:go animated:YES];
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    // [self.tableview setEditing:YES];
}

#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqual:@"message"]) {
       // NSIndexPath *indexpath = _tableView.indexPathForSelectedRow;
        //PFObject *Pr = _objectsForShow[indexpath.row];
       // detailMessageViewController *PAVC = segue.destinationViewController;
       // PAVC.Pr = Pr;
        NSLog(@"goin");
    }
}
*/


@end
