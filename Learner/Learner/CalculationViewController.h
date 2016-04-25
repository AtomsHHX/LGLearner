//
//  CalculationViewController.h
//  Learner
//
//  Created by lfc on 16/4/25.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculationViewController : UIViewController
@property (strong, nonatomic) PFObject *itemTypeObj;
@property (strong, nonatomic) PFObject *testObj;
@property (strong, nonatomic) NSArray *itemObjectForShow;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@end
