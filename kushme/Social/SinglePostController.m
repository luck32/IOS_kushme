//
//  SinglePostController.m
//  kushme
//
//  Created by Nicolas Rostov on 22/5/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "SinglePostController.h"
#import "APIManager.h"
#import "CommentViewController.h"
#import "UserProfileController.h"

@interface SinglePostController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (nonatomic, strong) NSArray *comments;

-(IBAction)likeAction:(id)sender;

@end

@implementation SinglePostController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *headerView = self.tableView.tableHeaderView;
    CGFloat addHeight = headerView.frame.size.height - self.imageView.frame.size.height;
    headerView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.width+addHeight);
    self.tableView.tableHeaderView = headerView;
    
    self.nameLabel.text = nil;
    self.timeLabel.text = nil;
    self.likesLabel.text = nil;
    
    self.likeButton.backgroundColor = [UIColor lightGrayColor];
    self.likeButton.layer.cornerRadius = 4;
    self.likeButton.layer.borderWidth = 1;
    self.likeButton.layer.borderColor = [[UIColor clearColor] CGColor];
    self.commentButton.backgroundColor = TINT_COLOR;
    self.commentButton.layer.cornerRadius = 4;
    self.commentButton.layer.borderWidth = 1;
    self.commentButton.layer.borderColor = [[UIColor clearColor] CGColor];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showPictureData];
    [self reloadPictureData];
    [self reloadComments];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

-(void)reloadPictureData {
    [[APIManager sharedManager] getPicture:[self.postData[key_post_pic_id] intValue]
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       if([responseObject isKindOfClass:[NSDictionary class]]) {
                                           self.postData = [NSDictionary dictionaryWithDictionary:responseObject];
                                           [self showPictureData];
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                   }];
}

-(void)reloadComments {
    [[APIManager sharedManager] getCommentsForPicture:[self.postData[key_post_pic_id] intValue]
                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                  if([responseObject isKindOfClass:[NSArray class]]) {
                                                      self.comments = [NSArray arrayWithArray:responseObject];
                                                  }
                                                  [self.tableView reloadData];
                                                  [SVProgressHUD dismiss];
                                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                  [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                              }];
}

-(void)showPictureData {
    if([self.postData[key_user_name] isKindOfClass:[NSString class]]) {
        self.nameLabel.text = self.postData[key_user_name];
    }
    else {
        self.nameLabel.text = @"Unknown user";
    }
    if([self.postData[key_user_picture] isKindOfClass:[NSString class]]) {
        NSString *userPicUrl = [self.postData[key_user_picture] stringByRemovingPercentEncoding];
        [self.imageView setImageWithURL:[NSURL URLWithString:userPicUrl]];
    }
    if([self.postData[key_post_date_diff] isKindOfClass:[NSString class]]) {
        self.timeLabel.text = [NSString stringWithFormat:@"%@ days ago", self.postData[key_post_date_diff]];
    }
    if([self.postData[key_post_likes] isKindOfClass:[NSString class]]) {
        self.likesLabel.text = [NSString stringWithFormat:@"%@", self.postData[key_post_likes]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSAttributedString*)commentTextForComment:(NSDictionary*)commentDic {
    NSString *name = ([commentDic[key_user_name] isKindOfClass:[NSString class]])?commentDic[key_user_name]:@"";
    NSString *commentText = [NSString stringWithFormat:@"%@: %@", name, commentDic[key_comment_text]];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:commentText];
    [text addAttributes:@{NSForegroundColorAttributeName: TINT_COLOR} range:NSMakeRange(0, [name length]+1)];
    [text addAttributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]} range:NSMakeRange([name length]+1, [commentDic[key_comment_text] length]+1)];
    return text;
}

-(IBAction)likeAction:(id)sender {
    [SVProgressHUD show];
    [[APIManager sharedManager] likePicture:[self.postData[key_post_pic_id] intValue]
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        [self reloadPictureData];
                                        [SVProgressHUD showInfoWithStatus:responseObject[@"message"]];
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *commentDic = self.comments[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.attributedText = [self commentTextForComment:commentDic];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *sizingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-30, 1024)];
    sizingLabel.numberOfLines = 0;
    NSDictionary *commentDic = self.comments[indexPath.row];
    sizingLabel.attributedText = [self commentTextForComment:commentDic];
    [sizingLabel sizeToFit];
    return sizingLabel.frame.size.height+32;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:Segue_Comment]) {
        CommentViewController *comentController = [segue destinationViewController];
        comentController.pictureData = self.postData;
    }
    else if([segue.identifier isEqualToString:Segue_ShowUserProfile]) {
        UserProfileController *userController = [segue destinationViewController];
        if([sender isKindOfClass:[UITableViewCell class]]) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            NSDictionary *commentDic = self.comments[indexPath.row];
            userController.user_id = [commentDic[key_user_id] intValue];
        }
        else if([sender isKindOfClass:[UIButton class]]) {
            userController.user_id = [self.postData[key_post_user_id] intValue];
        }
    }
}


@end
