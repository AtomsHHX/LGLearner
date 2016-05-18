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
@property (weak, nonatomic) IBOutlet UITextField *textFd;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imageIV;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) PFObject *probelemVCObject;
- (IBAction)pushActin:(UIButton *)sender forEvent:(UIEvent *)event;

@end
