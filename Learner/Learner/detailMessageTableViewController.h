//
//  detailMessageTableViewController.h
//  Learner
//
//  Created by admin on 16/4/25.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailMessageTableViewController : UITableViewController
- (IBAction)HeaderImage:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *conment;

@end
