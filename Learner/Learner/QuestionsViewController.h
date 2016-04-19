//
//  QuestionsViewController.h
//  Learner
//
//  Created by WalleLi on 16/4/19.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *objectForShow;
//@property (strong, nonatomic) NSMutableArray *itemObjectForShow;
//@property (strong, nonatomic) NSMutableArray *optionObjectForShow;
//@property (strong, nonatomic) NSMutableArray *answerObjectForShow;


@end
