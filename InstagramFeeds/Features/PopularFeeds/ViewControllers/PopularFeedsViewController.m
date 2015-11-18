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
#import <InstagramKit/InstagramEngine.h>
#import <SVPullToRefresh/SVPullToRefresh.h>
#import <AMScrollingNavbar/UIViewController+ScrollingNavbar.h>

#import "Runtime.h"
#import "MediaCollectionViewCell.h"
#import "HeaderSectionCollectionReusableView.h"
/*============================================================================
 PRIVATE CONSTANTS
 =============================================================================*/

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@interface PopularFeedsViewController ()

// views
@property (weak, nonatomic) IBOutlet UICollectionView *mediasCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

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
    
    // load Instagram feed if already logged in.
    if ([Runtime sharedRuntime].instagramToken) {
        [self loadInstagramFeeds];
    }
}

- (void)setUpUI{
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
}

- (void)loadInstagramFeeds{
    
        __weak typeof(self) weakSelf = self;
        [[InstagramEngine sharedEngine] getPopularMediaWithSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
            
            [self.medias addObjectsFromArray:media];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mediasCollectionView.pullToRefreshView stopAnimating];
                [self.mediasCollectionView.infiniteScrollingView stopAnimating];
                [self.mediasCollectionView reloadData];
            });
            
        } failure:^(NSError *error) {
            [weakSelf handlerError:error];
        }];
    
}


- (void)refresh{
    [self.medias removeAllObjects];
    [self.mediasCollectionView reloadData];
    self.mediasCollectionView.infiniteScrollingView.enabled = YES;
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
    
    MediaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MediaCollectionViewCell" forIndexPath:indexPath];
    [cell displayMedia:self.medias[indexPath.section]];
    
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
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.width + 50); // 5 top padding + 40 height + 5 bottom padding
}

#pragma mark IBActions
- (IBAction)didTouchedOnLoginButton:(UIButton *)sender {
    [[InstagramEngine sharedEngine] loginWithBlock:^(NSError *error) {
        if (!error) {
            // save Instagram toke
            [Runtime sharedRuntime].instagramToken = [InstagramEngine sharedEngine].accessToken;
            [self loadInstagramFeeds];
        }else {
            [self handlerError:error];
        }
    }];
}


@end
