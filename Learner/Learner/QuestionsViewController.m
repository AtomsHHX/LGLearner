//
//  QuestionsViewController.m
//  Learner
//
//  Created by WalleLi on 16/4/19.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import "QuestionsViewController.h"
#import "DOPDropDownMenu.h"
#import "QuestionsDetailViewController.h"
#import "ItemTypeViewController.h"
@interface QuestionsViewController () <DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>
@property (nonatomic, copy) NSArray *subjectArr;
@property (nonatomic, copy) NSArray *yearArr;
@property (nonatomic, copy) NSArray *regionArr;
@property (nonatomic, strong) DOPDropDownMenu *menu;
@property (strong,nonatomic) NSNumber *year;
@property (strong,nonatomic) NSString *region;
@property (strong,nonatomic) NSNumber *subject;

@end

@implementation QuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _objectForShow = [NSMutableArray new];
    //菜单筛选
    _subjectArr = @[@"语文",@"数学(文)",@"数学(理)",@"英语",@"物理",@"化学",@"生物",@"历史",@"政治",@"地理"];
    _yearArr = @[@"年份",@"2013",@"2014",@"2015"];
    _regionArr = @[@"地区",@"江西省",@"江苏省"];
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:40];
    menu.dataSource = self;
    menu.delegate = self;
    menu.backgroundColor = [UIColor colorWithRed:88/255.f green:214/255.f blue:255/255.f alpha:1.f];
    _tableView.tableHeaderView = menu;
    self.menu = menu;
    self.navigationItem.title = @"题库";

    // 创建menu 第一次显示 不会调用点击代理，可以用这个手动调用
    [menu selectDefalutIndexPath];
    
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData:(NSNumber *)subject year:(NSNumber *)year region:(NSString *)region {
    UIActivityIndicatorView *AIV = [Utilities getCoverOnView:self.view];
    self.navigationController.view.userInteractionEnabled = NO;
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Test"];
    [query1 whereKey:@"subject" equalTo:subject];
    if (year != nil) {
        [query1 whereKey:@"year" equalTo:year];
    }
    if (region != nil) {
        [query1 whereKey:@"region" equalTo:region];
    }
    [query1 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [AIV stopAnimating];
        self.navigationController.view.userInteractionEnabled = YES;

        if (!error) {
            _objectForShow = [NSMutableArray arrayWithArray:objects];
            [_tableView reloadData];
            
        } else {
            NSLog(@"%@",error.description);
        }
    }];
}

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 3;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    if (column == 0) {
        return _subjectArr.count;
    }else if (column == 1){
        return _yearArr.count;
    }else {
        return _regionArr.count;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        return _subjectArr[indexPath.row];
    } else if (indexPath.column == 1){
        return _yearArr[indexPath.row];
    } else {
        return _regionArr[indexPath.row];
    }
}


- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        _subject = [NSNumber numberWithInteger:(indexPath.row +1)];
    }else if (indexPath.column == 1) {
        if ([_yearArr[indexPath.row] isEqualToString:@"年份"]) {
            _year = nil;
        } else {
            _year = [NSNumber numberWithInteger:[_yearArr[indexPath.row] integerValue]];
        }
        
    } else {
        if ([_regionArr[indexPath.row] isEqualToString:@"地区"]) {
            _region = nil;
        } else {
            _region = _regionArr[indexPath.row];
            
        }
    }
    [self requestData:_subject year:_year region:_region];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objectForShow.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    PFObject *obj = _objectForShow[indexPath.row];
    NSString *year = obj[@"year"];
    NSString *region = obj[@"region"];
    NSInteger subInt = [obj[@"subject"] integerValue];
    NSString *subjectStr = [NSString stringWithFormat:@"%@",_subjectArr[subInt - 1]];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@全国高考%@试题-%@卷",year,subjectStr,region];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
      //[self item:indexPath.row];
    ItemTypeViewController *ITVC = [Utilities getStoryboardInstanceByIdentity:@"Main" byIdentity:@"ITVC"];
    ITVC.testObj = _objectForShow[indexPath.row];
    [self.navigationController pushViewController:ITVC animated:YES];

   
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
