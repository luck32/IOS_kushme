//
//  MyShopsViewController.m
//  kushme
//
//  Created by Yanny on 5/16/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "MyShopsViewController.h"
#import "ShopsCell.h"

@interface MyShopsViewController ()

@property (weak, nonatomic) IBOutlet UITableView* shopsTableView;

@property (strong, nonatomic) NSMutableArray* myShops;

@end

@implementation MyShopsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"MY SHOPS";
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor darkGrayColor]};
    
    [self loadMyShops];
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
    return [self.myShops count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopsCell *cell = (ShopsCell*)[tableView dequeueReusableCellWithIdentifier:@"ShopsCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSDictionary* shopDict = [self.myShops objectAtIndex:indexPath.row];
    if (shopDict) {
        // set logo
        NSString* logoUrl = [shopDict objectForKey:key_shop_pic];
        if (logoUrl) {
            logoUrl = logoUrl.stringByRemovingPercentEncoding;
            [cell.shopLogoView setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:nil];
        }
        
        NSString* shopName = [shopDict objectForKey:key_shop_name];
        if ([cell isMultilineShopName:shopName])
            cell.shopNameLabel.text = shopName;
        else
            cell.shopNameLabel.text = [shopName stringByAppendingString:@"\n"];
        
        cell.shopDistanceLabel.text = [NSString stringWithFormat:@"%d miles", [[shopDict objectForKey:key_distance] intValue]];
        cell.shopAddressLabel.text = [shopDict objectForKey:key_shop_address];
        [cell setRate:[[shopDict objectForKey:key_shop_rating] intValue]];
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
#pragma mark - UITableView delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    [self performSegueWithIdentifier:Segue_ShowShopDetail sender:indexPath];
}


#pragma mark -
#pragma mark - Main methods

- (void)loadMyShops {
    
    [SVProgressHUD show];
    
    [[APIManager sharedManager] getMyShops:^(AFHTTPRequestOperation *operation, id responseObject) {
        
#if DEBUG
        NSLog(@"MyShops : %@", responseObject);
#endif
        self.myShops = [NSMutableArray arrayWithCapacity:0];
        
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
                self.myShops = [NSMutableArray arrayWithArray:sortedSearchResults];
                [self.shopsTableView reloadData];
            }
            else {
                [SVProgressHUD showInfoWithStatus:@"You have no shops"];
                self.myShops = nil;
                return;
            }
        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
#if DEBUG
        NSLog(@"MyShops : %@", error.localizedDescription);
#endif
        
        [SVProgressHUD dismiss];
        [[AlertManager sharedManager] showErrorAlert:[error localizedDescription] onVC:self];
    }];
}


@end
