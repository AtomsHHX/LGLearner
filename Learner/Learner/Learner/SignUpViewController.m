//
//  SignUpViewController.m
//  Learner
//
//  Created by admin on 16/4/17.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)SignUpAction:(UIButton *)sender forEvent:(UIEvent *)event {
    NSString *username = _username.text;
    NSString *password = _password.text;
    NSString *email = _Vcode.text;
    NSString *confirmPwd = _conformpassword.text;
    if (username.length == 0 || email.length == 0 || password.length == 0 || confirmPwd.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请补充完整所有信息" andTitle:nil onView:self];
        //阻止后面的代码执行
        return;
    }
    if (![password isEqualToString:confirmPwd]) {
        [Utilities popUpAlertViewWithMsg:@"前后密码请保持一致" andTitle:nil onView:self];
        return;
    }
    
    
    //在parse自带的User表中新建一行
    PFUser *user = [PFUser user];
    //设置用户名和邮箱和密码
    user.username = username;
    user.password = password;
    user.email  = email;

    //让导航条失去交互能力
    self.navigationController.view.userInteractionEnabled = NO;
    
    //在跟视图上创建一朵菊花
    UIActivityIndicatorView *avi = [Utilities getCoverOnView:self.view];
    //注册完成后的回调
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        //让导航条恢复
        self.navigationController.view.userInteractionEnabled = YES;
        //菊花停转
        [avi stopAnimating];
        //判读登陆是否成功
        if (succeeded) {
            NSLog(@"注册成功");
            //先将SingUpSccessfully这个单利化全局变量中的flag删除以保证该flag的唯一性
            [[StorageMgr singletonStorageMgr] removeObjectForKey:@"SignUpSuccessfully"];
            //然后这个flag设置为yes来表示注册成功了
            [[StorageMgr singletonStorageMgr] addKey:@"SignUpSuccessfully" andValue:@YES];
            //
            [[StorageMgr singletonStorageMgr] addKey:@"Username" andValue:username];
            [[StorageMgr singletonStorageMgr] addKey:@"Password" andValue:password];
            //将文本输入框的内容清除
            _password.text = nil;
            _conformpassword.text = nil;
            _Vcode.text = nil;
            _username.text = nil;
                        //回到登陆页面
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
            switch (error.code) {
                case 202:
                    [Utilities popUpAlertViewWithMsg:@"该用户名已被使用" andTitle:nil onView:self];
                    break;
                case 203:
                    [Utilities popUpAlertViewWithMsg:@"该邮箱已被使用" andTitle:nil onView:self];
                    break;
                case 100:
                    [Utilities popUpAlertViewWithMsg:@"网路繁忙，请稍候再试" andTitle:nil onView:self];
                    break;
                case 125:
                    [Utilities popUpAlertViewWithMsg:@"该邮箱地址不存在，请从新输入" andTitle:nil onView:self];
                    break;
                    
                default:[Utilities popUpAlertViewWithMsg:@"服务器繁忙，请稍候再试" andTitle:nil onView:self];
                    break;
            }
            //NSLog(@"error == %@",error.description);
        }
    }];
}
@end
