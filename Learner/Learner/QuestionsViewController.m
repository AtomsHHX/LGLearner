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
    _tableView.tableHeaderView = menu;
    self.menu = menu;

    // 创建menu 第一次显示 不会调用点击代理，可以用这个手动调用
    [menu selectDefalutIndexPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData:(NSNumber *)subject year:(NSNumber *)year region:(NSString *)region {
    [_objectForShow removeAllObjects];
    //NSLog(@" %@ %@ %@",subject,year,region);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %@ ",subject];
    PFQuery *query = [PFQuery queryWithClassName:@"Subject" predicate:predicate];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            for (PFObject *object in objects) {
                PFRelation *relation = [object relationForKey:@"relationTest"];
                PFQuery *subQuery = [relation query];
                if (year != nil) {
                    [subQuery whereKey:@"year" equalTo:year];
                }
                if (region != nil) {

                    [subQuery whereKey:@"region" equalTo:region];
                }
                [subQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable subObjects, NSError * _Nullable error) {
                    if (!error) {
                        _objectForShow = [NSMutableArray arrayWithArray:subObjects];
                        NSLog(@"");
                        [_tableView reloadData];
                        
                    } else {
                        NSLog(@"%@",error.description);
                    }
                }];
            }
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
    NSInteger subInt = [_subject integerValue] - 1;
    NSString *subjectStr = _subjectArr[subInt];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@全国高考%@试题-%@卷",year,subjectStr,region];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QuestionsDetailViewController *QDView = [Utilities getStoryboardInstanceByIdentity:@"Main" byIdentity:@"QuestionsDetail"];
    
    [self.navigationController pushViewController:QDView animated:YES];
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