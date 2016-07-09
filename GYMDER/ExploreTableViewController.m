//
//  ExploreTableViewController.m
//  GYMDER
//
//  Created by Johannes Groschopp on 07.07.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import "ExploreTableViewController.h"
#import "ExploreTableViewCellNormal.h"
#import "ExploreTableViewCellBigLeft.h"
#import "ExploreTableViewCellBigRight.h"
@import Quickblox;

@interface ExploreTableViewController (){
    CGFloat screenWidth;
    NSMutableArray *imagesArray;
    NSMutableDictionary *images;
    NSMutableArray *objectIDs;
    int count;

}

@end

@implementation ExploreTableViewController

static NSString * const reuseIdentifierNormal = @"normalCell";
static NSString * const reuseIdentifierLeftBig = @"leftBigCell";
static NSString * const reuseIdentifierRightBig = @"rightBigCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    imagesArray = [NSMutableArray new];
    images = [NSMutableDictionary new];
    objectIDs = [NSMutableArray new];
    screenWidth = [UIScreen mainScreen].bounds.size.width;

}

-(void)viewDidAppear:(BOOL)animated{
    [self randomFeeds];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_exploreContent count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return screenWidth/3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QBCOCustomObject *current = [_exploreContent objectAtIndex:indexPath.row];
    ExploreTableViewCellNormal *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifierNormal];
    if(count == 0){
        [self imageToCell:current.ID andCellImageView:cell.leftImage andCellPath:indexPath.row andCell:cell];
    }
    if(count == 1){
        [self imageToCell:current.ID andCellImageView:cell.middleImage andCellPath:indexPath.row andCell:cell];
    }
    if(count == 2){
        [self imageToCell:current.ID andCellImageView:cell.rightImage andCellPath:indexPath.row andCell:cell];
        count = 0;
    }
    
    // Configure the cell...
    
    count += 1;
    return cell;
}

-(UITableViewCell*)cellForPowsCount:(int)pows{
    if(pows > 30){
        ExploreTableViewCellBigLeft* cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifierLeftBig];
        return cell;
    }else{
        ExploreTableViewCellNormal *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifierNormal];
        return cell;
    }
}

-(void)objectIDs:(NSArray*)objects{
    for(int i = 0; i < [objects count]; i++){
        QBCOCustomObject *current = [objects objectAtIndex:i];
        [objectIDs addObject:current.ID];
    }
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
            [self objectIDs:objects];

            [self.tableView reloadData];

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
    [self.tableView reloadData];
}


-(void)imageToCell:(NSString*)objectID andCellImageView:(UIImageView*)imageView andCellPath:(NSInteger)cellPath andCell:(UITableViewCell*)cell{
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
