//
//  selfCentreViewController.m
//  Learner
//
//  Created by admin on 16/4/18.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import "selfCentreViewController.h"
#import <SDWebImage/UIButton+WebCache.h>
@interface selfCentreViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    BOOL flag;
}
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;

@property (strong, nonatomic) UIImagePickerController *imagePicker;

@end

@implementation selfCentreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _emailTF.enabled = false;
    flag = NO;
    [_imageBtn addTarget:self action:@selector(headPhoto:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self uiConfigration];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
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
    NSString *nickname = currentUser[@"nickname"];
    NSNumber *age =  currentUser [@"age"];
    NSString *ageStr = [NSString stringWithFormat:@"%@",age];
    PFFile *photoFile = currentUser[@"headPhoto"];
    NSString *photoURLStr = photoFile.url;
    //获取parse数据库中某个文件的网络路径
    NSURL  *photoURL = [NSURL URLWithString:photoURLStr];
    ////结合SDWebImage通过图片路径来实现异步加载和缓存（本案例中加载到一个图片视图中）
    [_headPhotoBu sd_setBackgroundImageWithURL:photoURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"lunbo1"]];
    if (nickname == nil) {
        _nicknameTF.text = currentUser.username;
        
    }else{
        _nicknameTF.text = currentUser[@"nickname"];
       
    }
     _emailTF.text = currentUser.email;
    
    if (age == nil) {
        _ageTF.placeholder = @"请输入年龄";
        
    }else{
        _ageTF.text = ageStr;
    }
    
    if ([currentUser[@"gender"]  isEqual: @NO]) {
        _segment.selectedSegmentIndex = 0;
    } else {
        _segment.selectedSegmentIndex = 1;
    }
   
   
}

- (IBAction)saveAction:(UIBarButtonItem *)sender {
    NSString *age = _ageTF.text;
    NSInteger ageInt = [age integerValue];
    NSNumber *ageSave = @(ageInt);
    PFUser *currentUser = [PFUser currentUser];
    if (flag) {
            UIImage *image1 = _headPhotoBu.imageView.image;
            NSData  *photoData = UIImagePNGRepresentation(image1);
            PFFile  *photoFile=[PFFile fileWithName:@"photo.png" data:photoData];
            currentUser[@"headPhoto"] = photoFile;
    }
    if (![_nicknameTF.text isEqualToString:currentUser.username]) {
        currentUser[@"nickname"] = _nicknameTF.text;
    }
    if (_ageTF.text != nil) {
        currentUser[@"age"] = ageSave;
    }
    if (_segment.selectedSegmentIndex == 0) {
        currentUser[@"gender"] = @NO;
    } else {
         currentUser[@"gender"] = @YES;
    }
    self.navigationController.view.userInteractionEnabled = NO;
    self.tabBarController.view.userInteractionEnabled = NO;
    UIActivityIndicatorView *AIV = [Utilities getCoverOnView:self.view];
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        self.navigationController.view.userInteractionEnabled = YES;
        self.tabBarController.view.userInteractionEnabled = YES;
        [AIV stopAnimating];
        if (succeeded) {
            flag = NO;
            [Utilities popUpAlertViewWithMsg:@"保存成功" andTitle:nil onView:self];
        } else {
            [Utilities popUpAlertViewWithMsg:@"网络繁忙，请重新尝试" andTitle:nil onView:self];
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
    flag = YES;
    //设置前景图和背景图
    //[_imageButton setBackgroundImage:image forState:UIControlStateNormal];
    [_imageBtn setImage:image forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)pickImage:(UIImagePickerControllerSourceType)sourceType{
   // NSLog(@"拿到了");
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
    //NSLog(@"选到图片了");
    
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
    UIActivityIndicatorView *AIV = [Utilities getCoverOnView:self.view];
    self.navigationController.view.userInteractionEnabled = NO;
    self.tabBarController.view.userInteractionEnabled = NO;
    //退出登录
    [PFUser logOut];
    //
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        self.navigationController.view.userInteractionEnabled = YES;
        self.tabBarController.view.userInteractionEnabled = YES;
        [AIV stopAnimating];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
