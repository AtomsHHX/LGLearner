//
//  SignInViewController.m
//  Learner
//
//  Created by admin on 16/4/17.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import "SignInViewController.h"
#import "TabViewController.h"
@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self toHome];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)toHome{
    TabViewController *tab = [Utilities getStoryboardInstanceByIdentity:@"Main" byIdentity:@"tab"];
    [self presentViewController:tab animated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//封装登录操作（将重复对代码打包）  //相同的写好 不同的东西以参数对形式传递
-(void)signInWithUsername:(NSString *)username andPassword:(NSString *)password{
    UIActivityIndicatorView *avi = [Utilities getCoverOnView:self.view];
    //开始登录
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        //登录完成的回调
        //
        [avi stopAnimating];
        //判读登录是否成功
        if (user) {
            NSLog(@"登录成功");
            //[Utilities popUpAlertViewWithMsg:@"登录成功" andTitle:nil onView:self];
            //记忆用户名
            [Utilities setUserDefaults:@"Username" content:username];
            //            if (choce == YES) {
            //                [Utilities setUserDefaults:@"Password" content:password];
            //            }
            //将密码文本输入框中的内容清除
            //_passwordTF.text = nil;
            
            
            //跳转到首页
            [self toHome];
        }else{
            switch (error.code) {
                case 101:
                    [Utilities popUpAlertViewWithMsg:@"用户名或密码错误" andTitle:nil onView:self];
                case 100:
                    [Utilities popUpAlertViewWithMsg:@"网路繁忙，请稍候再试" andTitle:nil onView:self];
                    break;
                    
                default:
                    break;
            }
        }
    }];
    
    
}
- (IBAction)SIngInAction:(UIButton *)sender forEvent:(UIEvent *)event {
    NSString *username = _usernameTF.text;
    NSString *password = _passwordTF.text;
    if (username.length == 0 || password.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请填写所有信息" andTitle:nil onView:self];
        return;
    }
    [self signInWithUsername:username andPassword:password];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
