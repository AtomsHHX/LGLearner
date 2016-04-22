//
//  leftViewController.m
//  Learner
//
//  Created by admin on 16/4/18.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import "leftViewController.h"
#import "AppDelegate.h"
@interface leftViewController ()
@property (strong ,nonatomic) NSMutableArray *objectForShow;

@property(nonatomic,strong)UIView *darkView;
@end

@implementation leftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _objectForShow = [NSMutableArray new];
    [self.objectForShow addObjectsFromArray: @[@"夜间模式"]];
    
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
- (void)changeValue:(UISwitch *)swi
{
    if (swi.on) {
        //添加半透明view到window上
        UIApplication * app = [UIApplication sharedApplication];
        AppDelegate *delegate = (AppDelegate *) app.delegate;
        _darkView = [[UIView alloc]initWithFrame:self.view.frame];
        //设置view的背景色
        _darkView.backgroundColor = [UIColor blackColor];
        _darkView.alpha = 0.3;
        //关闭view的用户交互(响应者链)
        _darkView.userInteractionEnabled = NO;
        [delegate.window addSubview:_darkView];
        
    }
    else
    {
        [_darkView removeFromSuperview];
    }
    
}
- (IBAction)clearAction:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)helpAction:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)aboutAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
