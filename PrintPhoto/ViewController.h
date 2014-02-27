//
//  ViewController.h
//  PrintPhoto
//
//  Created by Mayank on 12/07/13.
//  Copyright (c) 2013 Mati. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIPopoverControllerDelegate>{
    
    __weak IBOutlet UIButton *selectImageCapture;
    __weak IBOutlet UIButton *selectImageCameraRoll;
    UIButton *captureButton;
    UIImagePickerController *picker;
    NSInteger timeLeft;

}
@property(nonatomic, strong)UIImage* image;
@property(nonatomic, strong)UIPopoverController *popover;

- (IBAction)selectimageCaptureTapped:(id)sender;
- (IBAction)selectImageCameraRollTapped:(id)sender;

@end
