//
//  ProblemDetailTableViewCell.m
//  Learner
//
//  Created by 胡洪轩 on 16/4/29.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import "ProblemDetailTableViewCell.h"

@implementation ProblemDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    //显示评论者的昵称
    _commenterNicknameBu = [[UIButton alloc] init];
    CGFloat width = [Utilities getTextWidth:_commenterNickname textFont:_commenterNicknameBu.titleLabel.font toViewRange:10];
    [_commenterNicknameBu setFrame:CGRectMake(10, 10, width, 20)];
    [_commenterNicknameBu setTitle:_commenterNickname forState:UIControlStateNormal];
    [_commenterNicknameBu setTitleColor:[UIColor blueColor] forState:0];

    [self addSubview:_commenterNicknameBu];

    if (_flag) {
        //显示”回复“字样
        _replyLb = [[UILabel alloc] initWithFrame:CGRectMake(_commenterNicknameBu.frame.origin.x + _commenterNicknameBu.frame.size.width + 5, 10, 40, 20)];
        _replyLb.text = @"回复";
        //显示被评论者的昵称
        _byCommenterNicknameBu = [[UIButton alloc] initWithFrame:CGRectMake(_replyLb.frame.origin.x + _replyLb.frame.size.width + 5, 10, 40, 20)];
        CGFloat byCommenterWidth = [Utilities getTextWidth:_byCommenterNickname textFont:_byCommenterNicknameBu.titleLabel.font toViewRange:10];
        [_byCommenterNicknameBu setFrame:CGRectMake(_replyLb.frame.origin.x + _replyLb.frame.size.width + 5, 10, byCommenterWidth, 20)];
        [_byCommenterNicknameBu setTitle:_byCommenterNickname forState:UIControlStateNormal];
        [_byCommenterNicknameBu setTitleColor:[UIColor blueColor] forState:0];
        
        //显示“:”字样
        _symbolLb = [[UILabel alloc] initWithFrame:CGRectMake(_byCommenterNicknameBu.frame.origin.x + _byCommenterNicknameBu.frame.size.width + 5, 10, 4, 20)];
        _symbolLb.text = @":";
        
        [self addSubview:_replyLb];
        [self addSubview:_byCommenterNicknameBu];
        [self addSubview:_symbolLb];
        
    } else {
        //显示“:”字样
        _symbolLb = [[UILabel alloc] initWithFrame:CGRectMake(_commenterNicknameBu.frame.origin.x + _commenterNicknameBu.frame.size.width + 5, 10, 4, 20)];
        _symbolLb.text = @":";
        //显示评论的内容
//        _commentContentLb = [[UILabel alloc] initWithFrame:CGRectMake(_symbolLb.frame.origin.x + _symbolLb.frame.size.width + 5, 10, 40, 20)];
//        _commentContentLb.text = @"lalalademaxiya zou ni ";
        [self addSubview:_symbolLb];
        //[self addSubview:_commentContentLb];
    }
    
    //显示评论的内容
    _commentContentLb = [[UILabel alloc] init];
   // NSString *content = @"lalalademaxiya zou nrrrrrrrrrrrrrrpppppppppppppppri ";
    CGFloat contentHeight = [Utilities getTextHeight:_commentContent textFont:_commentContentLb.font toViewRange:_symbolLb.frame.origin.x - 10];
    [_commentContentLb setFrame:CGRectMake(_symbolLb.frame.origin.x + _symbolLb.frame.size.width + 5, 10, UI_SCREEN_W - _symbolLb.frame.origin.x - 10, contentHeight)];
    _commentContentLb.numberOfLines = 0;
    _commentContentLb.text = _commentContent;
    [self addSubview:_commentContentLb];
    
}

@end
