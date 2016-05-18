//
//  selfCentreViewController.h
//  Learner
//
//  Created by admin on 16/4/18.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface selfCentreViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nicknameTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *ageTF;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UIButton *headPhotoBu;
- (IBAction)saveAction:(UIBarButtonItem *)sender;
- (IBAction)headPhoto:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)LogOutACtion:(UIButton *)sender forEvent:(UIEvent *)event;

@end
