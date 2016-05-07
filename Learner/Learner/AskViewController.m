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
@interface AskViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) UIImagePickerController *imagePC;
@property (strong,nonatomic)NSMutableArray *objectsForShow;
@end

@implementation AskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)pickImage:(UIImagePickerControllerSourceType)sourceType {
    NSLog(@"照片被按了");
    
    //    PFFile *photoFile = _problem[@"contentImage"];
    //    //获取Parse数据库中某个文件的网络路径
    //    NSString *photoURLStr = photoFile.url;
    //    NSURL *photoURL = [NSURL URLWithString:photoURLStr];
    //        //利用SD中与图片视图结合中的类中间的方法实现：从指定网址URL中获取图片（如果曾经获取过则直接去本地缓存中提取，获取成功后缓存在本地，并将该图片显示在指定的图片视图上（当图片没有本地缓存并且还在下载中时用指定的默认图临时显示在上述的指定视图上））
    //        [_imageView sd_setImageWithURL:photoURL placeholderImage:[UIImage imageNamed:@"default"]];
    //判断当前选择的图片选择器控制器类型是否可用
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        //神奇的nil
        _imagePC = nil;
        //初始化一个图片选择器控制器对象
        _imagePC = [[UIImagePickerController alloc] init];
        //签协议
        _imagePC.delegate = self;
        //设置图片选择器控制器类型
        _imagePC.sourceType = sourceType;
        //设置选中的媒体文件是否可以被编辑
        _imagePC.allowsEditing = YES;
        //设置可以被选择的媒体文件的类型
        _imagePC.mediaTypes = @[(NSString *)kUTTypeImage];
        [self presentViewController:_imagePC animated:YES completion:nil];
    } else {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:sourceType == UIImagePickerControllerSourceTypeCamera ? @"您当前的设备没有照相功能" : @"您当前的设备无法打开相册" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertView addAction:confirmAction];
        [self presentViewController:alertView animated:YES completion:nil];
    }
}

//当选择完媒体文件后调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //根据UIImagePickerControllerEditedImage这个键去拿到我们选中的已经编辑过的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    //将上面拿到的图片设置为图片视图的图片
    _imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveAction:(UIBarButtonItem *)sender {
    UIImage *image = _imageView.image;
    NSString *content = _textView.text;
    
    if (image == nil && content.length == 0 ) {
        //        [Utilities popUpAlertViewWithMsg:@"请选择一张图片" andTitle:nil onView:self];
        //        return;
        [Utilities popUpAlertViewWithMsg:@"请填写信息" andTitle:nil onView:self];
        return;
    }
    
    PFObject *card = [PFObject objectWithClassName:@"Problem"];
    card[@"content"] = content;
    //    card[@"title"] = @0;
    //    card[@"price"] = @0;
    //    card[@"range"] = @0;
    
    //将一个UIImage对象转换成PNG格式的数据流
    NSData *photoData = UIImagePNGRepresentation(image);
    //将上述数据流转换成Parse的PFFile对象（PFFile对象是一个文件对象，这里除了要设置文件内容这个数据流以外，还需要给文件起个文件名，这个文件名可以是任何名字）
    PFFile *photoFile = [PFFile fileWithName:@"photo.png" data:photoData];
    card[@"photo"] = photoFile;
    
    //    PFUser *currentUser = [PFUser currentUser];
    //    card[@"owner"] = currentUser;
    
    self.navigationController.view.userInteractionEnabled = NO;
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [card saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.navigationController.view.userInteractionEnabled = YES;
        [aiv stopAnimating];
        if (succeeded) {
            //创建刷新“广场”页面的通知
            NSNotification *note = [NSNotification notificationWithName:@"Problem" object:nil];
            //结合线程触发上述通知（让通知要完成的事先执行完以后再执行触发通知这一行代码后面的代码）
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:note waitUntilDone:YES];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [Utilities popUpAlertViewWithMsg:@"当前用户有点多哦，请稍候再试" andTitle:nil onView:self];
        }
    }];
    

}

- (IBAction)pickAction:(UITapGestureRecognizer *)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self pickImage:UIImagePickerControllerSourceTypeCamera];
    }];
    UIAlertAction *choosePhoto = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self pickImage:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [actionSheet addAction:takePhoto];
    [actionSheet addAction:choosePhoto];
    [actionSheet addAction:cancelAction];
    [self presentViewController:actionSheet animated:YES completion:nil];
    

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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
