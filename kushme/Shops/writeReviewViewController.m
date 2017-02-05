//
//  writeReviewViewController.m
//  kushme
//
//  Created by Paras Gorasiya on 16/05/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "writeReviewViewController.h"

@interface writeReviewViewController ()

@end

@implementation writeReviewViewController {
    
    float ratingValue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ratingValue = 0.0f;
    
    self.txtViewReview.text = @"Write A Review";
    self.txtViewReview.textColor = [UIColor lightGrayColor];
    
    self.rateView.notSelectedImage = [UIImage imageNamed:@"icon_rate_star_empty"];
    self.rateView.halfSelectedImage = [UIImage imageNamed:@"icon_rate_star_full"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"icon_rate_star_full"];
    self.rateView.rating = 0;
    self.rateView.editable = YES;
    self.rateView.maxRating = 5;
    self.rateView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


#pragma mark TextView Delegates
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    self.txtViewReview.text = @"";
    self.txtViewReview.textColor = [UIColor blackColor];
    return YES;
}

- (void) textViewDidChange:(UITextView *)textView {
    if (self.txtViewReview.text.length == 0) {
        self.txtViewReview.textColor = [UIColor lightGrayColor];
        self.txtViewReview.text = @"Write A Review";
        [self.txtViewReview resignFirstResponder];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark RateView Delegate

- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
    ratingValue = rating;
}

- (IBAction)closeReview:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)saveReview:(id)sender {
    
    NSString* reviewString = self.txtViewReview.text;
    if ([reviewString isEqualToString:@"Write A Review"]) {
        NSString *message = @"Please enter some of your thoughts for review.";
        [[AlertManager sharedManager] showErrorAlert:message onVC:self];
    }
    else {
        [SVProgressHUD show];
        
        [[APIManager sharedManager] insertRatings:ratingValue shop:self.shopId success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
#if DEBUG
            NSLog(@"Insert Ratings : %@", responseObject);
#endif
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[UtilManager validateResponse:[responseObject objectForKey:key_success]] boolValue]) {
                    [self insertReview:reviewString];
                    return;
                }
            }
            [SVProgressHUD dismiss];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            [[AlertManager sharedManager] showErrorAlert:@"Failed to save rate" onVC:self];
        }];
    }
}

- (void)insertReview:(NSString*)reviewString {
    
    [SVProgressHUD show];
    
    [[APIManager sharedManager] insertReviews:reviewString shop:self.shopId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
#if DEBUG
        NSLog(@"Insert Review : %@", responseObject);
#endif
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[UtilManager validateResponse:[responseObject objectForKey:key_message]] isEqualToString:key_Done] &&
                [[UtilManager validateResponse:[responseObject objectForKey:key_success]] boolValue]) {
                
                [SVProgressHUD showInfoWithStatus:@"Success to save your review"];
                
                [self performSegueWithIdentifier:Segue_UnwindToShopDetail sender:nil];
                
                return;
            }
        }
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [[AlertManager sharedManager] showErrorAlert:@"Failed to save review" onVC:self];
    }];
}


@end
