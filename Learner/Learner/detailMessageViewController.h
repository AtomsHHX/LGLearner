//
//  detailMessageViewController.h
//  Learner
//
//  Created by admin on 16/4/19.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailMessageViewController : UIViewController
@property(strong,nonatomic) PFObject *Pr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *head;

- (IBAction)HeadImage:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLb;
@property (weak, nonatomic) IBOutlet UILabel *dateLb;
@property (weak, nonatomic) IBOutlet UITextView *conmentTextF;
- (IBAction)zanAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UILabel *zanLable;

@end
