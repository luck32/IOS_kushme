//
//  CropSendViewController.h
//  kushme
//
//  Created by Nicolas Rostov on 15/5/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CropSendViewController : UIViewController

@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) UIImage *croppedImage;
@property CGRect cropRect;

@end
