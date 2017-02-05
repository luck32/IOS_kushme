//
//  writeReviewViewController.h
//  kushme
//
//  Created by Paras Gorasiya on 16/05/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"

@interface writeReviewViewController : UIViewController<RateViewDelegate>

@property (weak, nonatomic) IBOutlet RateView *rateView;
@property (weak, nonatomic) IBOutlet UITextView *txtViewReview;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveReview;

@property (strong, nonatomic) NSString* shopId;

- (IBAction)closeReview:(id)sender;
- (IBAction)saveReview:(id)sender;

@end
