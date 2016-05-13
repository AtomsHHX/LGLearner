//
//  AskViewController.m
//  Learner
//
//  Created by 胡洪轩 on 16/4/23.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import "AskViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface AskViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate> {
    BOOL flag;
}
@property (strong, nonatomic) UIImagePickerController *imagePC;

@end

@implementation AskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    flag =NO;
    _imageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleRecognizer;
    singleRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sing)];
    singleRecognizer.numberOfTapsRequired=1;
    [_imageView addGestureRecognizer:singleRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/

- (void)saveProblem{
    
    PFUser *currentUser = [PFUser currentUser];
    //NSString *title = _titleTF.text;
    NSString *content = _textView.text;
    //UIImage *img = [[UIImage alloc] init];
    PFObject *problemObject = [PFObject objectWithClassName:@"Problem"];
    //problemObject[@"title"] = title;
    problemObject[@"content"] = content;
    problemObject[@"pointerUser"] = currentUser;
    //此处可做判断，如果有图片则添加，没有就不添加
    if (flag) {
        UIImage *image1 = _imageView.image;
        NSData  *photoData = UIImagePNGRepresentation(image1);
        PFFile  *photoFile=[PFFile fileWithName:@"phot.png" data:photoData];
        problemObject[@"contentImage"] = photoFile;
    }
    self.navigationController.view.userInteractionEnabled = NO;
    UIActivityIndicatorView *aiv =[Utilities getCoverOnView:self.view];
    [problemObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
            PFRelation *relationProblem = [currentUser relationForKey:@"relationProblem"];
            [relationProblem addObject:problemObject];
            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                self.navigationController.view.userInteractionEnabled = YES;
                [aiv stopAnimating];
                if (!error) {
                    // NSLog(@"成功");
                    //[Utilities popUpAlertViewWithMsg:@"发表成功" andTitle:nil onView:self];
                    flag = NO;
                    _textView.text = @"";
                    _imageView.image = [UIImage imageNamed:@"add"];
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"Success" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                } else {
                    NSLog(@"保存失败%@",error.userInfo);
                    [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
                }
            }];
        } else {
            NSLog(@"保存失败%@",error.userInfo);
            [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
        }
    }];

    
}

-(void)sing{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhoto=[UIAlertAction actionWithTitle:@"拍照📷" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self picKImage:UIImagePickerControllerSourceTypeCamera];
        
    }];
    
    UIAlertAction *coosephoto=[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self picKImage:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    UIAlertAction *cancephoto=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [actionSheet addAction:takePhoto];
    [actionSheet addAction:coosephoto];
    [actionSheet addAction:cancephoto];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

//选择相片的
-(void)picKImage:(UIImagePickerControllerSourceType)sourceType{
   // NSLog(@"有相片");
    //判断当前的选择图片类型是否可用
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        //_imagePC将内容为空
        _imagePC = nil;
        //初始化一个图片控制器对象
        _imagePC=[[UIImagePickerController alloc]init];
        //签协议
        _imagePC.delegate = self;
        //设置图片选择器的类型
        _imagePC.sourceType = sourceType;
        //设置选择的媒体文件是否被编辑
        _imagePC.allowsEditing = YES;
        //设置可以被选择的媒体文件的类型
        _imagePC.mediaTypes=@[(NSString *)kUTTypeImage];
        [self presentViewController:_imagePC animated:YES completion:nil];
    }else{
        UIAlertController *alertview=[UIAlertController alertControllerWithTitle:@"提示" message:sourceType==UIImagePickerControllerSourceTypeCamera?@"你当前的设备没有照相功能":@"当前设备无法有相册"  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction=[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
        [alertview addAction:confirmAction];
        [self presentViewController:alertview animated:YES completion:nil];
        }
}

//当选择完媒体文件后被调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    flag = YES;
    //根据UIImagePickerControllerEditedImage这个健去拿到我们选择的图片
    UIImage *image1 = info[UIImagePickerControllerEditedImage];
    //用mode的方式返回上一页
    [self dismissViewControllerAnimated:YES completion:nil];
    _imageView.image = image1;
}

//点击空白处收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


//让text view控件实现：当键盘右下角按钮被按下后，收起键盘
//当文本输入视图中文字内容发生变化时调用（返回YES表示同意这个变化发生；返回NO表示不同意）
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //捕捉到键盘右下角按钮被按下这一事件（键盘右下角按钮被按钮实际上在文本输入视图中执行的是换行：\n）
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        _plocaderLb.hidden = NO;
    } else {
        _plocaderLb.hidden = YES;
    }
}

- (IBAction)saveAction:(UIBarButtonItem *)sender {
    if (_textView.text.length == 0 && !flag) {
        [Utilities popUpAlertViewWithMsg:@"请输入文字或者上传图片发表您的问题" andTitle:nil onView:self];
    } else {
        [self saveProblem];
    }
}
- (IBAction)downAction:(UITapGestureRecognizer *)sender {
    
}
@end
