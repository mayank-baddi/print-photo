//
//  PrintViewController.h
//  PrintPhoto
//
//  Created by Mayank on 12/07/13.
//  Copyright (c) 2013 Mati. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrintViewController : UIViewController<UIPrintInteractionControllerDelegate>{
    IBOutlet UIImageView *originalImageView;
}
@property (nonatomic, strong)UIImage *originalImage;

-(IBAction)printTap:(id)sender;
@end
