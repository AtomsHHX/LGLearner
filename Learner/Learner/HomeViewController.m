//
//  HomeViewController.m
//  Learner
//
//  Created by VIP on 16/4/17.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import "HomeViewController.h"
#import "DCPicScrollView.h"
#import "DCWebImageManager.h"

@interface HomeViewController ()

@end
static CGFloat h = 120;
@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _headView.backgroundColor = [UIColor blueColor];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = [UIView new];
    
    //[self demo1];
}

-(void)demo1 {
    
    NSMutableArray *arr2 = [[NSMutableArray alloc] init];
    
    NSMutableArray *arr3 = [[NSMutableArray alloc] init];
    
    for (int i = 1; i < 8; i++) {
        [arr2 addObject:[NSString stringWithFormat:@"%d.jpg",i]];
        [arr3 addObject:[NSString stringWithFormat:@"我是第%d张图片啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊",i]];
    };
    
    
    /*
     靠下坐标
     DCPicScrollView  *picView1 = [DCPicScrollView picScrollViewWithFrame:CGRectMake(0,self.view.frame.size.height - h*2,self.view.frame.size.width, h) WithImageUrls:arr2];
     */
    //置顶坐标
    
    DCPicScrollView  *picView1 = [DCPicScrollView picScrollViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, h * 2) WithImageUrls:arr2];
    
    picView1.titleData = arr3;
    
    picView1.backgroundColor = [UIColor clearColor];
    [picView1 setImageViewDidTapAtIndex:^(NSInteger index) {
        printf("你点到我了😳index:%zd\n",index);
    }];
    
    picView1.AutoScrollDelay = 2.0f;
    
    [self.view addSubview:picView1];
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
