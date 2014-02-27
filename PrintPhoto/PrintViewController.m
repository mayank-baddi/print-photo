//
//  PrintViewController.m
//  PrintPhoto
//
//  Created by Mayank on 12/07/13.
//  Copyright (c) 2013 Mati. All rights reserved.
//

#import "PrintViewController.h"

@interface PrintViewController ()

@end

@implementation PrintViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    originalImageView.image = _originalImage;
}

-(IBAction)printTap:(id)sender{
    [self printPhotoWithImage:_originalImage];
}

-(void)printPhotoWithImage:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    NSData *myData = UIImageJPEGRepresentation(image, 1.f);
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    
    if (pic && [UIPrintInteractionController canPrintData:myData]) {
        
        pic.delegate = self;
        UIPrintInfo *pinfo = [UIPrintInfo printInfo];
        pinfo.outputType = UIPrintInfoOutputPhoto;
        pinfo.jobName = @"My Photo";
        pinfo.duplex = UIPrintInfoDuplexLongEdge;
        
        pic.printInfo = pinfo;
        pic.showsPageRange = YES;
        pic.printingItem = myData;
        
        
        void(^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *print, BOOL completed, NSError *error) {
            
            [self resignFirstResponder];
            
            if (!completed && error) {
                NSLog(@"--- print error! ---");
            }
            else{
                NSLog(@"comple");
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        };
        
        [pic presentFromRect:CGRectMake((self.view.bounds.size.width - 64) + 27, (self.view.bounds.size.height - 16) + 55, 0, 0) inView:self.view animated:YES completionHandler:completionHandler];
    }
}

- (UIPrintPaper *)printInteractionController:(UIPrintInteractionController *)printInteractionController choosePaper:(NSArray *)paperList {
    
    CGSize pageSize = CGSizeMake(6 * 72, 4 * 72); return [UIPrintPaper bestPaperForPageSize:pageSize withPapersFromArray:paperList];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
