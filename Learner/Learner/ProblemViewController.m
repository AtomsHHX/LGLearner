//
//  ProblemViewController.m
//  Learner
//
//  Created by 胡洪轩 on 16/4/23.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import "ProblemViewController.h"
#import "ProblemTableViewCell.h"
#import "ProblemDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ProblemViewController ()
@property (strong,nonatomic) PFObject *problem;
@property (strong,nonatomic)NSMutableArray *objectsForShow;
@end

@implementation ProblemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _objectsForShow = [NSMutableArray new];
   _problemTV.tableFooterView = [[UIView alloc]init];
     [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(selectProblem) name:@"Success" object:nil];
    [self selectProblem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//查询问题表Problem
- (void)selectProblem {
    
    [_objectsForShow removeAllObjects];
    PFQuery *problemQuery = [PFQuery queryWithClassName:@"Problem"];
    [problemQuery includeKey:@"pointerUser"];
    [problemQuery orderByDescending:@"createdAt"];
    UIActivityIndicatorView *AIV = [Utilities getCoverOnView:self.view];
    [problemQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable problemObjects, NSError * _Nullable error) {
        [AIV stopAnimating];
        if (!error) {
            _objectsForShow = [NSMutableArray arrayWithArray:problemObjects];
            //NSLog(@"%@",_objectsForShow);
            [_problemTV reloadData];
            //查询到所有问题
            //NSLog(@"%lu",problemObjects.count);
//            for (PFObject * problemObj in problemObjects) {
//                PFRelation *relationComment = [problemObj relationForKey:@"relationComment"];
//                PFQuery *commentQuery = [relationComment query];
//                [commentQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable commentObjects, NSError * _Nullable error) {
//                    if (!error) {
//                        //这里查询每个问题所对应的评论
//                       // NSLog(@"%@",commentObjects);
//                        //可拿到某条评论对应的所有追评
//                        for (PFObject *myCommentObj in commentObjects) {
//                            PFRelation *relationAdditionalComment = myCommentObj[@"relationAdditionalComment"];
//                            PFQuery *query2 = [relationAdditionalComment query];
//                            [query2 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable myAdditionalCommentobjects, NSError * _Nullable error) {
//                                if (!error) {
//                                    //此处为追评
//                                    //NSLog(@"myAdditionalCommentobjects = %@",myAdditionalCommentobjects);
//                                } else {
//                                    
//                                }
//                            }];
//                        }
//                        
//                    } else {
//                        NSLog(@"error = %@",error.userInfo);
//                    }
//                }];
//            }
        } else {
            NSLog(@"error = %@",error.userInfo);
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

//tableView必需方法（多少行）
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return _objectsForShow.count;
    return _objectsForShow.count;
}


//tableView必需方法(行里面内容)
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    ProblemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    PFObject *obj = _objectsForShow[indexPath.row];
    PFUser *userObj = obj[@"pointerUser"];
    NSString *nickname = userObj[@"nickname"];
    NSDate *createdAt = obj.createdAt;
    NSString *startTime = [dateFormatter stringFromDate:createdAt];
    
    PFFile *photoFile = userObj[@"headPhoto"];
    NSString *photoURLStr=photoFile.url;
    //获取parse数据库中某个文件的网络路径
    NSURL  *photoURL=[NSURL URLWithString:photoURLStr];
    ////结合SDWebImage通过图片路径来实现异步加载和缓存（本案例中加载到一个图片视图中）
    [cell.headPhotoIV sd_setImageWithURL:photoURL placeholderImage:[UIImage imageNamed:@"2"]];
    cell.timeLab.text = startTime;
    if (nickname == nil) {
        cell.nicknameLab.text = userObj.username;
    }else{
        cell.nicknameLab.text = nickname;
    }
    cell.titleLab.text = obj[@"content"];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProblemDetailViewController *PDVC = [Utilities getStoryboardInstanceByIdentity:@"Main" byIdentity:@"PDVC"];
    PDVC.probelemVCObject = _objectsForShow[indexPath.row];
    
    [self.navigationController pushViewController:PDVC animated:YES];
}

////ableView:heightForRowAtIndexPath: 中调用这个方法，填入需要的参数计算cell 高度。
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject * obj = [_objectsForShow objectAtIndex:indexPath.row];
    NSString *str = obj[@"content"];
   ProblemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    CGFloat contentLabelHeight = [Utilities getTextHeight:str textFont:cell.titleLab.font toViewRange:30];
    
    return cell.titleLab.frame.origin.y + contentLabelHeight + 5;
}

@end
