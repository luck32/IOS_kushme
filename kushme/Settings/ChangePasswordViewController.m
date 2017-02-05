//
//  ChangePasswordViewController.m
//  kushme
//
//  Created by Yanny on 5/19/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "ChangePasswordViewController.h"

@implementation PasswordCell

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


@interface ChangePasswordViewController ()

@property (weak, nonatomic) IBOutlet UITableView* passwordTableView;

- (IBAction)tapSubmitButton:(id)sender;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"CHANGE PASSWORD";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PasswordCell* cell = (PasswordCell*)[tableView dequeueReusableCellWithIdentifier:@"PasswordCell" forIndexPath:indexPath];
    
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
            cell.keyLabel.text = @"Old Password:";
            break;
        case 1:
            cell.keyLabel.text = @"New Password:";
            break;
        case 2:
            cell.keyLabel.text = @"Confirm Password:";
            break;
            
        default:
            break;
    }
    
    return cell;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark - Main methods

- (IBAction)tapSubmitButton:(id)sender {
    
    [self resignPasswordFields];
    
    NSString* oldPassword = [self passwordCellWithRow:0].valueField.text;
    NSString* newPassword = [self passwordCellWithRow:1].valueField.text;
    NSString* confirmPassword = [self passwordCellWithRow:2].valueField.text;
    
    if (newPassword == nil)
        newPassword = @"";
    if (confirmPassword == nil)
        confirmPassword = @"";
    
    if ([newPassword isEqualToString:confirmPassword]) {
        [self changePassword:oldPassword with:newPassword];
    }
    else {
        [[self passwordCellWithRow:1].valueField becomeFirstResponder];
        [[AlertManager sharedManager] showErrorAlert:@"New Passwords are not match." onVC:self];
    }
}

- (PasswordCell*)passwordCellWithRow:(NSInteger)row {
    PasswordCell* cell = (PasswordCell*)[self.passwordTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    return cell;
}

- (void)changePassword:(NSString*)oldPassword with:(NSString*)newPassword {
    
    [SVProgressHUD show];
    [[APIManager sharedManager] changePassword:oldPassword with:newPassword success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
#if DEBUG
        NSLog(@"ChangePassword : %@", responseObject);
#endif
        
        [SVProgressHUD dismiss];
        
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSNumber* result = [responseObject objectForKey:key_message];
            if (result.intValue == 1) {
                [[APIManager sharedManager] resetPassword:newPassword];
                [[AlertManager sharedManager] showErrorAlert:@"Success to change your password!" onVC:self];
                return;
            }
        }
        
        [[AlertManager sharedManager] showErrorAlert:@"Failed to change your password!" onVC:self];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
    }];
}

- (void)resignPasswordFields {
    
    [[self passwordCellWithRow:0].valueField resignFirstResponder];
    [[self passwordCellWithRow:1].valueField resignFirstResponder];
    [[self passwordCellWithRow:2].valueField resignFirstResponder];
}


@end
