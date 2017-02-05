//
//  ShopMenuViewController.m
//  kushme
//
//  Created by Yanny on 5/30/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "ShopMenuViewController.h"

@implementation ShopMenuCell

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


@implementation ShopMenuItemCell

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


@interface ShopMenuViewController ()

@property (weak, nonatomic) IBOutlet UITableView* shopMenuTableView;

@property (strong, nonatomic) NSMutableDictionary* shopMenus;
@property (strong, nonatomic) NSArray* orderedShopMenuNames;

@end

@implementation ShopMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"SHOP MENU";
    
    [self loadShopMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.orderedShopMenuNames count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    NSInteger rowCount = 1;
    
    NSString* shopMenuName = [self.orderedShopMenuNames objectAtIndex:section];
    NSMutableDictionary* shopMenuDict = [self.shopMenus objectForKey:shopMenuName];
    if (shopMenuDict) {
        if ([[shopMenuDict objectForKey:key_menu_expanded] boolValue]) {
            rowCount = 2;
            NSMutableArray* menuItems = [shopMenuDict objectForKey:key_menu_items];
            if (menuItems && [menuItems isKindOfClass:[NSArray class]])
                rowCount += menuItems.count;
        }
    }
    
    return rowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 30.f;
    if (indexPath.row == 0)
        height = 44.f;
    else if (indexPath.row == 1)
        height = 25.f;
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        ShopMenuCell *cell = (ShopMenuCell*)[tableView dequeueReusableCellWithIdentifier:@"ShopMenuCell" forIndexPath:indexPath];
        NSString* menuTypeName = [self.orderedShopMenuNames objectAtIndex:indexPath.section];
        cell.menuNameLabel.text = menuTypeName;
        return cell;
    }
    else if (indexPath.row == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopMenuItemInfoCell" forIndexPath:indexPath];
        cell.userInteractionEnabled = NO;
        return cell;
    }
    
    ShopMenuItemCell *cell = (ShopMenuItemCell*)[tableView dequeueReusableCellWithIdentifier:@"ShopMenuItemCell" forIndexPath:indexPath];
    cell.userInteractionEnabled = NO;
    
    NSString* shopMenuName = [self.orderedShopMenuNames objectAtIndex:indexPath.section];
    NSMutableDictionary* shopMenuDict = [self.shopMenus objectForKey:shopMenuName];
    if (shopMenuDict) {
        if ([[shopMenuDict objectForKey:key_menu_expanded] boolValue]) {
            NSMutableArray* menuItems = [shopMenuDict objectForKey:key_menu_items];
            if (menuItems && [menuItems isKindOfClass:[NSArray class]]) {
                NSDictionary* itemDict = [menuItems objectAtIndex:indexPath.row - 2];
                if (itemDict) {
                    cell.itemNameLabel.text = [UtilManager validateResponse:[itemDict objectForKey:key_item_name]];
                    cell.gInfoLabel.text = [UtilManager validateResponse:[itemDict objectForKey:key_g]];
                    cell.oneOfEightInfoLabel.text = [UtilManager validateResponse:[itemDict objectForKey:key_of_eight]];
                    cell.oneOfFourInfoLabel.text = [UtilManager validateResponse:[itemDict objectForKey:key_of_four]];
                    cell.oneOfTwoInfoLabel.text = [UtilManager validateResponse:[itemDict objectForKey:key_of_two]];
                    cell.ozInfoLabel.text = [UtilManager validateResponse:[itemDict objectForKey:key_oz]];
                }
            }
        }
    }
    
    
    return cell;
}

#pragma mark -
#pragma mark - UITableView delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row != 0)
        return;
    
    NSString* shopMenuName = [self.orderedShopMenuNames objectAtIndex:indexPath.section];
    NSMutableDictionary* shopMenuDict = [self.shopMenus objectForKey:shopMenuName];
    if (shopMenuDict) {
        BOOL expanded = [[shopMenuDict objectForKey:key_menu_expanded] boolValue];
        expanded = !expanded;
        [shopMenuDict setObject:[NSNumber numberWithBool:expanded] forKey:key_menu_expanded];
        
        [tableView reloadData];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Main methods

- (void)orderShopMenuNames {
    
    if (!self.shopMenus)
        return;
    
    self.orderedShopMenuNames = [self.shopMenus allKeys];
    self.orderedShopMenuNames = [self.orderedShopMenuNames sortedArrayUsingComparator:^NSComparisonResult(NSString* shopMenuName1, NSString* shopMenuName2) {
        return [shopMenuName1 compare:shopMenuName2];
    }];
}

- (void)loadShopMenu {
    if (!self.shopInfo)
        return;
    
    NSString* shopId = [self.shopInfo objectForKey:key_shop_id];
    if (shopId && shopId.length > 0) {
        
        self.shopMenus = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [SVProgressHUD show];
        [[APIManager sharedManager] getShopMenuWithShopId:shopId success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
#if DEBUG
            NSLog(@"Shop Menu : %@", responseObject);
#endif
            
            if (responseObject && [responseObject isKindOfClass:[NSArray class]]) {
                for (NSDictionary* menuDict in responseObject) {
                    if (menuDict && [menuDict isKindOfClass:[NSDictionary class]]) {
                        NSString* menuTypeName = [menuDict objectForKey:key_menu_type_name];
                        if (menuTypeName && [menuTypeName isKindOfClass:[NSString class]] && menuTypeName.length > 0) {
                            NSMutableDictionary* shopMenuDict = [self.shopMenus objectForKey:menuTypeName];
                            if (!shopMenuDict)
                                shopMenuDict = [NSMutableDictionary dictionaryWithCapacity:0];
                            
                            [shopMenuDict setObject:[NSNumber numberWithBool:NO] forKey:key_menu_expanded];
                            
                            NSMutableArray* menuItems = [shopMenuDict objectForKey:key_menu_items];
                            if (!menuItems)
                                menuItems = [NSMutableArray arrayWithCapacity:0];
                            [menuItems addObject:menuDict];
                            
                            [shopMenuDict setObject:menuItems forKey:key_menu_items];
                            
                            [self.shopMenus setObject:shopMenuDict forKey:menuTypeName];
                        }
                    }
                }
                
                [self orderShopMenuNames];
                
                [self.shopMenuTableView reloadData];
            }
            
            [SVProgressHUD dismiss];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
#if DEBUG
            NSLog(@"Shop Menu Error : %@", [error localizedDescription]);
#endif
            [SVProgressHUD dismiss];
        }];
    }
}


@end
