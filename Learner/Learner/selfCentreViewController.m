//
//  selfCentreViewController.m
//  Learner
//
//  Created by admin on 16/4/18.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import "selfCentreViewController.h"

@interface selfCentreViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) NSString *Name;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;

@property (strong, nonatomic) UIImagePickerController *imagePicker;
@end

@implementation selfCentreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self uiConfigration];
    _nicknameTF.delegate = self;
    [NSNotificationCenter defaultCenter];
    [_segment addTarget:self action:@selector(choice:) forControlEvents:UIControlEventValueChanged];
    [_imageBtn addTarget:self action:@selector(headPhoto:forEvent:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    //[self didUpdateFocusInContext:UIControlEventValueChanged withAnimationCoordinator:nil];
    
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
-(void)choice:(UISegmentedControl *)segmentControl{
    NSInteger segmentIndex = segmentControl.selectedSegmentIndex;
    //NSNumber *genderNum = [NSNumber numberWithInteger:segmentIndex];
    if (segmentIndex == 0) {
        [self saveGender:@NO];
    } else {
        [self saveGender:@YES];
    }
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

- (void)saveGender:(NSNumber *)genderNum {
    PFUser *currentUser = [PFUser currentUser];
    currentUser[@"gender"] = genderNum;
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    //设置前景图和背景图
    //[_imageButton setBackgroundImage:image forState:UIControlStateNormal];
    [_imageBtn setImage:image forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)pickImage:(UIImagePickerControllerSourceType)sourceType{
    NSLog(@"拿到了");
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        _imagePicker = nil;
        _imagePicker = [UIImagePickerController new];
        _imagePicker.delegate =self;
        _imagePicker.sourceType = sourceType;
        _imagePicker.allowsEditing = YES;
        //_imagePicker.mediaTypes = @[(NSString *)kUnknownType];
        [self presentViewController:_imagePicker animated:YES completion:nil];
        
    }else{
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:sourceType == UIImagePickerControllerSourceTypeCamera ? @"当前设备没有照相功能" : @"当前设备无法打开相册 " preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
        [alertView addAction:confirmAction];
        [self presentViewController:alertView animated:YES completion:nil];
    }
    
}
- (IBAction)headPhoto:(UIButton *)sender forEvent:(UIEvent *)event {
    NSLog(@"选到图片了");
    
    UIAlertController *actionsheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takephoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pickImage:UIImagePickerControllerSourceTypeCamera];
    }];
    
    UIAlertAction *choosePhoto = [UIAlertAction actionWithTitle:@"选择图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pickImage:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [actionsheet addAction:takephoto];
    [actionsheet addAction:choosePhoto];
    [actionsheet addAction:cancelAction];
    [self presentViewController:actionsheet animated:YES completion:nil];
    
    
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
