//
//  AskViewController.h
//  Learner
//
//  Created by 胡洪轩 on 16/4/23.
//  Copyright © 2016年 LikeGod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AskViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)saveAction:(UIBarButtonItem *)sender;
- (IBAction)pickAction:(UITapGestureRecognizer *)sender;
@property (strong, nonatomic) PFObject *problem;
@end
