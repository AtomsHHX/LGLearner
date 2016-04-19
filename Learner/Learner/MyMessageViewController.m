//
//  MyMessageViewController.m
//  Learner
//
//  Created by admin on 16/4/19.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import "MyMessageViewController.h"
#import "detailMessageViewController.h"
@interface MyMessageViewController ()
@property (strong , nonatomic) NSMutableArray *objectsForShow;
@end

@implementation MyMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView.tableFooterView = [UIView new];
    _objectsForShow = [NSMutableArray new];
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
//    PFObject *obj = _objectsForShow[indexPath.row];
//    NSString *name = obj[@"name"];
//    cell.textLabel.text = name;
    
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
