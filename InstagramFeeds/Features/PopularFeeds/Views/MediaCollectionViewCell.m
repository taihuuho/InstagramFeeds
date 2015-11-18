/*============================================================================
 PROJECT: InstagramFeeds
 FILE:    MediaCollectionViewCell.m
 AUTHOR:  Tai Huu Ho
 DATE:    11/17/15
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "MediaCollectionViewCell.h"
#import <InstagramKit/InstagramKit.h>
#import <UIImageView+WebCache.h>
#import "AppDelegate.h"
/*============================================================================
 PRIVATE CONSTANTS
 =============================================================================*/

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@interface MediaCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

- (IBAction)didTouchedOnPlayButton:(UIButton *)sender;
@end

@implementation MediaCollectionViewCell
-(void)displayMedia:(InstagramMedia *)media{
    [self.photoImageView sd_setImageWithURL:media.standardResolutionImageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    self.captionLabel.text = media.caption.text;
    
    if (media.isVideo) {
        NSLog(@"video");
    }
}

- (IBAction)didTouchedOnRepostButton:(UIButton *)sender {
    // open Instagram Repost
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"instagram://"]]) {
        
        NSData *imageData = UIImagePNGRepresentation(self.photoImageView.image);
        NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"/InstaSave.igo"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath isDirectory:nil]) {
            [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
        }
        
        [imageData writeToFile:imagePath atomically:YES];
        
        NSURL *igImageHookFile = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"file://%@", imagePath]];
        UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: igImageHookFile];
        
        interactionController.UTI = @"com.instagram.exclusivegram";
        interactionController.annotation = @{@"InstagramCaption":@"Share from InstagramFeeds"};
        
        [interactionController presentOptionsMenuFromRect:sender.frame inView:self animated:YES];
        
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirm" message:@"You need to install Instagram in order to repost" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [alert addAction:ok];
        
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [appDelegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    
}
- (IBAction)didTouchedOnPlayButton:(UIButton *)sender {
}
@end
