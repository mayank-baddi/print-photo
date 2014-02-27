//
//  ViewController.m
//  PrintPhoto
//
//  Created by Mayank on 12/07/13.
//  Copyright (c) 2013 Mati. All rights reserved.
//

#import "ViewController.h"
#import "PrintViewController.h"
#import "Correctorientation.h"
#import <ImageIO/ImageIO.h>
@interface ViewController ()

@end

@implementation ViewController

@synthesize image;
#pragma mark View Life Cycle
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
    //setting the background of UIView
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default"]]];
    [selectImageCameraRoll setBackgroundImage:[[UIImage imageNamed:@"blue_box"] resizableImageWithCapInsets:UIEdgeInsetsMake(20,20,20,20)] forState:UIControlStateNormal];
    [selectImageCapture setBackgroundImage:[[UIImage imageNamed:@"pink_box"] resizableImageWithCapInsets:UIEdgeInsetsMake(20,20,20,20)] forState:UIControlStateNormal];
    
    image = [[UIImage alloc]init];
    
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}


#pragma mark Button Functions
- (IBAction)selectimageCaptureTapped:(id)sender {
    // Set up the image picker controller and add it to the view
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        picker= [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        picker.allowsEditing = NO;
        self.popover = [[UIPopoverController alloc]
                        initWithContentViewController:picker];
        self.popover.delegate = self;
        picker.showsCameraControls = NO;
        

        [self.popover presentPopoverFromRect:CGRectMake(0,0,170,250) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        CGRect frame = picker.view.frame;
        UIView *cameraControlsView = [[UIView alloc] initWithFrame:frame];
        
        frame.origin.y = frame.size.height - 40;
        frame.size.height = 40;
        NSInteger width = 80;
        frame.origin.x = (frame.size.width-width)/2;
        frame.size.width = width;
        
        captureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        captureButton.frame = frame;
        [captureButton setTitle:@"Capture" forState:UIControlStateNormal];
        [captureButton addTarget:self action:@selector(buttonPressed:)
                forControlEvents:UIControlEventTouchUpInside];
        picker.cameraOverlayView = cameraControlsView;
        
        [picker.view addSubview:cameraControlsView];

    }
    else{
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        picker.allowsEditing = NO;
        picker.showsCameraControls = NO;
        
        CGRect frame = picker.view.frame;
        UIView *cameraControlsView = [[UIView alloc] initWithFrame:frame];
        
        frame.origin.y = frame.size.height - 40;
        frame.size.height = 40;
        NSInteger width = 80;
        frame.origin.x = (frame.size.width-width)/2;
        frame.size.width = width;
        
        captureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        captureButton.frame = frame;
        [captureButton setTitle:@"Capture" forState:UIControlStateNormal];
        [captureButton addTarget:self action:@selector(buttonPressed:)
                forControlEvents:UIControlEventTouchUpInside];
        [cameraControlsView addSubview:captureButton];
        
        picker.cameraOverlayView = cameraControlsView;
        
        [self.navigationController presentViewController:picker animated:YES completion:nil];
    }
}

- (IBAction)selectImageCameraRollTapped:(id)sender {
    // Set up the image picker controller and add it to the view
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        picker= [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = NO;
        self.popover = [[UIPopoverController alloc]
                        initWithContentViewController:picker];
        self.popover.delegate = self;
        [self.popover presentPopoverFromRect:CGRectMake(0,0,170,250) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else{
        picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = NO;
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self.navigationController presentViewController:picker animated:YES completion:nil];
    }
}
- (void)buttonPressed:(id)sender {
    timeLeft = 3;
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self
                                   selector:@selector(changeLabel:) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self
                                   selector:@selector(timerFired:) userInfo:nil repeats:NO];
    captureButton.enabled = NO;
}

- (void)timerFired:(NSTimer *)timer {
    [picker takePicture];
    captureButton.enabled = YES;
}

- (void)changeLabel:(NSTimer *)timer{
    timeLeft --;
    [captureButton setTitle:[NSString stringWithFormat:@"capture(%d)",timeLeft] forState:UIControlStateNormal];
    if(timeLeft ==0){
        [timer invalidate];
        [captureButton setTitle:@"capture" forState:UIControlStateNormal];
    }
}

-(void)imagePickerController:(UIImagePickerController *)_picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    

    //Dismiss the image selection, hide the picker and
    //show the image view with the picked image
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.image = img;
    NSLog(@"%@",info);
    [_picker dismissViewControllerAnimated:YES completion:nil];
//    [self performSegueWithIdentifier:@"print" sender:self];
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"gg_gps" ofType:@"jpg"];
//    NSURL *imageFileURL = [NSURL fileURLWithPath:path];
//    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)CFBridgingRetain(imageFileURL), NULL);
    
//    Using CGImageProperties to get EXIF properties
    NSData *jpeg = UIImageJPEGRepresentation(img,1.0);
    
    CGImageSourceRef  source = CGImageSourceCreateWithData((__bridge CFDataRef)jpeg, NULL);
    NSDictionary *metadata = (__bridge NSDictionary *) CGImageSourceCopyPropertiesAtIndex(source,0,NULL);
    
    NSMutableDictionary *metadataAsMutable = [metadata mutableCopy];
    
    NSMutableDictionary *EXIFDictionary = [metadataAsMutable objectForKey:(NSString *)kCGImagePropertyExifApertureValue];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], (NSString *)kCGImageSourceShouldCache, nil];

    CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(source, 0, (CFDictionaryRef)CFBridgingRetain(options));

    CFDictionaryRef exifDic = CFDictionaryGetValue(imageProperties, kCGImagePropertyExifAuxLensInfo);

                                            
    
    [self.popover dismissPopoverAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"print"]){
        PrintViewController *pvc = (PrintViewController *)[segue destinationViewController];
        pvc.originalImage = [Correctorientation scaleAndRotateImage:image];

    }
}
@end
