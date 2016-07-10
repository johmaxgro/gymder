//
//  ExploreWaterFallViewController.m
//  GYMDER
//
//  Created by Johannes Groschopp on 07.07.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

//
//  ViewController.m
//  Demo
//
//  Created by Nelson on 12/11/27.
//  Copyright (c) 2012年 Nelson. All rights reserved.
//
// --> Free of charge

#import "ExploreWaterFallViewController.h"
#import "CHTCollectionViewWaterfallCell.h"
#import "CHTCollectionViewWaterfallHeader.h"
#import "CHTCollectionViewWaterfallFooter.h"

@import Quickblox;

#define CELL_COUNT 30
#define CELL_IDENTIFIER @"WaterfallCell"
#define HEADER_IDENTIFIER @"WaterfallHeader"
#define FOOTER_IDENTIFIER @"WaterfallFooter"

@interface ExploreWaterFallViewController (){
    int count;
    CGFloat screenWidth;

}
@property (nonatomic, strong) NSArray *cellSizes;
@property (nonatomic, strong) NSArray *cats;
@property (strong, nonatomic) NSMutableArray *imagesArray;
@property (strong, nonatomic) NSMutableDictionary *images;
@property (strong, nonatomic) NSMutableArray *usedIndexPaths;
@property (nonatomic) CGFloat lastContentOffset;

@end

@implementation ExploreWaterFallViewController

#pragma mark - Accessors

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.headerHeight = 15;
        layout.footerHeight = 10;
        layout.minimumColumnSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BACKGROUND.jpg"]];
        [_collectionView registerClass:[CHTCollectionViewWaterfallCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
        [_collectionView registerClass:[CHTCollectionViewWaterfallHeader class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                   withReuseIdentifier:HEADER_IDENTIFIER];
        [_collectionView registerClass:[CHTCollectionViewWaterfallFooter class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter
                   withReuseIdentifier:FOOTER_IDENTIFIER];
    }
    return _collectionView;
}

- (NSArray *)cellSizes {
    if (!_cellSizes) {
//        _cellSizes = @[
//                       [NSValue valueWithCGSize:CGSizeMake(400, 550)],
//                       [NSValue valueWithCGSize:CGSizeMake(1000, 665)],
//                       [NSValue valueWithCGSize:CGSizeMake(1024, 689)],
//                       [NSValue valueWithCGSize:CGSizeMake(640, 427)]
//                       ];
                _cellSizes = @[
                               [NSValue valueWithCGSize:CGSizeMake(400, 550)],
                               [NSValue valueWithCGSize:CGSizeMake(1000, 665)],
                               [NSValue valueWithCGSize:CGSizeMake(1024, 689)],
                               [NSValue valueWithCGSize:CGSizeMake(640, 427)]
                               ];
    }
    return _cellSizes;
}

// From the source code --> just for testing
- (NSArray *)cats {
    if (!_cats) {
        _cats = @[@"boys girls.jpg", @"boys girls.jpg", @"boys girls.jpg", @"boys girls.jpg"];
    }
    return _cats;
}

#pragma mark - Life Cycle

- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    _exploreContent = [NSMutableArray new];
    _imagesArray = [NSMutableArray new];
    _images = [NSMutableDictionary new];
    _usedIndexPaths = [NSMutableArray new];
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    self.collectionView.alwaysBounceVertical = YES;
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = [UIColor grayColor];
    [_refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:_refreshControl];


}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateLayoutForOrientation:[UIApplication sharedApplication].statusBarOrientation];
    [self randomFeeds];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.lastContentOffset > scrollView.contentOffset.y)
    {
        NSLog(@"Scrolling Up");
        _exploreVC.searchView.hidden = NO;
        [_exploreVC searchViewShow];

    }
    else if (self.lastContentOffset < scrollView.contentOffset.y)
    {
        NSLog(@"Scrolling Down");
        _exploreVC.searchView.hidden = YES;
        [_exploreVC searchViewHidden];
        [_exploreVC keyBoardAway];
    }
    
    self.lastContentOffset = scrollView.contentOffset.y;
}

- (void)reloadData
{
    // Reload table data
    [self deleteAndRefreshCollectionView];
    // End the refreshing
    if (_refreshControl) {
        [_refreshControl endRefreshing];
    }
}

-(void)deleteAndRefreshCollectionView{
    [_exploreContent removeAllObjects];
    [_usedIndexPaths removeAllObjects];
    [_imagesArray removeAllObjects];
    [_images removeAllObjects];
    [self randomFeeds];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateLayoutForOrientation:toInterfaceOrientation];
}

- (void)updateLayoutForOrientation:(UIInterfaceOrientation)orientation {
    CHTCollectionViewWaterfallLayout *layout =
    (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    layout.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return CELL_COUNT;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Cell index path: %ld", (long)indexPath.item);
    CHTCollectionViewWaterfallCell *cell =
    (CHTCollectionViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                                forIndexPath:indexPath];
    NSLog(@"Used? %d", [self currentIndexPathNotAlreadyUsed:indexPath.item] ? YES:NO);
    if([_exploreContent count] != 0 && ![self currentIndexPathNotAlreadyUsed:indexPath.item]){
        QBCOCustomObject *current = [_exploreContent objectAtIndex:indexPath.item];
        [self imageToCell:current.ID andCellImageView:cell.imageView andCellPath:indexPath.item andCell:cell];
        [_usedIndexPaths addObject:[NSString stringWithFormat:@"%ld", indexPath.item]];
    }
    
    UITapGestureRecognizer *cellTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellTap:)];
    cellTap.cancelsTouchesInView = NO;
    cellTap.numberOfTapsRequired = 1;
    cell.tag = indexPath.item;
    [cell addGestureRecognizer:cellTap];
    cell.userInteractionEnabled = YES;
    cell.contentView.userInteractionEnabled = YES;
    cell.imageView.userInteractionEnabled = YES;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:HEADER_IDENTIFIER
                                                                 forIndexPath:indexPath];
    } else if ([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:FOOTER_IDENTIFIER
                                                                 forIndexPath:indexPath];
    }
    
    return reusableView;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Selected: %ld", (long)indexPath.item);
}

-(void)cellTap:(UIGestureRecognizer *)gestureRecognizer {
//    UIView *tappedView = [gestureRecognizer.view hitTest:[gestureRecognizer locationInView:gestureRecognizer.view] withEvent:nil];
//    NSLog(@"Tapped cell: %ld", gestureRecognizer.view.tag);
    
    // do something with it
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return [self.cellSizes[indexPath.item % 4] CGSizeValue];
    return [self.cellSizes[indexPath.item % 2] CGSizeValue];

}

-(BOOL)currentIndexPathNotAlreadyUsed:(NSInteger)indexPathItem{
    for(int i = 0; i < [_usedIndexPaths count]; i++){
        if([[_usedIndexPaths objectAtIndex:i] integerValue] == indexPathItem){
            return YES;
        }
    }
    return NO;
}


// TODO: Not only the last 30 pictures, but also more when scrolled...
// Is in process...

-(void)randomFeeds{
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    [getRequest setObject:@(30) forKey:@"limit"];
    
    [QBRequest objectsWithClassName:@"Share" extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // response processing
        NSLog(@"RANDOM FEEDS count: %lu", (unsigned long)[objects count]);
        if([_exploreContent count] == 0){
            _exploreContent = [objects mutableCopy];
            NSLog(@"RANDOM Feeds empty");
            [self.collectionView reloadData];
           // [self downloadImages];
        }else{
            for(int i = 0; i < [objects count]; i++){
                if(![_exploreContent containsObject:[objects objectAtIndex:i]]){
                    [_exploreContent addObject:[objects objectAtIndex:i]];
                    
                   [self.collectionView reloadData];
                    // [self updateCollectionView];
                    NSLog(@"%@", [NSString stringWithFormat:@"%@%@%@", @"FEED ", [objects objectAtIndex:i], @"will be added"]);
                }else{
                    NSLog(@"%@", [NSString stringWithFormat:@"%@%@%@", @"FEED ", [objects objectAtIndex:i], @"already in array"]);
                }
            }
        }
        //        [self printRandomFeeds:randomFeeds];
        NSLog(@"Random feeds after dowmload: %lu", (unsigned long)[_exploreContent count]);
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
    }];
}

-(void)downloadImages{
    QBCOCustomObject *feed;
    for(int i = 0 ; i < [_exploreContent count]; i++){
        feed = [_exploreContent objectAtIndex:i];
        [QBRequest downloadFileFromClassName:@"Share" objectID:feed.ID fileFieldName:@"image"
                                successBlock:^(QBResponse *response, NSData *loadedData) {
                                    // file downloaded
                                    
                                    if(loadedData != nil){
                                        
                                        UIImage *feedImage = [UIImage imageWithData:loadedData];
                                        
                                        if(feedImage != nil){
                                            
                                            [_imagesArray addObject:feedImage];
                                            
                                        }
                                        
                                    }
                                } statusBlock:^(QBRequest *request, QBRequestStatus *status) {
                                    // handle progress
                                    NSLog(@"Process feed image: %f", status.percentOfCompletion);
                                } errorBlock:^(QBResponse *error) {
                                    // error handling
                                    NSLog(@"Response error download: %@", [error description]);
                                }];
        
    }
    [_collectionView reloadData];
}


-(void)imageToCell:(NSString*)objectID andCellImageView:(UIImageView*)imageView andCellPath:(NSInteger)cellPath andCell:(UICollectionViewCell*)cell{
    NSLog(@"Requesting for image download... %@", objectID);
    [QBRequest downloadFileFromClassName:@"Share" objectID:objectID fileFieldName:@"image"
                            successBlock:^(QBResponse *response, NSData *loadedData) {
                                // file downloaded
                                
                                if(loadedData != nil){
                                    
                                    UIImage *feedImage = [UIImage imageWithData:loadedData];
                                    
                                    if(feedImage != nil){

                                        NSLog(@"Image downloaded... %@", feedImage);
                                        NSLog(@"Image added to cell %ld", (long)cellPath);
                                        [imageView setImage:feedImage];
                                        [_images setObject:feedImage forKey:[NSString stringWithFormat:@"%ld", (long)cellPath]];
                                        [imageView setContentMode:UIViewContentModeScaleAspectFill];
                                        imageView.clipsToBounds = YES;
                   
                                        NSLog(@"Test image: %@", cell.subviews);
                                        
                                    }
                                    
                                }
                            } statusBlock:^(QBRequest *request, QBRequestStatus *status) {
                                // handle progress
                                NSLog(@"Process feed image: %f", status.percentOfCompletion);
                            } errorBlock:^(QBResponse *error) {
                                // error handling
                                NSLog(@"Response error download: %@", [error description]);
                            }];
    
}


@end
