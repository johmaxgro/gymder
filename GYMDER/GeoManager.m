//
//  GeoManager.m
//  GYMDER
//
//  Created by Johannes Groschopp on 08.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import "GeoManager.h"
#import "BubbleContent.h"
@import Quickblox;

@implementation GeoManager

CLGeocoder *geocoder;
CLPlacemark *placemark;
int counter;
int userNumber;
BubbleContent *bubbleContent;

@synthesize locationManager = _locationManager;

-(void)startLocationUpdate{
//    _allGeoObjects = [NSMutableArray new];
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
    
    // Start heading updates.
    
    if ([CLLocationManager headingAvailable]) {
        
        _locationManager.headingFilter = 5;
        
        [_locationManager startUpdatingHeading];
        
    }

}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    //NSLog(@"New Heading: %@", newHeading);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    NSLog(@"distance to old location: %f", [oldLocation distanceFromLocation:newLocation]);
    
    NSMutableDictionary *userInformation = [NSMutableDictionary new];
    [userInformation setValue:newLocation forKey:@"ownLocation"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OwnGeodata" object:self userInfo:userInformation];
    
    [self newGeoDataWithCurrentLocation:newLocation];
    
    
    if (newLocation != nil && [oldLocation distanceFromLocation:newLocation] > 0.3) {
        
        _currentUserLocation = newLocation;
        [self usersAround:newLocation andPage:1];
        
    }else  if(_initialized){
        _initialized = NO;
        _currentUserLocation = newLocation;
        [self usersAround:newLocation andPage:1];
    }
    
    if(oldLocation == nil){
        
        _currentUserLocation = newLocation;
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
  
   
    
    filter.radius = 10.0;
    
    NSLog(@"At position lat: %f", newLocation.coordinate.latitude);
    NSLog(@"At position long: %f", newLocation.coordinate.longitude);
    
    [QBRequest geoDataWithFilter:filter page:[QBGeneralResponsePage responsePageWithCurrentPage:page perPage:100]
                    successBlock:^(QBResponse *response, NSArray *objects, QBGeneralResponsePage *page) {
                        // Successful response with page information and geodata array
                        
                        NSLog(@"Found %lu%@", (unsigned long)[objects count], @" Geo Objects");
                        
                        if([objects count] == 0){
                           
                        }
                        
                        for(int i = 0; i < [objects count]; i++){
                
                            QBLGeoData *userObject = [objects objectAtIndex:i];
                            if(userObject.userID != [QBSession currentSession].currentUser.ID && ![_allGeoObjects containsObject:userObject]){
                                
                            
                            NSLog(@"User around: %lu", (unsigned long)userObject.userID);
                            NSLog(@"Distance to user: %f", [userObject.location distanceFromLocation:newLocation]);
                            
                                [_allGeoObjects addObject:userObject];
                                
                            }
                            
                            userNumber += objects.count;
                            if (page.totalEntries > userNumber) {
                                [self usersAround:newLocation andPage:page.currentPage + 1];
                            }
                            
                            if(i == [objects count]-1){
                                [self insertToBubbleContent];
                            }

                        }
                        
                        
                        

                        
                        
                    } errorBlock:^(QBResponse *response) {
                        // Handle error
                        NSLog(@"Nothing found :(");
                    }];


}

-(void)insertToBubbleContent{
    NSLog(@"Call insertToBubbleContent. Number of geoobjects count: %lu", (unsigned long)[_allGeoObjects count]);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Geodata" object:nil];
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


@end
