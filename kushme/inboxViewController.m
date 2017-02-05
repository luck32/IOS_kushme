//
//  inboxViewController.m
//  kushme
//
//  Created by Paras Gorasiya on 11/05/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "inboxViewController.h"
#import "MessageGroupCell.h"
#import "APIManager.h"
#import "MessagesViewController.h"

@interface inboxViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *switchButtonPage;
@property (nonatomic, strong) NSArray *messageGroups;
@property (nonatomic, strong) NSArray *unreadMessageGroups;

-(IBAction)pageSwitchAction:(id)sender;

@end

@implementation inboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    if([self.messageGroups count] == 0) {
        if([[APIManager sharedManager] isUserLoggedIn]) {
            [SVProgressHUD show];
            [[APIManager sharedManager] getMessageGroups:^(AFHTTPRequestOperation *operation, id responseObject) {
                if([responseObject isKindOfClass:[NSArray class]] && [responseObject count] > 0) {
                    self.messageGroups = [NSArray arrayWithArray:responseObject];
                    NSMutableArray *unreadGroups = [NSMutableArray array];
                    for(NSDictionary *msgGroup in self.messageGroups) {
                        if([msgGroup[key_message_unread_flag] intValue] == 1)
                            [unreadGroups addObject:msgGroup];
                    }
                    self.unreadMessageGroups = [NSArray arrayWithArray:unreadGroups];
                    if([self.unreadMessageGroups count] == 0)
                        self.switchButtonPage.selectedSegmentIndex = 1;
                    [self.tableView reloadData];
                    [SVProgressHUD dismiss];
                    [(AppDelegate*)[[UIApplication sharedApplication] delegate] updateMessagesNotifications];
                }
                else {
                    [SVProgressHUD showInfoWithStatus:@"You have no messages"];
                    self.messageGroups = nil;
                    self.unreadMessageGroups = nil;
                    [self.tableView reloadData];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD dismiss];
                [[AlertManager sharedManager] showErrorAlert:[error localizedDescription] onVC:self];
            }];
        }
        else {
            [[[UIAlertView alloc] initWithTitle:@"" message:@"Please login to have direct communication with dispensaries" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil] show];
        }
//    }
}

-(IBAction)pageSwitchAction:(id)sender {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.switchButtonPage.selectedSegmentIndex == 0)
        return [self.unreadMessageGroups count];
    else
        return [self.messageGroups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageGroupCell"];
    if(self.switchButtonPage.selectedSegmentIndex == 0) {
        [cell setCellData:self.unreadMessageGroups[indexPath.section]];
    }
    else {
        [cell setCellData:self.messageGroups[indexPath.section]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *selectedGroup;
    if(self.switchButtonPage.selectedSegmentIndex == 0) {
        selectedGroup = self.unreadMessageGroups[indexPath.section];
    }
    else {
        selectedGroup = self.messageGroups[indexPath.section];
    }
    [self performSegueWithIdentifier:Segue_MessageDetails sender:selectedGroup];
}


#pragma mark UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        [self performSegueWithIdentifier:Segue_ShowLogin sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:Segue_MessageDetails]) {
        MessagesViewController *messagesController = [segue destinationViewController];
        messagesController.senderId = [sender[key_shop_id] intValue];
        messagesController.title = sender[key_message_shop_name];
    }
}

@end
