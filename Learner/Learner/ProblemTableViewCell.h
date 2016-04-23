//
//  ProblemTableViewCell.h
//  Learner
//
//  Created by 胡洪轩 on 16/4/23.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProblemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headPhotoIV;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *tpyeLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;


@end
