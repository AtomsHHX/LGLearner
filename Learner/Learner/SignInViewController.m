//
//  SignInViewController.m
//  Learner
//
//  Created by admin on 16/4/17.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import "SignInViewController.h"
#import "TabViewController.h"
#import "leftViewController.h"
#import <ECSlidingViewController/ECSlidingViewController.h>
//#import "KSGuideManager.h"
#import "ABCIntroView.h"

@interface SignInViewController ()<ECSlidingViewControllerDelegate,ECSlidingViewControllerLayout,UITextFieldDelegate>
@property (strong, nonatomic) ECSlidingViewController *slidingVC;
@property (assign, nonatomic) ECSlidingViewControllerOperation operation;
@property ABCIntroView *introView;
@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //KSGuide的实现方法
    // Do any additional setup after loading the view.
    //[self toHome];
//    NSMutableArray *paths = [NSMutableArray new];
//    
//    [paths addObject:[[NSBundle mainBundle] pathForResource:@"001" ofType:@"jpg"]];
//    [paths addObject:[[NSBundle mainBundle] pathForResource:@"002" ofType:@"jpg"]];
//    [paths addObject:[[NSBundle mainBundle] pathForResource:@"003" ofType:@"jpg"]];
//    [paths addObject:[[NSBundle mainBundle] pathForResource:@"004" ofType:@"jpg"]];
//    
//    [[KSGuideManager shared] showGuideViewWithImages:paths];
//    
//    [[StorageMgr singletonStorageMgr] addKey:@"SignUpSuccessfully" andValue:@NO];
    
    //引导页实现
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"intro_screen_viewed"]) {
        self.introView = [[ABCIntroView alloc] initWithFrame:self.view.frame];
        self.introView.delegate = self;
        self.introView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.introView];
    }

}
-(void)onDoneButtonPressed{
    
    //    Uncomment so that the IntroView does not show after the user clicks "DONE"
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    [defaults setObject:@"YES"forKey:@"intro_screen_viewed"];
    //    [defaults synchronize];
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.introView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.introView removeFromSuperview];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //判断是否记忆了用户名
    if (![[Utilities getUserDefaults:@"Username"] isKindOfClass:[NSNull class]]) {
        //如果有记忆，就显示在用户名文本输入框中
        _usernameTF.text = [Utilities getUserDefaults:@"Username"];
    }
}
//每一次这个页面出现的时候都会调用这个方法，并且时机点是页面已经出现以后
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //判断是否是从注册页面注册成功后回到的这个登录页面
    if ([[[StorageMgr singletonStorageMgr] objectForKey:@"SignUpSuccessfully"] boolValue]) {
        //在自动登录前将SignUpSuccessfully这个在单例化全局变量中的flag恢复为NO
        [[StorageMgr singletonStorageMgr] removeObjectForKey:@"SignUpSuccessfully"];
        [[StorageMgr singletonStorageMgr] addKey:@"SignUpSuccessfully" andValue:@NO];
        
        //从单例化全局变量中提取用户名和密码
        NSString *username = [[StorageMgr singletonStorageMgr] objectForKey:@"Username"];
        NSString *password = [[StorageMgr singletonStorageMgr] objectForKey:@"Password"];
        //清除用完的用户名和密码
        [[StorageMgr singletonStorageMgr] removeObjectForKey:@"Username"];
        [[StorageMgr singletonStorageMgr] removeObjectForKey:@"Password"];
        //执行自动登录
        [self signInWithUsername:username andPassword:password];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)toHome{
    TabViewController *tab = [Utilities getStoryboardInstanceByIdentity:@"Main" byIdentity:@"tab"];
    _slidingVC.delegate = self;
    
    _slidingVC = [ECSlidingViewController slidingWithTopViewController:tab];
    _slidingVC.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
    //[tab.view addGestureRecognizer:_slidingVC.panGesture];
    leftViewController *leftVC = [Utilities getStoryboardInstanceByIdentity:@"Main" byIdentity:@"left"];
    _slidingVC.underLeftViewController = leftVC;
    //设置侧滑的范围（长度）anchorRightPeekAmount：表示中间的宽度 anchorRightRevealAmount:表示   (设置左侧页面当呗显示时，宽度能够显示1/4)
    _slidingVC.anchorRightPeekAmount = UI_SCREEN_W * 2 / 5;
    
    //创建一个当菜单按钮呗按时，要执行的侧滑方法的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuOutAction) name:@"MenuSwich" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableGestureAction) name:@"EnableGesture" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableGestureAction) name:@"DisableGesture" object:nil];
    
    //modal方式跳转到上述页面 跳转到哪里 动画效果 跳转之后要执行的内容
    [self presentViewController:_slidingVC animated:YES completion:nil];
}
-(void)menuOutAction{
    NSLog(@"out");
    if (_slidingVC.currentTopViewPosition == ECSlidingViewControllerTopViewPositionAnchoredRight) {
        
        [_slidingVC resetTopViewAnimated:YES];
    } else {
        
        [_slidingVC anchorTopViewToRightAnimated:YES];
    }
}
- (void)enableGestureAction{
    _slidingVC.panGesture.enabled = YES;
}
- (void)disableGestureAction{
    _slidingVC.panGesture.enabled = NO;
    
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
        //self.navigationController.view.userInteractionEnabled = NO;
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
            _passwordTF.text = nil;
            
            //[self createRelation];
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

- (IBAction)forgetAction:(UIButton *)sender forEvent:(UIEvent *)event {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入您注册时的邮箱号码" preferredStyle:UIAlertControllerStyleAlert];
    //创建“确认”按钮，风格为UIAlertActionStyleDefault
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *textField = alertView.textFields.firstObject;
        //[self setPriceForCard:textField.text];
        NSString *email = textField.text;
        UIActivityIndicatorView *avi = [Utilities getCoverOnView:self.view];
         [PFUser requestPasswordResetForEmailInBackground:email block:^(BOOL succeeded, NSError * _Nullable error) {
             [avi stopAnimating];
             if (succeeded) {
                 [Utilities popUpAlertViewWithMsg:@"密码重置邮件已发送到您的邮箱" andTitle:nil onView:self];
             }else{
                 switch (error.code) {
                     case 125:
                         [Utilities popUpAlertViewWithMsg:@"邮箱格式错误，请重新输入！" andTitle:nil onView:self];
                         break;
                     case 205:
                         [Utilities popUpAlertViewWithMsg:@"您输入的邮箱与注册时的不匹配，请重新输入！" andTitle:nil onView:self];
                         break;
                     default:
                         [Utilities popUpAlertViewWithMsg:@"网络请求失败，请稍后重试" andTitle:nil onView:self];
                         break;
                 }
             }
         }];
    }];
    //创建“取消”按钮，风格为UIAlertActionStyleCancel
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //将以上两个按钮添加进弹出窗（按钮添加的顺序决定按钮的排版：从左到右；从上到下。如果是取消风格UIAlertActionStyleCancel的按钮会放在最左边）
    [alertView addAction:confirmAction];
    [alertView addAction:cancelAction];
    
    //添加一个文本输入框
    [alertView addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        
    }];

    [self presentViewController:alertView animated:YES completion:nil];
   
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
