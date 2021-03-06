//
//  MyMessageViewController.m
//  Learner
//
//  Created by admin on 16/4/19.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import "MyMessageViewController.h"
#import "MessageTableViewCell.h"
#import "ProblemDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface MyMessageViewController ()<UIScrollViewDelegate>
@property (strong , nonatomic) NSMutableArray *objectsForShow;
//@property (strong , nonatomic) NSMutableArray *oneShow;
//@property (strong, nonatomic) NSMutableArray *twoShow;
@property (strong ,nonatomic) NSMutableArray *Logs;
@property (strong, nonatomic) NSArray *forShow;

@end

@implementation MyMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView.tableFooterView = [UIView new];
    _objectsForShow = [NSMutableArray new];
   self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
   
    [self getProblem];
    [_messageSegment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    
    self.Logs = [NSMutableArray new];
    NSDate *date = [NSDate date];
    [_Logs addObject:date];
   
    UIRefreshControl *rc = [UIRefreshControl new];
    rc.tag = 1001;
   NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
   //dateF.dateFormat = @"YYYY-MM-dd HH:mm:ss";
   NSString *timeF = [dateF stringFromDate:date];
    NSString *time = [NSString stringWithFormat:@"⬇️下拉刷新%@",timeF];
   NSLog(@"shij:%@",timeF);
    rc.attributedTitle = [[NSAttributedString alloc] initWithString:time];
   
    [rc addTarget:self action:@selector(refreshDate) forControlEvents:UIControlEventValueChanged];
   UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(130.0f, 0.0f, 60.0f, 60.0f)];
   [activity startAnimating];
    //[rc addTarget:self action:@selector(getAnwser) forControlEvents:UIControlEventValueChanged];
    //[rc addTarget:self action:@selector(selectProblem) forControlEvents:UIControlEventEditingChanged];
    //[self setre];
   [_tableView addSubview:rc];
}
- (void)refreshDate{
   if (_messageSegment.selectedSegmentIndex == 0) {
      
      [self getProblem];
   }else{
      [self getAnwser];
   }
}
- (void)change:(UISegmentedControl *)segmentedControl {
        if (segmentedControl.selectedSegmentIndex == 0) {
            [self getProblem];
        } else {
            [self getAnwser];
        }
    
}
//根据用户名获取到当前用户有关的问题和回答
- (void)getProblem{
   // [_oneShow removeAllObjects];
    //拿到当前登录的用户
    PFUser *currentUser = [PFUser currentUser];
    PFRelation *relationProblem = [currentUser relationForKey:@"relationProblem"];
    PFQuery *query = [relationProblem query];
   [query includeKey:@"pointerUser"];
   [query orderByDescending:@"createdAt"];
   UIActivityIndicatorView *AIV = [Utilities getCoverOnView:self.view];
   [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable myProblemObjects, NSError * _Nullable error) {
      [AIV stopAnimating];
      UIRefreshControl *rc = (UIRefreshControl *)[_tableView viewWithTag:1001];
      [rc endRefreshing];
      if (!error) {
         _forShow = myProblemObjects;
         // NSLog(@"%@",_forShow);
         [_tableView reloadData];
         //可拿到该用户所有的问题，对每条问题遍历（如果每条问题对应的relationComment字段里面有数据(或者数据更新了)，说明有人回复了）
         for (PFObject *myProblemObj in myProblemObjects) {
               PFRelation *relationComment = myProblemObj[@"relationComment"];
               PFQuery *query2 = [relationComment query];
               [query2 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable myCommentobjects, NSError * _Nullable error) {
                  if (!error) {
                       // NSLog(@"myCommentobjects = %@",myCommentobjects);
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
    //[_twoShow removeAllObjects];
    //拿到当前登录的用户
    PFUser *currentUser = [PFUser currentUser];
    PFRelation *relationComment = [currentUser relationForKey:@"relationComment"];
    PFQuery *query = [relationComment query];
   [query includeKey:@"pointerUser"];
   [query orderByDescending:@"createdAt"];
   UIActivityIndicatorView *AIV = [Utilities getCoverOnView:self.view];
   [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable myCommentObjects, NSError * _Nullable error) {
       [AIV stopAnimating];
        UIRefreshControl *rc = (UIRefreshControl *)[_tableView viewWithTag:1001];
        [rc endRefreshing];
        if (!error) {
            _forShow = myCommentObjects;
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
   MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
   PFObject *obj = _forShow[indexPath.row];
   
   //返回cell的高度
   return cell.conmentLb.frame.origin.y + [Utilities getTextHeight:obj[@"content"] textFont:cell.conmentLb.font toViewRange:10] + 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _forShow.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
     PFObject *obj = _forShow[indexPath.row];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
   [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
   PFUser *userObj = obj[@"pointerUser"];
   NSString *nickname = userObj[@"nickname"];
   NSDate *createdAt = obj.createdAt;
   NSString *startTime = [dateFormatter stringFromDate:createdAt];
   
   PFFile *photoFile = userObj[@"headPhoto"];
   NSString *photoURLStr=photoFile.url;
   //获取parse数据库中某个文件的网络路径
   NSURL  *photoURL=[NSURL URLWithString:photoURLStr];
   ////结合SDWebImage通过图片路径来实现异步加载和缓存（本案例中加载到一个图片视图中）
   [cell.headImage sd_setImageWithURL:photoURL placeholderImage:[UIImage imageNamed:@"2"]];
   
    if (_messageSegment.selectedSegmentIndex == 0) {
       cell.dateLb.text = startTime;
       cell.nicknameLb.text = nickname;
       cell.conmentLb.text = obj[@"content"];
    } else {
       cell.dateLb.text = startTime;
       cell.nicknameLb.text = nickname;
       cell.conmentLb.text = obj[@"content"];
    }
   
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProblemDetailViewController *go = [Utilities getStoryboardInstanceByIdentity:@"Main" byIdentity:@"PDVC"];
   go.probelemVCObject =  _forShow[indexPath.row];
    [self.navigationController pushViewController:go animated:YES];
   
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
