//
//  ItemTypeViewController.h
//  Learner
//
//  Created by lfc on 16/4/24.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemTypeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *objectForShow;
@property (strong, nonatomic) PFObject *testObj;
@end
