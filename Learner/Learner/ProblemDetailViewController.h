//
//  ProblemDetailViewController.h
//  Learner
//
//  Created by 胡洪轩 on 16/4/29.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProblemDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *headphotoIV;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentsLab;
@property (weak, nonatomic) IBOutlet UIImageView *contentsIV;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
