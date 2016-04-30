//
//  detailMessageViewController.m
//  Learner
//
//  Created by admin on 16/4/19.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import "detailMessageViewController.h"
#import <SDWebImage/UIButton+WebCache.h>
@interface detailMessageViewController ()<UITextViewDelegate>

@property (strong, nonatomic) NSMutableArray *OBJ;

@end

@implementation detailMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _OBJ = [NSMutableArray new];
    
    PFObject *object = _Pr;
    PFRelation *relationComment = object[@"relationComment"];
    PFQuery *query2 = [relationComment query];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable myCommentobjects, NSError * _Nullable error) {
       
        if (!error) {
            _OBJ =  [NSMutableArray arrayWithArray:myCommentobjects];
            [_tableView reloadData];
        } else {
            NSLog(@"%@",error.userInfo);
        }
    }];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    PFUser *userObj = object[@"pointerUser"];
    NSString *nickname = userObj[@"nickname"];
    
    NSDate *createdAt = object.createdAt;
    NSString *startTime = [dateFormatter stringFromDate:createdAt];
    
    PFFile *photoFile = userObj[@"headPhoto"];
    NSString *photoURLStr=photoFile.url;
    //获取parse数据库中某个文件的网络路径
    NSURL  *photoURL=[NSURL URLWithString:photoURLStr];
    ////结合SDWebImage通过图片路径来实现异步加载和缓存（本案例中加载到一个图片视图中）
    [_head sd_setBackgroundImageWithURL:photoURL forState:UIControlStateNormal completed:nil];
    _nicknameLb.text = nickname;
    _dateLb.text = startTime;
    _conmentTextF.text = object[@"content"];
    _conmentTextF.editable = NO;
    
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _OBJ.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    PFObject *obj = _OBJ[indexPath.row];
    cell.textLabel.text = obj[@"content"];
 
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    PFUser *userObj = obj[@"pointerUser"];
//    NSString *nickname = userObj[@"nickname"];
//    NSDate *createdAt = obj.createdAt;
//    NSString *startTime = [dateFormatter stringFromDate:createdAt];
//    
//    PFFile *photoFile = userObj[@"headPhoto"];
//    NSString *photoURLStr=photoFile.url;
//    //获取parse数据库中某个文件的网络路径
//    NSURL  *photoURL=[NSURL URLWithString:photoURLStr];
    ////结合SDWebImage通过图片路径来实现异步加载和缓存（本案例中加载到一个图片视图中）
//    [cell.headImage sd_setImageWithURL:photoURL placeholderImage:[UIImage imageNamed:@"2"]];
//    ;
//    if (_messageSegment.selectedSegmentIndex == 0) {
//        cell.dateLb.text = startTime;
//        cell.nicknameLb.text = nickname;
//        cell.neirongTview.text = obj[@"title"];
//        //        cell.textLabel.text = obj[@"title"];
//    } else {
//        cell.dateLb.text = startTime;
//        cell.nicknameLb.text = nickname;
//        cell.neirongTview.text = obj[@"content"];
//    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
//    detailMessageTableViewController *go = [Utilities getStoryboardInstanceByIdentity:@"Main" byIdentity:@"detail"];
//    go.proObj =  _forShow[indexPath.row];
//    [self.navigationController pushViewController:go animated:YES];
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    // [self.tableview setEditing:YES];
}
- (IBAction)HeadImage:(UIButton *)sender forEvent:(UIEvent *)event {
}
- (IBAction)zanAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
