/*============================================================================
 PROJECT: InstagramFeeds
 FILE:    PopularFeedsViewController.m
 AUTHOR:  Tai Huu Ho
 DATE:    11/17/15
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "PopularFeedsViewController.h"
#import <InstagramKit/InstagramKit.h>
#import <SVPullToRefresh/SVPullToRefresh.h>
#import <AMScrollingNavbar/UIViewController+ScrollingNavbar.h>
#import <ASMediaFocusManager/ASMediaFocusManager.h>

#import "Runtime.h"
#import "MediaCollectionViewCell.h"
#import "HeaderSectionCollectionReusableView.h"
#import "LoadingView.h"
/*============================================================================
 PRIVATE CONSTANTS
 =============================================================================*/

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@interface PopularFeedsViewController ()<ASMediasFocusDelegate>

// views
@property (weak, nonatomic) IBOutlet UICollectionView *mediasCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) ASMediaFocusManager *mediaFocusManager;

// data
@property (nonatomic)   NSMutableArray *medias;

// Private Methods
- (void)initData;
- (void)setUpUI;
- (void)loadInstagramFeeds;

- (void)refresh;
- (void)loadMore;

// IBActions
- (IBAction)didTouchedOnLoginButton:(UIButton *)sender;

@end


@interface PopularFeedsViewController ()

@end

@implementation PopularFeedsViewController

- (void)dealloc{
    [self setMedias:nil];
    [self setMediaFocusManager:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self setUpUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Private Methods

- (void)initData{
    self.medias = [NSMutableArray new];
    
}

- (void)setUpUI{
    // load Instagram feed if already logged in.
    if ([Runtime sharedRuntime].instagramToken) {
        self.loginButton.hidden = YES;
        self.mediasCollectionView.hidden = NO;
        [self refresh];
    }else{
        self.loginButton.hidden = NO;
        self.mediasCollectionView.hidden = YES;
    }
    
    // colapse navigation bar when scrolling up
    [self followScrollView:self.mediasCollectionView usingTopConstraint:self.topConstraint];
    
    
    // pull to refresh
    [self.mediasCollectionView addPullToRefreshWithActionHandler:^{
        [self refresh];
    }];
    
    // pagination support
    [self.mediasCollectionView addInfiniteScrollingWithActionHandler:^{
        [self loadMore];
    }];
    
    self.mediaFocusManager = [[ASMediaFocusManager alloc] init];
    self.mediaFocusManager.delegate = self;
    self.mediaFocusManager.elasticAnimation = YES;
    self.mediaFocusManager.defocusOnVerticalSwipe = YES;
    
}

- (void)loadInstagramFeeds{
    
        [[InstagramEngine sharedEngine] getPopularMediaWithSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
            
            [self.medias addObjectsFromArray:media];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[LoadingView sharedInstance] stopLoading];
                [self.mediasCollectionView.pullToRefreshView stopAnimating];
                [self.mediasCollectionView.infiniteScrollingView stopAnimating];
                [self.mediasCollectionView reloadData];
            });
            
        } failure:^(NSError *error) {
            [[LoadingView sharedInstance] stopLoading];
            [self handlerError:error];
        }];
    
}


- (void)refresh{
    [self.medias removeAllObjects];
    [self.mediasCollectionView reloadData];
    self.mediasCollectionView.infiniteScrollingView.enabled = YES;
    
    [[LoadingView sharedInstance] startLoading];
    [self loadInstagramFeeds];
}

- (void)loadMore{
    [self loadInstagramFeeds];
}

#pragma mark UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    [collectionView.collectionViewLayout invalidateLayout];
    return self.medias.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    InstagramMedia *media = self.medias[indexPath.section];
    NSString *identifier = @"PhotoCollectionViewCell";
    if (media.isVideo) {
        identifier = @"VideoCollectionViewCell";
    }
    
    MediaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell displayMedia:media];
    
    cell.photoImageView.tag = indexPath.section;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mediaFocusManager installOnView:cell.photoImageView];
    });
    
    
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        HeaderSectionCollectionReusableView *header = (HeaderSectionCollectionReusableView*)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderSectionCollectionReusableView" forIndexPath:indexPath];
        if (indexPath.section < self.medias.count) {
            [header displayAuthorOfItem:self.medias[indexPath.section]];
        }
        
        return  header;
    }
    return nil;
}

#pragma mark UICollectionFlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.width + 50); // 5 top padding + 40 height of caption + 5 bottom padding
}

#pragma mark - ASMediaFocusDelegate
- (UIViewController *)parentViewControllerForMediaFocusManager:(ASMediaFocusManager *)mediaFocusManager
{
    return self.navigationController;
}
- (NSURL *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager mediaURLForView:(UIView *)view
{
    InstagramMedia *media = self.medias[view.tag];
    return media.isVideo ? media.standardResolutionVideoURL : media.standardResolutionImageURL;
}

- (NSString *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager titleForView:(UIView *)view;
{
    InstagramMedia *media = self.medias[view.tag];
    return media.caption.text;
}

#pragma mark IBActions
- (IBAction)didTouchedOnLoginButton:(UIButton *)sender {
    [[InstagramEngine sharedEngine] loginWithBlock:^(NSError *error) {
        if (!error) {
            // save Instagram toke
            [Runtime sharedRuntime].instagramToken = [InstagramEngine sharedEngine].accessToken;
            self.mediasCollectionView.hidden = NO;
            self.loginButton.hidden = YES;
            [self refresh];
        }else {
            [self handlerError:error];
        }
    }];
}


@end
