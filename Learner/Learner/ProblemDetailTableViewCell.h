//
//  ProblemDetailTableViewCell.h
//  Learner
//
//  Created by 胡洪轩 on 16/4/29.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProblemDetailTableViewCell : UITableViewCell
@property (strong,nonatomic) UIButton *commenterNicknameBu;
@property (strong,nonatomic) NSString *commenterNickname;
@property (strong,nonatomic) UIButton *byCommenterNicknameBu;
@property (strong,nonatomic) NSString *byCommenterNickname;
@property (strong,nonatomic) UILabel *symbolLb;
@property (strong,nonatomic) UILabel *replyLb;
@property (strong,nonatomic) UILabel *commentContentLb;
@property (strong,nonatomic) NSString *commentContent;
@property (nonatomic) BOOL flag;


@end
