//
//  ShopTimeViewController.m
//  kushme
//
//  Created by Yanny on 5/29/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "ShopTimeViewController.h"

@implementation ShopTimeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

@end



@interface ShopTimeViewController ()

@property (weak, nonatomic) IBOutlet UITableView* shopTimeTableView;

@end

@implementation ShopTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"SHOP TIME";
    
    [self loadShopTimes];
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
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopTimeCell *cell = (ShopTimeCell*)[tableView dequeueReusableCellWithIdentifier:@"ShopTimeCell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *shop_open_time = @"";
    NSString *shop_close_time = @"";
    
    switch (indexPath.row) {
        case 0:
            shop_open_time = [self.shopInfo valueForKey:key_shop_opening_time_monday];
            shop_close_time = [self.shopInfo valueForKey:key_shop_closing_time_monday];
            
            cell.textLabel.text = key_Monday.uppercaseString;
            break;
        case 1:
            shop_open_time = [self.shopInfo valueForKey:key_shop_opening_time_tuesday];
            shop_close_time = [self.shopInfo valueForKey:key_shop_closing_time_tuesday];
            
            cell.textLabel.text = key_Tuesday.uppercaseString;
            break;
        case 2:
            shop_open_time = [self.shopInfo valueForKey:key_shop_opening_time_wednesday];
            shop_close_time = [self.shopInfo valueForKey:key_shop_closing_time_wednesday];
            
            cell.textLabel.text = key_Wednesday.uppercaseString;
            break;
        case 3:
            shop_open_time = [self.shopInfo valueForKey:key_shop_opening_time_thursday];
            shop_close_time = [self.shopInfo valueForKey:key_shop_closing_time_thursday];
            
            cell.textLabel.text = key_Thursday.uppercaseString;
            break;
        case 4:
            shop_open_time = [self.shopInfo valueForKey:key_shop_opening_time_friday];
            shop_close_time = [self.shopInfo valueForKey:key_shop_closing_time_friday];
            
            cell.textLabel.text = key_Friday.uppercaseString;
            break;
        case 5:
            shop_open_time = [self.shopInfo valueForKey:key_shop_opening_time_saturday];
            shop_close_time = [self.shopInfo valueForKey:key_shop_closing_time_saturday];
            
            cell.textLabel.text = key_Saturday.uppercaseString;
            break;
        case 6:
            shop_open_time = [self.shopInfo valueForKey:key_shop_opening_time_sunday];
            shop_close_time = [self.shopInfo valueForKey:key_shop_closing_time_sunday];
            
            cell.textLabel.text = key_Sunday.uppercaseString;
            break;
            
        default:
            break;
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", shop_open_time, shop_close_time].capitalizedString;
    
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Main methods

- (void)loadShopTimes {
    if (!self.shopInfo)
        return;
    
    NSString* shopId = [self.shopInfo objectForKey:key_shop_id];
    if (shopId && shopId.length > 0) {
        [SVProgressHUD show];
        [[APIManager sharedManager] getShopTimeWithShopId:shopId success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
#if DEBUG
            NSLog(@"Shop Time : %@", responseObject);
#endif
            
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                [self.shopInfo setValuesForKeysWithDictionary:responseObject];
                [self.shopTimeTableView reloadData];
            }
            
            [SVProgressHUD dismiss];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
#if DEBUG
            NSLog(@"Shop Time Error : %@", [error localizedDescription]);
#endif
            [SVProgressHUD dismiss];
        }];
    }
}

@end
