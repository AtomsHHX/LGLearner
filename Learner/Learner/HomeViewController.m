//
//  HomeViewController.m
//  Learner
//
//  Created by VIP on 16/4/17.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import "HomeViewController.h"


@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _headView.backgroundColor = [UIColor blueColor];
    // Do any additional setup after loading the view.
   
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    return cell;
}

-(void)MJBannnerPlayer:(UIView *)bannerPlayer didSelectedIndex:(NSInteger)index{
    
    NSLog(@"%ld",index);
    
}

@end
