//
//  iOS_Share.mm
//
//  Created by Nicholas Sheehan on 01/06/2018.
//

#import "iOS_Share.h"

//
// Shares Text
//
void shareText(const char* shareText)
{
    shareScreenshotAndText(shareText, "");
}

//
// Shares Screenshot and Text
//
void shareScreenshotAndText(const char* shareText, const char* imagePath)
{
    NSString *textToShare = [NSString stringWithUTF8String:shareText];
    NSString *pathToImage = [NSString stringWithUTF8String:imagePath];
    
    NSMutableArray *items = [NSMutableArray new];
    
	//Check to see if string is empty or null
    if(textToShare != NULL && textToShare.length > 0) [items addObject:textToShare];
    
	//Check to see if string is empty or null
    if(pathToImage != NULL && pathToImage.length > 0)
    {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        
		//Check to see if the file exists
        if([fileMgr fileExistsAtPath:pathToImage])
        {
            NSURL *formattedURL = [NSURL fileURLWithPath:pathToImage];
            [items addObject:formattedURL];
        }
		//File not found
        else
        {
            char* alertTitle = (char*)"Error";
            NSString *message = [NSString stringWithFormat:@"Cannot find file %@", pathToImage];
            char* alertMessage = (char*)[message UTF8String];
            char* alertDismissButtonText = (char*)"OK";
            
			//Show Alert
            showAlert(alertTitle, alertMessage, alertDismissButtonText);
        }
    }
    
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:Nil];
    [activity setValue:@"" forKey:@"subject"];
    
    UIViewController *rootViewController = UnityGetGLViewController();

    //iPhone share view
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
      [rootViewController presentViewController:activity animated:YES completion:nil];
    }
    //iPad share view
    else
    {
		//custom area to show the share popup
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activity];
        [popup presentPopoverFromRect:CGRectMake(rootViewController.view.frame.size.width/2, rootViewController.view.frame.size.height/4, 0, 0)inView:rootViewController.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}
