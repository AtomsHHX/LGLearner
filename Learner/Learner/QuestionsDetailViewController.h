//
//  QuestionsDetailViewController.h
//  Learner
//
//  Created by lfc on 16/4/19.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionsDetailViewController : UIViewController
//@property (strong, nonatomic) NSArray *itemObjects;
//@property (strong, nonatomic) NSArray *optionObjects;
@property (strong, nonatomic) NSArray *itemObjectForShow;
@property (strong, nonatomic) NSMutableArray *optionObjectForShow;
@property (strong, nonatomic) PFObject *testObj;
@property (strong, nonatomic) PFObject *itemTypeObj;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *problemLb;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *upBarBI;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *downBarBI;

- (IBAction)upAction:(UIBarButtonItem *)sender;
- (IBAction)downAction:(UIBarButtonItem *)sender;


//- (IBAction)upAction:(UIButton *)sender forEvent:(UIEvent *)event;
//- (IBAction)downAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end
