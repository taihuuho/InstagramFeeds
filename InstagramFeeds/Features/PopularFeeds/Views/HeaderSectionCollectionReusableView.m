/*============================================================================
 PROJECT: InstagramFeeds
 FILE:    HeaderSectionCollectionReusableView.m
 AUTHOR:  Tai Huu Ho
 DATE:    11/18/15
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "HeaderSectionCollectionReusableView.h"
#import <InstagramKit/InstagramKit.h>
#import <UIImageView+WebCache.h>
#import "Utils.h"
/*============================================================================
 PRIVATE CONSTANTS
 =============================================================================*/

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/
@interface HeaderSectionCollectionReusableView ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@end

@implementation HeaderSectionCollectionReusableView

- (void)displayAuthorOfItem:(InstagramMedia *)item{
    InstagramMedia *media = (InstagramMedia*)item;
    [self.photoImageView sd_setImageWithURL:media.user.profilePictureURL];
    self.authorLabel.text = media.user.fullName.length > 0 ? [NSString stringWithFormat:@"%@(%@)", media.user.fullName, media.user.username] : media.user.username;
    
    self.likeCountLabel.text = [Utils formatStringLikeCount:media.likesCount];
}
@end
