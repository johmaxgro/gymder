//
//  AppDelegate.m
//  GYMDER
//
//  Created by Johannes Groschopp on 05.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "Reachability.h"
@import Quickblox;


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [QBSettings setApplicationID:39230];
    [QBSettings setAuthKey:@"fZmnRvUk5aO5dM2"];
    [QBSettings setAuthSecret:@"whR8FMMV6sJ4Ds7"];
    [QBSettings setAccountKey:@"rzs9kKpPPK7VGc8uPz4w"];
    
    // Google Maps API initialization
    [GMSServices provideAPIKey:@"AIzaSyDqnzeWLXo4gvXqhrlLTXA6uFTBc9cxA2A"];
    
    // Initialize Reachability
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    // Start Monitoring
    [reachability startNotifier];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
    FBSDKAccessToken *token = [FBSDKAccessToken currentAccessToken];

        // Quickblox Facebbook Login
        [QBRequest logInWithSocialProvider:@"facebook" accessToken:token.tokenString accessTokenSecret:nil successBlock:^(QBResponse *response, QBUUser *user) {
            // Login succeded
            NSLog(@"Successfully logged in via Facebook");
            
        } errorBlock:^(QBResponse *response) {
            // Handle error
        }];
        

    
 

    
    
    return handled;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if([QBSession currentSession] != nil){
        QBUUser *currentUser = [QBSession currentSession].currentUser;
        currentUser.password = [QBSession currentSession].sessionDetails.token;
        [[QBChat instance] connectWithUser:[QBSession currentSession].currentUser  completion:^(NSError * _Nullable error) {
            
        }];
    }

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[QBChat instance] disconnectWithCompletionBlock:^(NSError * _Nullable error) {
        
    }];
}

@end
