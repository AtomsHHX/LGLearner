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
@property (weak, nonatomic) IBOutlet UILabel *userNameLb;
@property (weak, nonatomic) IBOutlet UIButton *userImage;
@property (strong , nonatomic) NSMutableArray *rowObj;
@property (strong , nonatomic) PFObject *proObj;
@end
