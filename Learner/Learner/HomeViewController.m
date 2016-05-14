//
//  HomeViewController.m
//  Learner
//
//  Created by VIP on 16/4/17.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import "HomeViewController.h"
#import "SDCycleScrollView.h"
#import "HomeTableViewCell.h"
#import "InformationDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface HomeViewController ()<SDCycleScrollViewDelegate>
@property (strong,nonatomic) NSMutableArray *showArray;

@end
@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = [UIView new];
    _showArray = [NSMutableArray new];
    // 情景一：采用本地图片实现
    NSArray *imageNames = @[@"lunbo1.jpg",
                            @"lunbo2.jpg",
                            @"lunbo3.jpg",
                            @"lunbo4.jpg",
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
    [self showInformation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showInformation {
    [_showArray removeAllObjects];
    PFQuery *query = [PFQuery queryWithClassName:@"Information"];
    [query orderByDescending:@"createdAt"];
    UIActivityIndicatorView *AIV = [Utilities getCoverOnView:self.view];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [AIV stopAnimating];
        if (!error) {
            _showArray = [NSMutableArray arrayWithArray:objects];
            [_tableView reloadData];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    PFObject *obj = _showArray[indexPath.row];
    PFFile *photoFile = obj[@"photo"];
    NSString *URLStr = photoFile.url;
    NSURL *photoURL = [NSURL URLWithString:URLStr];
    [cell.photoIV sd_setImageWithURL:photoURL placeholderImage:[UIImage imageNamed:@"2"]];
    cell.contentLb.text = obj[@"content"];


    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    InformationDetailViewController *informationDetail = [Utilities getStoryboardInstanceByIdentity:@"Main" byIdentity:@"informationDetail"];
    informationDetail.informationObj = _showArray[indexPath.row];
    [self.navigationController pushViewController:informationDetail animated:YES];
}

//-(void)MJBannnerPlayer:(UIView *)bannerPlayer didSelectedIndex:(NSInteger)index{
//
//}

@end
