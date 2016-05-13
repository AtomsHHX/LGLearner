//
//  InformationDetailViewController.h
//  Learner
//
//  Created by lfc on 16/5/13.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *photoIV;
@property (weak, nonatomic) IBOutlet UILabel *titileLb;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLb;
@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (strong, nonatomic) PFObject *informationObj;

@end
