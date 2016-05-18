//
//  InformationDetailViewController.m
//  Learner
//
//  Created by lfc on 16/5/13.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import "InformationDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface InformationDetailViewController ()

@end

@implementation InformationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _contentTV.editable = NO;
    PFObject *obj = _informationObj;
    PFFile *photoFile = obj[@"photo"];
    NSString *URLStr = photoFile.url;
    NSURL *photoURL = [NSURL URLWithString:URLStr];
    [_photoIV sd_setImageWithURL:photoURL placeholderImage:[UIImage imageNamed:@"2"]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *createdAt = obj.createdAt;
    NSString *startTime = [dateFormatter stringFromDate:createdAt];
    _titileLb.text = obj[@"title"];
    _createdAtLb.text = startTime;
    _contentTV.text = obj[@"content"];

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

@end
