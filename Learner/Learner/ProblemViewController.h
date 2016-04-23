//
//  ProblemViewController.h
//  Learner
//
//  Created by 胡洪轩 on 16/4/23.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProblemViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *problemTV;
- (IBAction)intoAction:(UIBarButtonItem *)sender;

@end
