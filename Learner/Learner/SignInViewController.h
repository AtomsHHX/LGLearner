//
//  SignInViewController.h
//  Learner
//
//  Created by admin on 16/4/17.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
- (IBAction)SIngInAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end
