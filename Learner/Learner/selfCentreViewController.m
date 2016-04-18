//
//  selfCentreViewController.m
//  Learner
//
//  Created by admin on 16/4/18.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import "selfCentreViewController.h"

@interface selfCentreViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) NSString *Name;
@end

@implementation selfCentreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self uiConfigration];
    _nicknameTF.delegate = self;
    [NSNotificationCenter defaultCenter];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)uiConfigration{
    
    PFUser *currentUser = [PFUser currentUser];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"myname = %@",currentUser.username];
//    PFQuery *query = [PFQuery queryWithClassName:@"username" predicate:predicate];
//    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//        
//    }];
    NSLog(@"邮箱和用户名：%@ & %@",currentUser.email,currentUser.username);
    NSString *nickname = currentUser[@"nickname"];
    NSLog(@"%@",nickname);
    if (nickname == nil) {
        _nicknameTF.text = currentUser.username;
    }else{
        _nicknameTF.text = currentUser[@"nickname"];
    }
    
//    _Name =_nicknameTF.text;
//    _Name = currentUser.username;
    _emailLbl.text = currentUser.email;
   
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *nickname = _nicknameTF.text;
    NSLog(@"nickname = %@",nickname);
    [self saveNickname:nickname];
    
    
}

- (void)saveNickname:(NSString *)nickname {
    PFUser *currentUser = [PFUser currentUser];
    currentUser[@"nickname"] = nickname;
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"chenggong");
        } else {
            NSLog(@"error = %@",error.userInfo);
        }
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)headPhoto:(UIButton *)sender forEvent:(UIEvent *)event {
    
    
}
- (IBAction)genderSeg:(UISegmentedControl *)sender forEvent:(UIEvent *)event {
    
}

- (IBAction)LogOutACtion:(UIButton *)sender forEvent:(UIEvent *)event {
    //退出登录
    [PFUser logOut];
    //
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        //判读退出是否成功
        if (!error) {
            //返回登录页面
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            [Utilities popUpAlertViewWithMsg:@"连接失败，退出出错" andTitle:nil onView:self];
        }
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
