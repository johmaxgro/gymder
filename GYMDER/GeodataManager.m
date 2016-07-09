//
//  GeodataManager.m
//  GYMDER
//
//  Created by Johannes Groschopp on 08.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import "GeodataManager.h"
#import "BubbleContent.h"
@import Quickblox;

@interface GeodataManager (){

CLGeocoder *geocoder;
CLPlacemark *placemark;
int counter;
int userNumber;
BubbleContent *bubbleContent;
    
}

@end

@implementation GeodataManager

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startLocationUpdate{
    bubbleContent = [_bubblesVC getBubbleContent];
    geocoder = [[CLGeocoder alloc] init];
    if (_locationManager == nil)
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        _locationManager.delegate = self;
        // Set a movement threshold for new events.
        _locationManager.distanceFilter = 50; // meters
        NSLog(@"Location Manager initialized.");
    }
    [_locationManager requestWhenInUseAuthorization];
    
    //    if ([self.locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)]) {
    //        [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    //    }
    [_locationManager startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    NSLog(@"distance to old location: %f", [oldLocation distanceFromLocation:newLocation]);
    [self newGeoDataWithCurrentLocation:newLocation];
    
    
    if (newLocation != nil && [oldLocation distanceFromLocation:newLocation] > 0.1) {
        
        [self usersAround:newLocation andPage:1];
        
    }
    
    if(oldLocation == nil){
        [self usersAround:newLocation andPage:1];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    
}


// Quickblox

-(void)usersAround:(CLLocation*)newLocation andPage:(NSUInteger)page{
    NSLog(@"counter: %d", counter++);
    
    QBLGeoDataFilter *filter = [[QBLGeoDataFilter alloc] init];
    
    filter.currentPosition = newLocation.coordinate;
    
    filter.radius = 1.0;
    
    NSLog(@"At position lat: %f", newLocation.coordinate.latitude);
    NSLog(@"At position long: %f", newLocation.coordinate.longitude);
    
    [QBRequest geoDataWithFilter:filter page:[QBGeneralResponsePage responsePageWithCurrentPage:page perPage:100]
                    successBlock:^(QBResponse *response, NSArray *objects, QBGeneralResponsePage *page) {
                        // Successful response with page information and geodata array
                        
                        if([objects count] == 0){
                            
                        }
                        
                        for(int i = 0; i < [objects count]; i++){
                            QBLGeoData *userObject = [objects objectAtIndex:i];
                            NSLog(@"User around: %lu", (unsigned long)userObject.userID);
                            NSLog(@"Distance to user: %f", [userObject.location distanceFromLocation:newLocation]);
                            
                            [self insertToBubbleContent:userObject];
                            
                            userNumber += objects.count;
                            if (page.totalEntries > userNumber) {
                                [self usersAround:newLocation andPage:page.currentPage + 1];
                            }
                            
                        }
                        
                        
                        
                    } errorBlock:^(QBResponse *response) {
                        // Handle error
                        NSLog(@"Nothing found :(");
                    }];
    
    
}

-(void)insertToBubbleContent:(QBLGeoData*)geoData{
    NSLog(@"Call insertToBubbleContent");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Geodata" object:nil];
    [bubbleContent setUserID:geoData.userID];
    [bubbleContent createBubble];
    [_bubblesVC test];
}

-(void)newGeoDataWithCurrentLocation:(CLLocation*)currentLocation{
    NSLocale* currentLocale = [NSLocale currentLocale];
    [[NSDate date] descriptionWithLocale:currentLocale];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    QBLGeoData *geodata = [QBLGeoData geoData];
    geodata.latitude = currentLocation.coordinate.latitude;
    geodata.longitude = currentLocation.coordinate.longitude;
    geodata.status = [dateFormatter stringFromDate:[NSDate date]];
    geodata.userID = [QBSession currentSession].currentUser.ID;
    [self updateGeoDataIfNeeded:geodata];
}

-(void)updateGeoDataIfNeeded:(QBLGeoData*)geodata{
    
    [QBRequest updateGeoData:geodata successBlock:^(QBResponse *response, QBLGeoData *geoData) {
        // Successful response with page information and geodata array
    } errorBlock:^(QBResponse *response) {
        // Handle error
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
