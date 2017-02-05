//
//  MyDealsViewController.m
//  kushme
//
//  Created by Yanny on 5/17/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "MyDealsViewController.h"
#import "DealTableViewCell.h"

@interface MyDealsViewController ()

@property (weak, nonatomic) IBOutlet UITableView* dealsTableView;

@property (nonatomic, strong) NSMutableArray* myDeals;

@end

@implementation MyDealsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"MY DEALS";
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor darkGrayColor]};
    
    [self loadMyDeals];
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
    return [self.myDeals count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealTableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    DealTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dealCell"];
    [cell setCellData:self.myDeals[indexPath.row]];
    
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

- (void)loadMyDeals {
    
    [SVProgressHUD show];
    
    [[APIManager sharedManager] getMyDeals:^(AFHTTPRequestOperation *operation, id responseObject) {
        
#if DEBUG
        NSLog(@"MyDeals : %@", responseObject);
#endif
        self.myDeals = [NSMutableArray arrayWithCapacity:0];
        
        NSMutableArray* searchResults = [NSMutableArray arrayWithCapacity:0];
        if (responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray* allValues = [responseObject allValues];
                for (NSDictionary* shopDict in allValues) {
                    if (shopDict && [shopDict isKindOfClass:[NSDictionary class]])
                        [searchResults addObject:shopDict];
                }
            }
            else if ([responseObject isKindOfClass:[NSArray class]]) {
                [searchResults addObjectsFromArray:responseObject];
            }
            
            NSArray* sortedSearchResults = [UtilManager sortShopList:searchResults];
            if (sortedSearchResults && sortedSearchResults.count > 0) {
                self.myDeals = [NSMutableArray arrayWithArray:sortedSearchResults];
                [self.dealsTableView reloadData];
            }
            else {
                [SVProgressHUD showInfoWithStatus:@"You have no deals"];
                self.myDeals = nil;
                return;
            }
        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
#if DEBUG
        NSLog(@"MyDeals : %@", error.localizedDescription);
#endif
        
        [SVProgressHUD dismiss];
        [[AlertManager sharedManager] showErrorAlert:[error localizedDescription] onVC:self];
    }];
}


@end
