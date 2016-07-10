//
//  ExploreCollectionViewController.m
//  GYMDER
//
//  Created by Johannes Groschopp on 03.07.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import "ExploreCollectionViewController.h"
#import "ExploreCollectionViewCell.h"
#import "RFQuiltLayout.h"
#import "CHTCollectionViewWaterfallLayout.h"

@import Quickblox;

@interface ExploreCollectionViewController ()<UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>{
    NSIndexPath *indexPathLast;
    NSMutableDictionary *images;
    CGFloat screenWidth;
    NSMutableArray *imagesArray;
}

@end

@implementation ExploreCollectionViewController

static NSString * const reuseIdentifier = @"exploreCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[ExploreCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
    _exploreContent = [NSMutableArray new];
    images = [NSMutableDictionary new];
    imagesArray = [NSMutableArray new];
    
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BACKGROUND.png"]];
    
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    indexPathLast = 0;
    
//    RFQuiltLayout* layout = (id)[self.collectionView collectionViewLayout];
//    layout.direction = UICollectionViewScrollDirectionVertical;
//    layout.blockPixels = CGSizeMake(100, 100);
//    
//    [self.collectionView reloadData];
    
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10); //set spacing from edge of screen, 10px from each edge
    layout.minimumColumnSpacing = 10; // space between columns
    layout.minimumInteritemSpacing = 10; // space between rows
    
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
  

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [self randomFeeds];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (CGSize) blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0)
        return CGSizeMake(2, 1);
    
    return CGSizeMake(1, 2);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"%lu%@", (unsigned long)[_exploreContent count], @" feeds to download");
    return [_exploreContent count];
}


- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    QBCOCustomObject *currentFeed = [_exploreContent objectAtIndex:indexPath.row];
    NSLog(@"Collection View Pows: %@", [currentFeed.fields objectForKey:@"pows"]);
    if([[currentFeed.fields objectForKey:@"pows"] intValue] > 4){
        return CGSizeMake(screenWidth*0.666666, screenWidth*0.666666);
    }else{
        return CGSizeMake(screenWidth/3, screenWidth/3);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ExploreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"exploreCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    indexPathLast = indexPath;
    NSLog(@"Creating explore cell... %ld", (long)indexPath.row);

    [self configCell:cell byIndexPath:indexPath.row];
    
    cell.layer.cornerRadius = cell.frame.size.width*0.2;
    
    // Configure the cell
    
    return cell;
}

//- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"CELLLL");
//    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor redColor];
//    
//    UILabel* label = (id)[cell viewWithTag:5];
//    if(!label) label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
//    label.tag = 5;
//    label.textColor = [UIColor blackColor];
//    label.text = @"HAllo";
//    label.backgroundColor = [UIColor clearColor];
//    [cell addSubview:label];
//    
//    return cell;
//}

-(void)configCell:(ExploreCollectionViewCell*)cell byIndexPath:(NSInteger)path{
    
    if([imagesArray count] != 0 && (path < [imagesArray count])){
        NSLog(@"Config cell...: %@", [imagesArray objectAtIndex:(int)path]);
    UIImageView *cellImage = [[UIImageView alloc]initWithFrame:cell.frame];
    cellImage.image = [imagesArray objectAtIndex:(int)path];
    [cell addSubview:cellImage];
    cellImage.layer.cornerRadius = cellImage.frame.size.width*0.2;
    cellImage.contentMode = UIViewContentModeScaleAspectFill;
    cellImage.clipsToBounds = YES;
    }
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

-(void)updateCollectionView{
    [self.collectionView performBatchUpdates:^{
        NSLog(@"RELOAAAAAAD");
        // [self.collectionView reloadItemsAtIndexPaths:@[ indexPathForUpdate ]];
        [self.collectionView insertItemsAtIndexPaths:@[ indexPathLast ]];
        //[collectionView deleteSections:[NSIndexSet indexSetWithIndex:0]];
    } completion:^(BOOL finished) {
        // Called async when all animations are finished; finished = NO if cancelled
    }];
}

-(void)randomFeeds{
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    [getRequest setObject:@(30) forKey:@"limit"];
    //[self printRandomFeeds:randomFeeds];
    
    [QBRequest objectsWithClassName:@"Share" extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // response processing
        NSLog(@"RANDOM FEEDS count: %lu", (unsigned long)[objects count]);
        if([_exploreContent count] == 0){
            _exploreContent = [objects mutableCopy];
            NSLog(@"RANDOM Feeds empty");
//            [self.collectionView reloadData];
            [self downloadImages];
        }else{
            for(int i = 0; i < [objects count]; i++){
                if(![_exploreContent containsObject:[objects objectAtIndex:i]]){
                    [_exploreContent addObject:[objects objectAtIndex:i]];
                    
                    //                [self.collectionView reloadData];
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
                                            
                                            [imagesArray addObject:feedImage];
                                            
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
    [self.collectionView reloadData];
}


-(void)imageToCell:(NSString*)objectID andCellImageView:(UIImageView*)imageView andCellPath:(NSInteger)cellPath andCell:(ExploreCollectionViewCell*)cell{
    NSLog(@"Requesting for image download...");
    [QBRequest downloadFileFromClassName:@"Share" objectID:objectID fileFieldName:@"image"
                            successBlock:^(QBResponse *response, NSData *loadedData) {
                                // file downloaded
                                
                                if(loadedData != nil){
                                    
                                    UIImage *feedImage = [UIImage imageWithData:loadedData];
                                    
                                    if(feedImage != nil){
                                        UIImageView *cellImage = [[UIImageView alloc]initWithFrame:cell.frame];
                                        cellImage.image = feedImage;
                                        [cell addSubview:cellImage];
                                        cellImage.layer.cornerRadius = cellImage.frame.size.width*0.2;
                                        cellImage.contentMode = UIViewContentModeScaleAspectFill;
                                        cellImage.clipsToBounds = YES;
                                        NSLog(@"Image downloaded... %@", feedImage);
                                        NSLog(@"Image added to cell %ld", (long)cellPath);
                                        [imageView setImage:feedImage];
                                        [images setObject:feedImage forKey:[NSString stringWithFormat:@"%ld", (long)cellPath]];
                                        [imageView setContentMode:UIViewContentModeScaleAspectFill];
//                                        [cell bringSubviewToFront:imageView];
//                                        cell.image.image = feedImage;
//                                        [cell.image setHidden:NO];
//                                        cell.backgroundColor = [UIColor colorWithPatternImage:feedImage];
//                                        cell.contentMode = UIViewContentModeScaleAspectFill;
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
