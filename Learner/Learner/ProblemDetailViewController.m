//
//  ProblemDetailViewController.m
//  Learner
//
//  Created by 胡洪轩 on 16/4/29.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import "ProblemDetailViewController.h"
#import "ProblemDetailTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ProblemDetailViewController () {
    int count;
    BOOL flag;
    NSInteger *i;
    NSInteger *j;
}
@property (strong,nonatomic)NSMutableArray *objectsForShow;
@property (strong,nonatomic)NSMutableArray *myAdditionalCommentobjectsForShow;

@end

@implementation ProblemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    flag = YES;
    i = 0;
    j = 0;
    // Do any additional setup after loading the view.
    _tableView.tableFooterView = [[UIView alloc] init];
    _objectsForShow = [NSMutableArray new];
    count = 0;
    _myAdditionalCommentobjectsForShow = [NSMutableArray new];
    PFObject *problemObj = _probelemVCObject;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    PFUser *userObj = problemObj[@"pointerUser"];
    NSString *nickname = userObj[@"nickname"];
    NSDate *createdAt = problemObj.createdAt;
    NSString *startTime = [dateFormatter stringFromDate:createdAt];
    
    PFFile *photoFile = userObj[@"headPhoto"];
    NSString *photoURLStr=photoFile.url;
    //获取parse数据库中某个文件的网络路径
    NSURL  *photoURL=[NSURL URLWithString:photoURLStr];
    ////结合SDWebImage通过图片路径来实现异步加载和缓存（本案例中加载到一个图片视图中）
    [_headPhotoIV sd_setImageWithURL:photoURL placeholderImage:[UIImage imageNamed:@"2"]];
    _creatAtLb.text = startTime;
    _nicknameLb.text = nickname;
    _contentLb.text = problemObj[@"content"];
    [self showComment];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showComment {
    [_objectsForShow removeAllObjects];
    [_myAdditionalCommentobjectsForShow removeAllObjects];
    PFObject *problemObj = _probelemVCObject;
    PFRelation *relationComment = [problemObj relationForKey:@"relationComment"];
    PFQuery *commentQuery = [relationComment query];
    [commentQuery includeKey:@"pointerUser"];
    [commentQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable commentObjects, NSError * _Nullable error) {
        if (!error) {
            //这里查询每个问题所对应的评论
            // NSLog(@"%@",commentObjects);
            _objectsForShow = [NSMutableArray arrayWithArray:commentObjects];
            [_tableView reloadData];
            
            //可拿到某条评论对应的所有追评
            for (PFObject *myCommentObj in commentObjects) {
                PFRelation *relationAdditionalComment = myCommentObj[@"relationAdditionalComment"];
                PFQuery *query2 = [relationAdditionalComment query];
                [query2 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable myAdditionalCommentobjects, NSError * _Nullable error) {
                    if (!error) {
                        //此处为追评
                        //NSLog(@"myAdditionalCommentobjects = %@",myAdditionalCommentobjects);
                        _myAdditionalCommentobjectsForShow = [NSMutableArray arrayWithArray:myAdditionalCommentobjects];
                        [_tableView reloadData];
                    } else {
                            
                    }
                }];
            }
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return _objectsForShow.count;
    return _objectsForShow.count + _myAdditionalCommentobjectsForShow.count;
}


//tableView必需方法(行里面内容)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    ProblemDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    PFObject *commentObj = _objectsForShow[(long)i];
    PFUser *userObj = commentObj[@"pointerUser"];
    NSString *nickname = userObj[@"nickname"];
    cell.commenterNickname = nickname;

    if (flag) {
        if (_myAdditionalCommentobjectsForShow.count == 0) {
            j = 0;
            cell.flag = NO;
            cell.commentContent = commentObj[@"content"];
            i++;
        }else{
            flag = NO;
        }
        
    }else {
        PFObject *additionalCommentObj = _myAdditionalCommentobjectsForShow[(long)j];
        PFUser *userObj2 = additionalCommentObj[@"pointerUser"];
        cell.flag = YES;
        cell.byCommenterNickname = userObj2[@"nickname"];
        cell.commentContent = additionalCommentObj[@"content"];
    }
    
//    PFObject *commentObj = _objectsForShow[];
//    PFUser *userObj = commentObj[@"pointerUser"];
//    NSString *nickname = userObj[@"nickname"];
//    cell.commenterNickname = nickname;
//    if (_myAdditionalCommentobjectsForShow.count == 0) {
//        cell.flag = NO;
//        cell.commentContent = commentObj[@"content"];
//    } else {
//        //for (int j = 0; j < _myAdditionalCommentobjectsForShow.count; j++) {}
//        
//        PFObject *additionalCommentObj = _myAdditionalCommentobjectsForShow[count];
//        PFUser *userObj2 = additionalCommentObj[@"pointerUser"];
//        cell.flag = YES;
//        cell.byCommenterNickname = userObj2[@"nickname"];
//        cell.commentContent = additionalCommentObj[@"content"];
//        count ++;
//    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
