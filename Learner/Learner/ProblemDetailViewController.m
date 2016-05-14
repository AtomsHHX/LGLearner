//
//  ProblemDetailViewController.m
//  Learner
//
//  Created by 胡洪轩 on 16/4/29.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import "ProblemDetailViewController.h"
#import "ProblemDetailTableViewCell.h"
#import "UIView+SDAutoLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ProblemDetailViewController () {
    int count;
    BOOL flag;
    int i;
    int j;
    UIImage *image;
}
@property (strong,nonatomic)NSMutableArray *objectsForShow;
@property (strong,nonatomic)NSMutableArray *myAdditionalCommentobjectsForShow;

@end

@implementation ProblemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    flag = NO;
//    count = 0;
//    i = 0;
//    j = 0;
    // Do any additional setup after loading the view.
    _tableView.tableFooterView = [[UIView alloc] init];
    _objectsForShow = [NSMutableArray new];
    _myAdditionalCommentobjectsForShow = [NSMutableArray new];
    //[[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(showComment) name:@"Success2" object:nil];
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
    if (nickname == nil) {
        _nicknameLb.text = userObj.username;
    }else{
        _nicknameLb.text = nickname;
    }
    _contentLb.text = problemObj[@"content"];
    if (problemObj[@"contentImage"] != nil) {
        PFFile *problemImageFile = problemObj[@"contentImage"];
        [problemImageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (!error) {
                image = [UIImage imageWithData:data];
                _imageHeight.constant = (UI_SCREEN_W - 30) / image.size.width * image.size.height;
                _imageIV.image = image;
                _headerView.height = _imageIV.origin.y + _imageHeight.constant;
            } else {
                _headerView.height = CGRectGetMaxY(_contentLb.frame) + 11;
            }
            _tableView.tableHeaderView = _headerView;
        }];
    } else {
        _imageIV.image = nil;
        _headerView.height = CGRectGetMaxY(_contentLb.frame) + 11;
        _tableView.tableHeaderView = _headerView;
    }

    [self showComment];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showComment {
    //NSLog(@"Ωou");
    [_objectsForShow removeAllObjects];
   // [_myAdditionalCommentobjectsForShow removeAllObjects];
    PFObject *problemObj = _probelemVCObject;
    PFRelation *relationComment = [problemObj relationForKey:@"relationComment"];
    PFQuery *commentQuery = [relationComment query];
    [commentQuery includeKey:@"pointerUser"];
    UIActivityIndicatorView *AIV = [Utilities getCoverOnView:self.view];
    [commentQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable commentObjects, NSError * _Nullable error) {
        [AIV stopAnimating];
        if (!error) {
            //这里查询每个问题所对应的评论
            // NSLog(@"%@",commentObjects);
            _objectsForShow = [NSMutableArray arrayWithArray:commentObjects];
            [_tableView reloadData];
            
            //可拿到某条评论对应的所有追评
//            for (PFObject *myCommentObj in commentObjects) {
//                PFRelation *relationAdditionalComment = [myCommentObj relationForKey:@"relationAdditionalComment"];
//                PFQuery *query2 = [relationAdditionalComment query];
//                [query2 includeKey:@"pointerUser"];
//                [query2 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable myAdditionalCommentobjects, NSError * _Nullable error) {
//                    if (!error) {
//                        NSLog(@"我在呢");
//                        count = (int)myAdditionalCommentobjects.count + count;
//                        //此处为追评
//                        //NSLog(@"myAdditionalCommentobjects = %lu",myAdditionalCommentobjects.count);
//                        //_myAdditionalCommentobjectsForShow = [NSMutableArray arrayWithArray:myAdditionalCommentobjects];
//                        //[_tableView reloadData];
//                    } else {
//                            NSLog(@"error = %@",error.userInfo);
//                    }
//                }];
//            }
           // [_tableView reloadData];
        } else {
                NSLog(@"error = %@",error.userInfo);
        }
    }];
}

//发表评论
- (void)publishComment {
    NSString *content = _textFd.text;
    //UIImage *img = [[UIImage alloc] init];
    PFUser *currentUser = [PFUser currentUser];
    PFObject *commentObject = [PFObject objectWithClassName:@"Comment"];
    commentObject[@"content"] = content;
    commentObject[@"pointerUser"] = currentUser;
    //commentObject[@"contentImage"] = img;
    self.navigationController.view.userInteractionEnabled = NO;
    UIActivityIndicatorView *AIV = [Utilities getCoverOnView:self.view];
    [commentObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        _textFd.text = nil;
        self.navigationController.view.userInteractionEnabled = YES;
        [AIV stopAnimating];
        if (!error) {
            //发表的评论要跟当前登录的用户关联
            PFRelation *relationComment = [currentUser relationForKey:@"relationComment"];
            [relationComment addObject:commentObject];
            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (!error) {
                    NSLog(@"1成功");
                } else {
                   [Utilities popUpAlertViewWithMsg:@"请保持网络畅通" andTitle:nil onView:self];                }
            }];
            
            //进到某个问题里面会获得该问题在数据库表里对应的哪一条数据
           // PFObject *proObj;
            PFObject * problemObject = _probelemVCObject;
            PFRelation *proRelationCom = [problemObject relationForKey:@"relationComment"];
            [proRelationCom addObject:commentObject];
            [problemObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (!error) {
                    NSLog(@"2成功");
                    [self showComment];
                } else {
                    [Utilities popUpAlertViewWithMsg:@"请保持网络畅通" andTitle:nil onView:self];
                }
            }];
            
            
        } else {
            [Utilities popUpAlertViewWithMsg:@"请保持网络畅通" andTitle:nil onView:self];
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
    return _objectsForShow.count;
}


//tableView必需方法(行里面内容)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    ProblemDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    PFObject *commentObj = _objectsForShow[indexPath.row];
    PFUser *userObj = commentObj[@"pointerUser"];
    NSString *nickname = userObj[@"nickname"];
    cell.commenterNickname = nickname;
    cell.flag = NO;
    cell.commentContent = commentObj[@"content"];
//        if (_myAdditionalCommentobjectsForShow.count == 0) {
//            i ++;
//            cell.flag = NO;
//           cell.commentContent = commentObj[@"content"];

//        }else if (flag){
//            PFObject *additionalCommentObj = _myAdditionalCommentobjectsForShow[j];
//            PFUser *userObj2 = additionalCommentObj[@"pointerUser"];
//            cell.flag = YES;
//            cell.byCommenterNickname = userObj2[@"nickname"];
//            cell.commentContent = additionalCommentObj[@"content"];
//            j ++;
//            if (j >= _myAdditionalCommentobjectsForShow.count) {
//                flag = NO;
//                i ++;
//            }
//        } else {
//            j = 0;
//            i ++;
//            flag = YES;
//            cell.flag = NO;
//            cell.commentContent = commentObj[@"content"];
//        }
//    NSLog(@"%@",cell.commentContent);
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

- (IBAction)pushActin:(UIButton *)sender forEvent:(UIEvent *)event {
    if (_textFd.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"亲，要输入文字才能吐槽哦！" andTitle:nil onView:self];
    } else {
        [self publishComment];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    CGFloat offest = self.view.frame.size.height - (textField.frame.origin.y + textField.frame.size.height + 216 + 60);
    if (offest <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offest;
            self.view.frame = frame;
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];
    return YES;

}

//当键盘右下角的确认按钮被按时收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//点击空白处收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
