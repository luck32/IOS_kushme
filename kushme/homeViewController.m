//
//  homeViewController.m
//  kushme
//
//  Created by Paras Gorasiya on 11/05/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "homeViewController.h"

@interface homeViewController ()

- (IBAction)tapSettingsButton:(id)sender;

@end

@implementation homeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_logo"]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor darkGrayColor]};
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.frame.size.height / 6;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)tapSettingsButton:(id)sender {
    
    [self performSegueWithIdentifier:Segue_ShowSettings sender:nil];
    
//    if([[APIManager sharedManager] isUserLoggedIn]) {
//        [self performSegueWithIdentifier:Segue_ShowSettings sender:nil];
//    }
//    else {
//        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"Please login so we can keep track of your saved deals" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
//        [alert addAction:cancelAction];
//        UIAlertAction* loginAction = [UIAlertAction actionWithTitle:@"Login" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            [self performSegueWithIdentifier:Segue_ShowLogin sender:self];
//        }];
//        [alert addAction:loginAction];
//        
//        [self presentViewController:alert animated:YES completion:nil];
//    }
}

@end
