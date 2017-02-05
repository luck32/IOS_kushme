//
//  uploadPicViewController.m
//  kushme
//
//  Created by Paras Gorasiya on 11/05/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "uploadPicViewController.h"
#import "CropSendViewController.h"

@interface uploadPicViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *buttonLibrary;
@property NSInteger latestPickerType;

- (IBAction)takePictureAction:(id)sender;
- (IBAction)libraryAction:(id)sender;

@end

@implementation uploadPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.buttonLibrary.backgroundColor = self.tabBarController.view.tintColor;
    self.buttonLibrary.clipsToBounds = YES;
    self.buttonLibrary.layer.cornerRadius = 6;
    self.buttonLibrary.layer.borderWidth = 1;
    self.buttonLibrary.layer.borderColor = [[UIColor clearColor] CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"CropSendSegue"]) {
        CropSendViewController *cropController = [segue destinationViewController];
        NSDictionary *info = sender;
        cropController.originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        cropController.croppedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        cropController.cropRect = [[info objectForKey:UIImagePickerControllerCropRect] CGRectValue];
    }
}

- (IBAction)takePictureAction:(id)sender {
    if(![[APIManager sharedManager] isUserLoggedIn]) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"You should be logged in to upload picture" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil] show];
        return;
    }
    self.latestPickerType = UIImagePickerControllerSourceTypeCamera;
    [self openPhotoPicker:self.latestPickerType animated:YES];
}

- (IBAction)libraryAction:(id)sender {
    if(![[APIManager sharedManager] isUserLoggedIn]) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"You should be logged in to upload picture" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil] show];
        return;
    }
    self.latestPickerType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self openPhotoPicker:self.latestPickerType animated:YES];
}

-(void)showLatestImagePicker {
    [self openPhotoPicker:self.latestPickerType animated:NO];
}

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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        [self performSegueWithIdentifier:Segue_ShowLogin sender:self];
        return;
    }
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"CropSendSegue" sender:info];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
