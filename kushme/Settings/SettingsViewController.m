//
//  SettingsViewController.m
//  kushme
//
//  Created by Yanny on 5/16/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (UIEdgeInsets)layoutMargins {
    
    return UIEdgeInsetsZero;
//    return UIEdgeInsetsMake(0.f, 15.f, 0.f, 15.f);
}

@end


@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UIView* settingsSplashWrapper;
@property (weak, nonatomic) IBOutlet UITableView* settingsTableView;

@property (strong, nonatomic) UISwitch* privacySwitch;

@property (nonatomic) BOOL isShopOwner;

- (IBAction)tapSignuotButton:(id)sender;
- (IBAction)changePrivacySettings:(id)sender;

- (IBAction)unwindToSettingsAfterLogin:(UIStoryboardSegue*)segue;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"SETTINGS";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self initSettings];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (self.isShopOwner)
        return 3;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.isShopOwner)  {
        if (section == 0)
            return 3;
        else if (section == 1)
            return 2;
        else if (section == 2)
            return 1;
    }
    else {
        if (section == 0)
            return 3;
        else if (section == 1)
            return 1;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0)
        return 70.f;
    return 0.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (self.isShopOwner) {
        if (section == 0)
            return @"General";
        else if (section == 1)
            return @"My Shop & Deals";
        else if (section == 2)
            return @"Others";
    }
    else {
        if (section == 0)
            return @"General";
        else if (section == 1)
            return @"Others";
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingsCell* cell = (SettingsCell*)[tableView dequeueReusableCellWithIdentifier:@"SettingsCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"icon_settings_profile"];
            cell.textLabel.text = @"User Profile";
        }
        else if (indexPath.row == 1) {
            cell.imageView.image = [UIImage imageNamed:@"icon_settings_friends"];
            cell.textLabel.text = @"Friends List";
        }
        else if (indexPath.row == 2) {
            cell.imageView.image = [UIImage imageNamed:@"icon_settings_privacy"];
            cell.textLabel.text = @"Privacy Settings";
            
            if (!self.privacySwitch) {
                self.privacySwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
                [self.privacySwitch setOn:([[APIManager sharedManager] getUserPrivacy] == UserPrivacy_Private) animated:YES];
            }
            [self.privacySwitch addTarget:self action:@selector(changePrivacySettings:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = self.privacySwitch;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    else if (indexPath.section == 1) {
        
        if (self.isShopOwner) {
            if (indexPath.row == 0) {
                cell.imageView.image = [UIImage imageNamed:@"icon_settings_shop"];
                cell.textLabel.text = @"My Shop";
            }
            else if (indexPath.row == 1) {
                cell.imageView.image = [UIImage imageNamed:@"icon_settings_deal"];
                cell.textLabel.text = @"My Deals";
            }
        }
        else {
            if (indexPath.row == 0) {
                cell.imageView.image = [UIImage imageNamed:@"icon_settings_password"];
                cell.textLabel.text = @"Password";
            }
        }
    }
    else if (indexPath.section == 2) {
        
        if (self.isShopOwner) {
            if (indexPath.row == 0) {
                cell.imageView.image = [UIImage imageNamed:@"icon_settings_password"];
                cell.textLabel.text = @"Password";
            }
        }
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        UILabel* footerView = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, tableView.frame.size.width, 70.f)];
        footerView.text = @"When your account is private, only people\nyou approve can see your photos and videos.\nYour existing followers won't be affected.";
        footerView.textColor = [UIColor lightGrayColor];
        footerView.font = [UIFont systemFontOfSize:14.f];
        footerView.textAlignment = NSTextAlignmentCenter;
        footerView.numberOfLines = 0;
        
        return footerView;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.separatorInset = UIEdgeInsetsZero;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:Segue_ShowLogin]) {
        LoginViewController* loginVC = (LoginViewController*)((UINavigationController*)segue.destinationViewController).topViewController;
        loginVC.loginDelegate = self;
    }
}


#pragma mark -
#pragma mark - UITableView delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self performSegueWithIdentifier:Segue_ShowUserProfile sender:indexPath];
                break;
            case 1:
                [self performSegueWithIdentifier:Segue_ShowFriendsList sender:indexPath];
                break;
                
            default:
                break;
        }
    }
    else if (indexPath.section == 1) {
        if (self.isShopOwner) {
            if (indexPath.row == 0)
                [self performSegueWithIdentifier:Segue_ShowMyShop sender:indexPath];
            else
                [self performSegueWithIdentifier:Segue_ShowMyDeals sender:indexPath];
        }
        else {
            if (indexPath.row == 0)
                [self performSegueWithIdentifier:Segue_ShowChangePassword sender:indexPath];
        }
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0)
            [self performSegueWithIdentifier:Segue_ShowChangePassword sender:indexPath];
    }
}


#pragma mark -
#pragma mark - Main methods

- (void)initSettings {
    
    APIManager* apiManager = [APIManager sharedManager];
    if ([apiManager isUserLoggedIn]) {
        [self loadUserDetails];
        [self getUserPrivacy];
    }
    else {
        [self showSettingsSplash:YES];
    }
}

- (void)loadUserDetails {
    
    [self showSettingsSplash:NO];
    
    APIManager* apiManager = [APIManager sharedManager];
    NSDictionary* userDetails = [apiManager getUserDetails];
    if (userDetails && [userDetails isKindOfClass:[NSDictionary class]]) {
        NSNumber* userTypeNumber = [userDetails objectForKey:key_user_type_id];
        
        self.isShopOwner = (userTypeNumber && userTypeNumber.intValue == UserType_ShopOwner);
        [self.settingsTableView reloadData];
    }
    else {
        
        [SVProgressHUD show];
        [[APIManager sharedManager] getUserInfo:^(AFHTTPRequestOperation *operation, id responseObject) {
            
#if DEBUG
            NSLog(@"GetUserDetails : %@", responseObject);
#endif
            NSNumber* userTypeId = nil;
            if (responseObject) {
                userTypeId = [responseObject objectForKey:key_user_type_id];
            }
            
            self.isShopOwner = (userTypeId && userTypeId.intValue == UserType_ShopOwner);
            [self.settingsTableView reloadData];
            
            [SVProgressHUD dismiss];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }
}

- (void)getUserPrivacy {
    
    APIManager* apiManager = [APIManager sharedManager];
    
    UserPrivacy userPrivacy = [apiManager getUserPrivacy];
    if (userPrivacy != UserPrivacy_None) {
        [self.privacySwitch setOn:(userPrivacy == UserPrivacy_Private) animated:YES];
    }
    else {
        
        [SVProgressHUD show];
        [[APIManager sharedManager] getUserPrivacy:^(AFHTTPRequestOperation *operation, id privacyNumber) {
            
#if DEBUG
            NSLog(@"getUserPrivacy : %@", privacyNumber);
#endif
            [self.privacySwitch setOn:([privacyNumber intValue] == UserPrivacy_Private) animated:YES];
            
            [SVProgressHUD dismiss];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }
}

- (void)showSettingsSplash:(BOOL)show {
    
    self.settingsSplashWrapper.alpha = show;
}

- (IBAction)tapSignuotButton:(id)sender {
    
    [[APIManager sharedManager] signout];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changePrivacySettings:(id)sender {
    
    [SVProgressHUD show];
    [[APIManager sharedManager] setUserPrivacy:^(AFHTTPRequestOperation *operation, id responseObject) {
        
#if DEBUG
        NSLog(@"changePrivacySettings : %@", responseObject);
#endif
        
        UserPrivacy privacy = [[APIManager sharedManager] getUserPrivacy];
        
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSString* result = [responseObject objectForKey:key_message];
            if (result && [result isEqualToString:key_Done]) {
                if (privacy != UserPrivacy_Private)
                    privacy = UserPrivacy_Private;
                else
                    privacy = UserPrivacy_Public;
            }
        }
        
        [[APIManager sharedManager] setUserPrivacy:privacy];
        [self.privacySwitch setOn:(privacy == UserPrivacy_Private) animated:YES];
        
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (IBAction)unwindToSettingsAfterLogin:(UIStoryboardSegue*)segue {
    
}


#pragma mark -
#pragma mark - Login delegate

- (void)kushmeDidLogin {
    
    [self loadUserDetails];
    [self getUserPrivacy];
}

@end
