//
//  ProfileViewController.m
//  kushme
//
//  Created by Yanny on 5/19/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIButton+AFNetworking.h"

@implementation ProfileCell

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


@implementation ProfilePictureCell

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


@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView* profileWrapper;
@property (weak, nonatomic) IBOutlet UIImageView* profileImageView;
@property (weak, nonatomic) IBOutlet UIButton* profileImageButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView* profileImageIndicatorView;
@property (weak, nonatomic) IBOutlet UITableView* profileTableView;

@property (strong, nonatomic) UITextField* curTextField;

@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) UIImage *croppedImage;
@property NSInteger latestPickerType;
@property CGRect cropRect;

@property (nonatomic) CGRect keyboardBounds;
@property (nonatomic) CGFloat animateDistance;

- (IBAction)tapUploadPicButton:(id)sender;
- (IBAction)tapSubmitButton:(id)sender;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"MY PROFILE";
    
    self.profileImageButton.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
    self.profileImageButton.layer.masksToBounds = YES;
    self.profileImageButton.layer.borderColor = [TINT_COLOR CGColor];
    self.profileImageButton.layer.borderWidth = 2.f;
    
    [self loadUserDetails];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 7)
        return 90.f;
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 7) {
        ProfilePictureCell* cell = (ProfilePictureCell*)[tableView dequeueReusableCellWithIdentifier:@"ProfilePictureCell" forIndexPath:indexPath];
        
        return cell;
    }
    
    ProfileCell* cell = (ProfileCell*)[tableView dequeueReusableCellWithIdentifier:@"ProfileCell" forIndexPath:indexPath];
    cell.valueField.tag = indexPath.row;
    
    NSDictionary* userDetails = [[APIManager sharedManager] getUserDetails];
    
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
            cell.keyLabel.attributedText = [self getAttrString:@"User Name* :"];
            cell.valueField.text = userDetails[key_user_name];
            break;
        case 1:
            cell.keyLabel.attributedText = [self getAttrString:@"Email* :"];
            cell.valueField.text = userDetails[key_user_email];
            break;
        case 2:
            cell.keyLabel.text = @"Street Address :";
            cell.valueField.text = userDetails[key_user_address];
            break;
        case 3:
            cell.keyLabel.text = @"City :";
            cell.valueField.text = userDetails[key_user_city];
            break;
        case 4:
            cell.keyLabel.text = @"State :";
            cell.valueField.text = userDetails[key_user_state];
            break;
        case 5:
            cell.keyLabel.text = @"Zipcode :";
            cell.valueField.text = userDetails[key_user_zip];
            break;
        case 6:
            cell.keyLabel.text = @"Phone No :";
            cell.valueField.text = userDetails[key_user_phone];
            break;
            
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
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

- (NSURL*)getProfileURL {
    
    NSDictionary* userDetails = [[APIManager sharedManager] getUserDetails];
    if (userDetails && [userDetails isKindOfClass:[NSDictionary class]]) {
        NSString* strLogoUrl = [userDetails objectForKey:key_user_picture];
        if (strLogoUrl) {
            strLogoUrl = strLogoUrl.stringByRemovingPercentEncoding;
            
            NSURL* logoUrl = [NSURL URLWithString:strLogoUrl];
            
            return logoUrl;
        }
    }
    return nil;
}

- (void)loadProfileImage {
    
    NSURL* logoUrl = [self getProfileURL];
    NSLog(@"LoadProfileImage : url = %@", logoUrl);
    
    if (logoUrl) {
        [self.profileImageIndicatorView startAnimating];
        
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:logoUrl];
//        request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
        [self.profileImageButton setImageForState:UIControlStateNormal withURLRequest:request placeholderImage:nil
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                              [self.profileImageIndicatorView stopAnimating];
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [self.profileImageButton setImage:image forState:UIControlStateNormal];
                                              });
                                          } failure:^(NSError *error) {
                                              [self.profileImageIndicatorView stopAnimating];
                                          }];
    }
}

- (void)loadUserDetails {
    
    APIManager* apiManager = [APIManager sharedManager];
    NSDictionary* userDetails = [apiManager getUserDetails];
    if (userDetails && [userDetails isKindOfClass:[NSDictionary class]]) {
        [self.profileTableView reloadData];
        [self loadProfileImage];
    }
    else {
        [SVProgressHUD show];
        [[APIManager sharedManager] getUserInfo:^(AFHTTPRequestOperation *operation, id responseObject) {
            
#if DEBUG
            NSLog(@"loadUserDetails (ProfileVC) : %@", responseObject);
#endif
            
            [SVProgressHUD dismiss];
            
            [self.profileTableView reloadData];
            [self loadProfileImage];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }
}

- (NSMutableAttributedString*)getAttrString:(NSString*)keyString
{
    NSMutableAttributedString* attributesString = [[NSMutableAttributedString alloc] initWithString:keyString];
    
    NSRange range = [keyString rangeOfString:@"*"];
    if (range.length > 0)
    {
        [attributesString setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],
                                          NSFontAttributeName:[UIFont systemFontOfSize:13.f]} range:range];
    }
    
    return attributesString;
}

- (ProfileCell*)profileCellWithRow:(NSInteger)row {
    ProfileCell* cell = (ProfileCell*)[self.profileTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    return cell;
}

- (NSString*)valueOfProfileCellWithRow:(NSInteger)row {
    
    ProfileCell* cell = [self profileCellWithRow:row];
    NSString* value = cell.valueField.text;
    if (value == nil)
        value = @"";
    
    return value;
}

- (IBAction)tapUploadPicButton:(id)sender {
    
    [self showPhotoActionSheet:YES];
}

- (IBAction)tapSubmitButton:(id)sender {
    
    NSString* username = [self valueOfProfileCellWithRow:0];
    if ([username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1) {
        [[self profileCellWithRow:0].valueField becomeFirstResponder];
        [[AlertManager sharedManager] showErrorAlert:@"Please type your username" onVC:self];
        return;
    }
    NSString* email = [self valueOfProfileCellWithRow:1];
    if ([email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1) {
        [[self profileCellWithRow:1].valueField becomeFirstResponder];
        [[AlertManager sharedManager] showErrorAlert:@"Please type your email address" onVC:self];
        return;
    }
    NSString* address = [self valueOfProfileCellWithRow:2];
    NSString* city = [self valueOfProfileCellWithRow:3];
    NSString* state = [self valueOfProfileCellWithRow:4];
    NSString* zip = [self valueOfProfileCellWithRow:5];
    NSString* phone = [self valueOfProfileCellWithRow:6];
    NSString* profilePic = self.croppedImage != nil ? [UIImageJPEGRepresentation(self.croppedImage, 0.85) base64EncodedStringWithOptions:0] : @"0";
    
    [SVProgressHUD show];
    
    APIManager* apiManager = [APIManager sharedManager];
    [apiManager editUserProfileWithUsername:username email:email address:address city:city state:state zip:zip phone:phone profilePic:profilePic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
#if DEBUG
        NSLog(@"EditProfile : %@", responseObject);
#endif
        
        [SVProgressHUD dismiss];
        
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSNumber* result = [responseObject objectForKey:key_message];
            if (result.intValue == 1) {
                [self loadProfileImage];
                [[AlertManager sharedManager] showErrorAlert:@"Changes Saved" onVC:self];
                return;
            }
        }
        
        [[AlertManager sharedManager] showErrorAlert:@"Failed to edit your profile." onVC:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
    }];
}


- (void)takePictureAction {
    self.latestPickerType = UIImagePickerControllerSourceTypeCamera;
    [self openPhotoPicker:self.latestPickerType animated:YES];
}

- (void)libraryAction {
    self.latestPickerType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self openPhotoPicker:self.latestPickerType animated:YES];
}

- (void)showPhotoActionSheet:(BOOL)show {
    
    UIAlertController* cameraSheet = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [cameraSheet addAction:[UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [cameraSheet dismissViewControllerAnimated:YES completion:nil];
        [self takePictureAction];
    }]];
    [cameraSheet addAction:[UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [cameraSheet dismissViewControllerAnimated:YES completion:nil];
        [self libraryAction];
    }]];
    [cameraSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [cameraSheet dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:cameraSheet animated:YES completion:nil];
}

- (IBAction)resignInputFields {
    
    [[self profileCellWithRow:0].valueField resignFirstResponder];
    [[self profileCellWithRow:1].valueField resignFirstResponder];
    [[self profileCellWithRow:2].valueField resignFirstResponder];
    [[self profileCellWithRow:3].valueField resignFirstResponder];
    [[self profileCellWithRow:4].valueField resignFirstResponder];
    [[self profileCellWithRow:5].valueField resignFirstResponder];
    [[self profileCellWithRow:6].valueField resignFirstResponder];
}

#pragma mark -
#pragma mark - Capture profile photo

- (void)openPhotoPicker:(UIImagePickerControllerSourceType)sourceType animated:(BOOL)animated {
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
        if ([availableMediaTypes containsObject:(NSString *)kUTTypeImage]) {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
            imagePickerController.sourceType = sourceType;
            imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
            imagePickerController.allowsEditing = YES;
            imagePickerController.delegate = self;
            [self presentViewController:imagePickerController animated:animated completion:nil];
        }
    }
}

#pragma mark -
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.croppedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    self.cropRect = [[info objectForKey:UIImagePickerControllerCropRect] CGRectValue];
    
    //show cropped image
    [self.profileImageButton setImage:self.croppedImage forState:UIControlStateNormal];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField*)sender {
    self.curTextField = sender;
    
//    if (!CGRectIsEmpty(_keyboardBounds)) {
//        [self animateTextFieldUp:YES duration:0.25f keyboardBounds:_keyboardBounds];
//    }
}

//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    NSLog(@"%@", textField);
//    
//    [self animateTextFieldUp:NO duration:0.25f keyboardBounds:_keyboardBounds];
//}

- (void)keyboardWillShow:(NSNotification*)notif {
    
    // get keyboard size and loctaion
    [[notif.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &_keyboardBounds];
    NSNumber *duration = [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    _keyboardBounds = [self.view convertRect:_keyboardBounds toView:nil];
    
    [self animateTextFieldUp:YES duration:(CGFloat)duration.floatValue keyboardBounds:_keyboardBounds];
}

- (void)keyboardWillHide:(NSNotification*)notif {
    
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[notif.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    [self animateTextFieldUp:NO duration:(CGFloat)duration.floatValue keyboardBounds:keyboardBounds];
}

- (void)animateTextFieldUp:(BOOL)up duration:(CGFloat)duration keyboardBounds:(CGRect)keyboardBounds {
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.curTextField.tag inSection:0];
    CGRect cellRect = [self.profileTableView rectForRowAtIndexPath:indexPath];
    
    CGRect frame = self.profileTableView.frame;
    if (up) {
        self.animateDistance = (cellRect.size.height + cellRect.origin.y + keyboardBounds.size.height) - (self.profileTableView.contentOffset.y + self.view.frame.size.height + self.tabBarController.tabBar.frame.size.height);
        if (self.animateDistance < 0)
            self.animateDistance = 0.f;
        
        frame.size.height = self.view.frame.size.height + self.tabBarController.tabBar.frame.size.height - _keyboardBounds.size.height;
    }
    else {
        self.animateDistance = self.animateDistance * (-1);
        
        frame.size.height = self.view.frame.size.height;
    }
    
//    [self.profileTableView setContentOffset:CGPointMake(0.f, self.profileTableView.contentOffset.y + self.animateDistance) animated:YES];
    
    [UIView animateWithDuration:0.15f animations:^{
        self.profileTableView.contentOffset = CGPointMake(0.f, self.profileTableView.contentOffset.y + self.animateDistance);
        self.profileTableView.frame = frame;
    } completion:nil];
}

@end
