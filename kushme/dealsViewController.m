//
//  dealsViewController.m
//  kushme
//
//  Created by Paras Gorasiya on 11/05/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "dealsViewController.h"
#import "APIManager.h"
#import "DealTableViewCell.h"
#import "DealsDetailViewController.h"

#define DEAL_CACHE_KEY @"DEAL_CACHE_KEY"

@interface dealsViewController ()

@property (nonatomic, strong) NSArray *deals;

@end

@implementation dealsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.deals = nil;
    [self.tableView reloadData];
    if([[APIManager sharedManager] isUserLoggedIn]) {
        self.deals = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:DEAL_CACHE_KEY]];
        [self.tableView reloadData];
    
        if([self.deals count] == 0)
            [SVProgressHUD show];
        [[APIManager sharedManager] getSavedDeals:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Saved Deals : %@", responseObject);
            if([responseObject isKindOfClass:[NSArray class]] && [responseObject count] > 0) {
                
                [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:DEAL_CACHE_KEY];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                self.deals = [NSArray arrayWithArray:responseObject];
                [self.tableView reloadData];
                [SVProgressHUD dismiss];
            }
            else if([self.deals count] == 0) {
                [SVProgressHUD showInfoWithStatus:@"You have no saved deals"];
                self.deals = nil;
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Saved Deals Error : %@", error);
            [SVProgressHUD dismiss];
            [[AlertManager sharedManager] showErrorAlert:[error localizedDescription] onVC:self];
        }];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Please login so we can keep track of your saved deals" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil] show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        [self performSegueWithIdentifier:Segue_ShowLogin sender:self];
    }
}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.deals count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DealTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dealCell"];
    [cell setCellData:self.deals[indexPath.section]];
    [cell setDetailsTarget:self action:@selector(tapDealDetailsButton:) tag:indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:Segue_ShowDealsDetail]) {
        NSMutableDictionary* dealInfo = [NSMutableDictionary dictionaryWithDictionary:sender];
        
        DealsDetailViewController* vc = (DealsDetailViewController*)segue.destinationViewController;
        vc.isSavedDeal = YES;
        vc.dealInfo = dealInfo;
    }
}

- (void)tapDealDetailsButton:(UIButton*)sender {
    NSInteger section = sender.tag;
    NSDictionary* dealInfo = self.deals[section];
    
    if (dealInfo) {
        [self performSegueWithIdentifier:Segue_ShowDealsDetail sender:dealInfo];
    }
}

@end
