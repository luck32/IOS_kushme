//
//  MessagesViewController.m
//  kushme
//
//  Created by Nicolas Rostov on 17/5/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "MessagesViewController.h"
#import "APIManager.h"
#import "MessageCell.h"
#import "ShopDetailViewController.h"

@interface MessagesViewController ()

@property (nonatomic, strong) NSArray *messages;

- (IBAction)deleteAction:(id)sender;

@end

@implementation MessagesViewController

@synthesize senderId;

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

-(void)loadData {
    if([[APIManager sharedManager] isUserLoggedIn]) {
        [SVProgressHUD show];
        NSLog(@"Loading messages for %i", self.senderId);
        [[APIManager sharedManager] getMessagesForSender:self.senderId
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     if([responseObject isKindOfClass:[NSArray class]] && [responseObject count] > 0) {
                                                         self.messages = [NSArray arrayWithArray:responseObject];
                                                         [SVProgressHUD dismiss];
                                                     }
                                                     else {
                                                         [SVProgressHUD showInfoWithStatus:@"You have no messages"];
                                                         self.messages = nil;
                                                     }
                                                     [self.tableView reloadData];
                                                     [(AppDelegate*)[[UIApplication sharedApplication] delegate] updateMessagesNotifications];
                                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     [SVProgressHUD dismiss];
                                                     self.messages = nil;
                                                     [self.tableView reloadData];
                                                     [[AlertManager sharedManager] showErrorAlert:[error localizedDescription] onVC:self];
                                                 }];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)deleteAction:(id)sender {
    int messageId = (int)[sender tag];
    [SVProgressHUD show];
    [[APIManager sharedManager] deleteMessageId:messageId
                                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                            NSLog(@"%@", responseObject);
                                            [self loadData];
                                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            NSLog(@"%@", error);
                                            [SVProgressHUD dismiss];
                                            [[AlertManager sharedManager] showErrorAlert:[error localizedDescription] onVC:self];
                                        }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.messages count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForCellAtIndexPath:indexPath];
}

- (CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath {
    static MessageCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    });
    
    [sizingCell setCellData:self.messages[indexPath.section]];
    CGFloat result = sizingCell.frame.size.height + 18;
    return result>=100?result:100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
    
    [cell setCellData:self.messages[indexPath.section]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self performSegueWithIdentifier:Segue_ShowShopDetail sender:self.messages[indexPath.section]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:Segue_ShowShopDetail] && [sender isKindOfClass:[UIButton class]]) {
        ShopDetailViewController *shopController = [segue destinationViewController];
        shopController.shopInfo = [NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%i",[sender tag]] forKey:key_shop_id];
    }
}

@end
