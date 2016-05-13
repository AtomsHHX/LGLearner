//
//  HomeViewController.m
//  Learner
//
//  Created by VIP on 16/4/17.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import "HomeViewController.h"
#import "SDCycleScrollView.h"

@interface HomeViewController ()<SDCycleScrollViewDelegate>

@end
@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = [UIView new];
    
    // 情景一：采用本地图片实现
    NSArray *imageNames = @[@"1.jpg",
                            @"2.jpg",
                            @"3.jpg",
                            @"4.jpg",
                            ];
   // CGFloat w = self.view.bounds.size.width;
    // 本地加载 --- 创建不带标题的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UI_SCREEN_W, 180) shouldInfiniteLoop:YES imageNamesGroup:imageNames];
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    [_scrollView addSubview:cycleScrollView];
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //         --- 轮播时间间隔，默认1.0秒，可自定义
    //cycleScrollView.autoScrollTimeInterval = 4.0;

    UIRefreshControl *rc = [UIRefreshControl new];
    rc.tag = 1001;
    rc.attributedTitle = [[NSAttributedString alloc] initWithString:@"⬇️下拉刷新"];
   // [rc addTarget:self action:@selector(refresh) forControlEvents:UIControlEventEditingChanged];
    
}
- (void)refresh{
    NSLog(@"下拉了");
   
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
    cell.textLabel.text = @"";
    NSArray * cellArr = [[NSArray alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:@"GameScore"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)MJBannnerPlayer:(UIView *)bannerPlayer didSelectedIndex:(NSInteger)index{
    
    NSLog(@"%ld",index);
    
}

@end
