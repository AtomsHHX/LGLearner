//
//  MessageTableViewCell.h
//  Learner
//
//  Created by admin on 16/4/29.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nicknameLb;
@property (weak, nonatomic) IBOutlet UILabel *dateLb;
@property (weak, nonatomic) IBOutlet UILabel *conmentLb;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
//@property (weak, nonatomic) IBOutlet UITextView *neirongTview;

@end
