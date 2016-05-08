//
//  ProblemDetailViewController.h
//  Learner
//
//  Created by 胡洪轩 on 16/4/29.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProblemDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headPhotoIV;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UILabel *creatAtLb;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) PFObject *probelemVCObject;

@end
