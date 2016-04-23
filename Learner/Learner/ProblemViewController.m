//
//  ProblemViewController.m
//  Learner
//
//  Created by 胡洪轩 on 16/4/23.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import "ProblemViewController.h"
#import "ProblemTableViewCell.h"
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
    [problemQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable problemObjects, NSError * _Nullable error) {
        if (!error) {
            _objectsForShow = [NSMutableArray arrayWithArray:problemObjects];
            [_problemTV reloadData];
            //查询到所有问题
            NSLog(@"%lu",problemObjects.count);
            for (PFObject * problemObj in problemObjects) {
                PFRelation *relationComment = [problemObj relationForKey:@"relationComment"];
                PFQuery *commentQuery = [relationComment query];
                [commentQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable commentObjects, NSError * _Nullable error) {
                    if (!error) {
                        //这里查询每个问题所对应的评论
                        NSLog(@"%@",commentObjects);
                        //可拿到某条评论对应的所有追评
                        for (PFObject *myCommentObj in commentObjects) {
                            PFRelation *relationAdditionalComment = myCommentObj[@"relationAdditionalComment"];
                            PFQuery *query2 = [relationAdditionalComment query];
                            [query2 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable myAdditionalCommentobjects, NSError * _Nullable error) {
                                if (!error) {
                                    //此处为追评
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
    PFObject *obj = _objectsForShow[indexPath.row];
    NSString *name =obj[@"nickname"];
    NSString *title = obj[@"title"];
    
    cell.nicknameLab.text = name;
    cell.titleLab.text= title;
    
//    UIImage *headPhoto = obj[@"headPhoto"];
//    NSData *photoData = UIImagePNGRepresentation(headPhoto);
//    PFFile *photoFile = [PFFile fileWithName:@"headPhoto.png" data:photoData];
//    _problem[@"headPhoto"] = photoFile;
//    cell.headPhotoIV.image = _problem;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (IBAction)intoAction:(UIBarButtonItem *)sender {
}
@end
