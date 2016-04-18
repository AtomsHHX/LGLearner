//
//  selfCentreViewController.h
//  Learner
//
//  Created by admin on 16/4/18.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface selfCentreViewController : UIViewController
- (IBAction)headPhoto:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTF;
@property (weak, nonatomic) IBOutlet UILabel *emailLbl;
@property (weak, nonatomic) IBOutlet UITextField *ageTF;
- (IBAction)genderSeg:(UISegmentedControl *)sender forEvent:(UIEvent *)event;
- (IBAction)LogOutACtion:(UIButton *)sender forEvent:(UIEvent *)event;

@end
