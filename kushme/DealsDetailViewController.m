//
//  DealsDetailViewController.m
//  kushme
//
//  Created by Yanny on 5/31/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "DealsDetailViewController.h"

@interface DealsDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel* dealNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView* dealLogoView;
@property (weak, nonatomic) IBOutlet UIImageView* dealNewView;
@property (weak, nonatomic) IBOutlet UIImageView* shopLogoView;
@property (weak, nonatomic) IBOutlet UILabel* shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* dealValueLabel;
@property (weak, nonatomic) IBOutlet UILabel* shopAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton* saveDealButton;
@property (weak, nonatomic) IBOutlet UIButton* getDirectionButton;

- (IBAction)tapSaveDealButton:(id)sender;
- (IBAction)tapGetDirectionButton:(id)sender;

@end

@implementation DealsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"DEAL DETAILS";
    if (self.isSavedDeal)
        self.title = @"SAVED DEAL";
    
    [self refreshDealInfo];
    [self performSelectorOnMainThread:@selector(loadDealInfo) withObject:nil waitUntilDone:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)refreshDealInfo {
    
    if (self.dealInfo) {
        // set logos
        
        NSString* logoUrl = [self.dealInfo objectForKey:key_deal_pic];
        if (logoUrl) {
            logoUrl = logoUrl.stringByRemovingPercentEncoding;
            [self.dealLogoView setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:nil];
        }
        logoUrl = [self.dealInfo objectForKey:key_shop_pic];
        if (logoUrl) {
            logoUrl = logoUrl.stringByRemovingPercentEncoding;
            [self.shopLogoView setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:nil];
        }
        
        self.dealNameLabel.text = [UtilManager validateResponse:[self.dealInfo objectForKey:key_deal_name]];
        self.shopNameLabel.text = [UtilManager validateResponse:[self.dealInfo objectForKey:key_shop_name]];
        self.dealValueLabel.text = [UtilManager validateResponse:[self.dealInfo objectForKey:key_deal_value]];
        self.shopAddressLabel.text = [UtilManager validateResponse:[self.dealInfo objectForKey:key_shop_address]];
        
        self.saveDealButton.hidden = self.isSavedDeal;
        self.getDirectionButton.hidden = !self.isSavedDeal;
    }
}

- (void)loadDealInfo {
    
    if (!self.dealInfo)
        return;
    
    if (self.isSavedDeal) {
        
        NSString* userDealId = [UtilManager validateResponse:[self.dealInfo objectForKey:key_user_deal_id]];
        if (userDealId && userDealId.length > 0) {
            
            [SVProgressHUD show];
            [[APIManager sharedManager] getSavedDealDetailsWithDealId:userDealId success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
#if DEBUG
                NSLog(@"Saved Deal Details : %@", responseObject);
#endif
                
                if (responseObject) {
                    if ([responseObject isKindOfClass:[NSDictionary class]])
                        [self.dealInfo setValuesForKeysWithDictionary:responseObject];
                    else if ([responseObject isKindOfClass:[NSArray class]])
                        [self.dealInfo setValuesForKeysWithDictionary:[responseObject firstObject]];
                }
                [self refreshDealInfo];
                [self performSelectorOnMainThread:@selector(showShopPicture) withObject:nil waitUntilDone:NO];
                
                [SVProgressHUD dismiss];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
#if DEBUG
                NSLog(@"Saved Deal Details Error : %@", [error localizedDescription]);
#endif
                [SVProgressHUD dismiss];
            }];
        }
    }
    else {
        
        NSString* shopId = [UtilManager validateResponse:[self.dealInfo objectForKey:key_shop_id]];
        if (shopId && shopId.length > 0) {
            
            [SVProgressHUD show];
            [[APIManager sharedManager] getDealDetailsOfShopId:shopId success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
#if DEBUG
                NSLog(@"Deal Details : %@", responseObject);
#endif
                
                if (responseObject) {
                    if ([responseObject isKindOfClass:[NSDictionary class]])
                        [self.dealInfo setValuesForKeysWithDictionary:responseObject];
                    else if ([responseObject isKindOfClass:[NSArray class]])
                        [self.dealInfo setValuesForKeysWithDictionary:[responseObject firstObject]];
                }
                [self refreshDealInfo];
                [self performSelectorOnMainThread:@selector(showShopPicture) withObject:nil waitUntilDone:NO];
                
                [SVProgressHUD dismiss];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
#if DEBUG
                NSLog(@"Deal Details Error : %@", [error localizedDescription]);
#endif
                [SVProgressHUD dismiss];
            }];
        }
    }
}

- (void)showShopPicture
{
    NSString* shopId = [self.dealInfo objectForKey:key_shop_id];
    if (!shopId || shopId.length < 1)
        return;
    
    [[APIManager sharedManager] showShopPicture:shopId picCount:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
#if DEBUG
        NSLog(@"showShopPicture : %@", responseObject);
#endif
        NSString* logoUrl = [[responseObject firstObject] objectForKey:key_shop_pic];
        if (logoUrl){
            logoUrl = logoUrl.stringByRemovingPercentEncoding;
            [self.shopLogoView setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
#if DEBUG
        NSLog(@"showShopPicture : Error : %@", error.localizedDescription);
#endif
    }];
}

- (IBAction)tapSaveDealButton:(id)sender {
    
    NSString* shopId = [UtilManager validateResponse:[self.dealInfo objectForKey:key_shop_id]];
    if (shopId && shopId.length > 0) {
        
        [SVProgressHUD show];
        [[APIManager sharedManager] getNewDealWith:shopId success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
#if DEBUG
            NSLog(@"Shop Deal Details : %@", responseObject);
#endif
            
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[UtilManager validateResponse:[responseObject objectForKey:key_msg]] boolValue]) {
                    [[AlertManager sharedManager] showErrorAlert:@"This Deal has been saved" onVC:self];
                }
            }
            
            [SVProgressHUD dismiss];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
#if DEBUG
            NSLog(@"Shop Deal Details Error : %@", [error localizedDescription]);
#endif
            [SVProgressHUD dismiss];
        }];
    }
}

- (IBAction)tapGetDirectionButton:(id)sender {
    
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        // Create an MKMapItem to pass to the Maps app
        CLLocationCoordinate2D coordinate =
        CLLocationCoordinate2DMake([[self.dealInfo valueForKey:key_shop_lat] doubleValue], [[self.dealInfo valueForKey:key_shop_long] doubleValue]);
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:[self.dealInfo valueForKey:key_shop_name]];
        // Pass the map item to the Maps app
        [mapItem openInMapsWithLaunchOptions:nil];
    }
}

@end
