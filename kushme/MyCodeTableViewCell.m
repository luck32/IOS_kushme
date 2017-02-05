//
//  MyCodeTableViewCell.m
//  kushme
//
//  Created by Nicolas Rostov on 15/5/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "MyCodeTableViewCell.h"

@interface MyCodeTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *viewGreenBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imageQRCode;
@property (weak, nonatomic) IBOutlet UILabel *labelUsername;

@end

@implementation MyCodeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.viewGreenBackground.backgroundColor = self.window.tintColor;
    self.viewGreenBackground.clipsToBounds = YES;
    self.viewGreenBackground.layer.cornerRadius = 6;
    self.viewGreenBackground.layer.borderWidth = 1;
    self.viewGreenBackground.layer.borderColor = [[UIColor clearColor] CGColor];
    
    self.labelUsername.text = nil;
    self.imageQRCode.image = nil;
    [self performSelector:@selector(showUserValues) withObject:nil afterDelay:0.1];
}

-(void)showUserValues {
    self.labelUsername.text = [[APIManager sharedManager] getUserCode];
    NSString *uidString = [[APIManager sharedManager] getUserCode];
    
    CIImage *qrCode = [self createQRForString:uidString];
    UIImage *qrCodeImg = [self createNonInterpolatedUIImageFromCIImage:qrCode withScale:self.imageQRCode.frame.size.height/qrCode.extent.size.height];
    self.imageQRCode.image = qrCodeImg;
}

- (CIImage *)createQRForString:(NSString *)qrString {
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    // Send the image back
    return qrFilter.outputImage;
}

- (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image withScale:(CGFloat)scale {
    // Render the CIImage into a CGImage
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:image fromRect:image.extent];
    
    // Now we'll rescale using CoreGraphics
    UIGraphicsBeginImageContext(CGSizeMake(image.extent.size.width * scale, image.extent.size.width * scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
    // We don't want to interpolate (since we've got a pixel-correct image)
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    // Get the image out
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // Tidy up
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    return scaledImage;
}

@end
