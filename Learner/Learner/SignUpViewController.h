//
//  SignUpViewController.h
//  Learner
//
//  Created by admin on 16/4/17.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *conformpassword;
@property (weak, nonatomic) IBOutlet UITextField *Vcode;
- (IBAction)SignUpAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end
