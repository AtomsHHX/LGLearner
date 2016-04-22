//
//  QuestionsDetailViewController.h
//  Learner
//
//  Created by lfc on 16/4/19.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionsDetailViewController : UIViewController
@property (strong, nonatomic) NSArray *itemObjects;
//@property (strong, nonatomic) NSArray *optionObjects;
//@property (strong, nonatomic) NSArray *answerObjects;
@property (weak, nonatomic) IBOutlet UILabel *problemLb;
@property (weak, nonatomic) IBOutlet UILabel *optionALb;
@property (weak, nonatomic) IBOutlet UILabel *optionBLb;
@property (weak, nonatomic) IBOutlet UILabel *optionCLb;
@property (weak, nonatomic) IBOutlet UILabel *optionDLb;
- (IBAction)upAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)downAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end
