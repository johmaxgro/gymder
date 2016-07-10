//
//  WorkoutsViewController.m
//  GYMDER
//
//  Created by Johannes Groschopp on 12.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import "WorkoutsViewController.h"
#import "EditProfileViewController.h"
#import "ProfileViewController.h"
@import Quickblox;

@interface WorkoutsViewController (){
    NSMutableDictionary *tickedWorkouts;
    QBCOCustomObject *currentWorkoutsObject;
    int numberOfWorkouts;
    NSMutableArray *currentWorkouts;
}

@end

@implementation WorkoutsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    tickedWorkouts = [NSMutableDictionary new];
    currentWorkouts = [_workouts mutableCopy];
    
    numberOfWorkouts = (int)[_workouts count];
    
    [self setGestureReckognizers];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width/2, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"CHOOSE YOUR WORKOUTS";
    label.font=[label.font fontWithSize:20];
    label.font = [UIFont fontWithName:@"ClanOffcPro-Ultra" size:20];
    self.navigationItem.titleView = label;
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Button"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];

    self.navigationItem.leftBarButtonItem=newBackButton;

    
}

-(void)viewDidLayoutSubviews{
    _hardcoreView.layer.cornerRadius = _hardcoreView.frame.size.width/2;
    _hiitView.layer.cornerRadius = _hiitView.frame.size.width/2;
    _combatView.layer.cornerRadius = _combatView.frame.size.width/2;
    _liftView.layer.cornerRadius = _liftView.frame.size.width/2;
    _spinView.layer.cornerRadius = _spinView.frame.size.width/2;
    _bootcampView.layer.cornerRadius = _bootcampView.frame.size.width/2;
    _equipmentView.layer.cornerRadius = _equipmentView.frame.size.width/2;
    _runView.layer.cornerRadius = _runView.frame.size.width/2;
    _teamView.layer.cornerRadius = _teamView.frame.size.width/2;
    _crossfitView.layer.cornerRadius = _crossfitView.frame.size.width/2;
    _cardioView.layer.cornerRadius = _cardioView.frame.size.width/2;
    _danceView.layer.cornerRadius = _danceView.frame.size.width/2;
    _bodyweightView.layer.cornerRadius = _bodyweightView.frame.size.width/2;
    _fatburnView.layer.cornerRadius = _fatburnView.frame.size.width/2;
    _pilatesView.layer.cornerRadius = _pilatesView.frame.size.width/2;
    _freeView.layer.cornerRadius = _freeView.frame.size.width/2;
    _walkView.layer.cornerRadius = _walkView.frame.size.width/2;
    _yogaView.layer.cornerRadius = _yogaView.frame.size.width/2;
}

-(void)viewDidAppear:(BOOL)animated{
    [self setChosenWorkouts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)setGestureReckognizers{
    UITapGestureRecognizer *hardcoreTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    hardcoreTap.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *hiitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    hiitTap.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *combatTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    combatTap.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *liftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    liftTap.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *spinTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    spinTap.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *bootcampTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    bootcampTap.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *equipmentcampTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    equipmentcampTap.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *runTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    runTap.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *teamTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    teamTap.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *crossfitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    crossfitTap.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *cardioTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    cardioTap.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *danceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    danceTap.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *bodyweightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    bodyweightTap.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *fatburnTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    fatburnTap.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *pilatesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    pilatesTap.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *freeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    pilatesTap.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *walkTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    pilatesTap.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *yogaTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    pilatesTap.numberOfTapsRequired = 1;
    
    [_hardcoreView setTag:1];
    [_hardcoreView addGestureRecognizer:hardcoreTap];
    
    [_hiitView setTag:2];
    [_hiitView addGestureRecognizer:hiitTap];
    
    [_combatView setTag:3];
    [_combatView addGestureRecognizer:combatTap];
    
    [_liftView setTag:4];
    [_liftView addGestureRecognizer:liftTap];
    
    [_spinView setTag:5];
    [_spinView addGestureRecognizer:spinTap];
    
    [_bootcampView setTag:6];
    [_bootcampView addGestureRecognizer:bootcampTap];
    
    [_equipmentView setTag:7];
    [_equipmentView addGestureRecognizer:equipmentcampTap];
    
    [_runView setTag:8];
    [_runView addGestureRecognizer:runTap];
    
    [_teamView setTag:9];
    [_teamView addGestureRecognizer:teamTap];
    
    [_crossfitView setTag:10];
    [_crossfitView addGestureRecognizer:crossfitTap];
    
    [_cardioView setTag:11];
    [_cardioView addGestureRecognizer:cardioTap];
    
    [_danceView setTag:12];
    [_danceView addGestureRecognizer:danceTap];
    
    [_bodyweightView setTag:13];
    [_bodyweightView addGestureRecognizer:bodyweightTap];
    
    [_fatburnView setTag:14];
    [_fatburnView addGestureRecognizer:fatburnTap];
    
    [_pilatesView setTag:15];
    [_pilatesView addGestureRecognizer:pilatesTap];
    
    [_freeView setTag:16];
    [_freeView addGestureRecognizer:freeTap];
    
    [_walkView setTag:17];
    [_walkView addGestureRecognizer:walkTap];
    
    [_yogaView setTag:18];
    [_yogaView addGestureRecognizer:yogaTap];

}

-(void)setChosenWorkouts{
    for(int i = 0; i < [_workouts count]; i++){
        NSString *current = [_workouts objectAtIndex:i];
        if([current isEqualToString:@"hardcore"]){
            [self setWorkoutAsMarked:_hardcoreView];
        }
        else if ([current isEqualToString:@"hiit"]){
            [self setWorkoutAsMarked:_hiitView];
        }
        else if ([current isEqualToString:@"combat"]){
            [self setWorkoutAsMarked:_combatView];
        }
        else if ([current isEqualToString:@"lift"]){
            [self setWorkoutAsMarked:_liftView];
        }
        else if ([current isEqualToString:@"spin"]){
            [self setWorkoutAsMarked:_spinView];
        }
        else if ([current isEqualToString:@"bootcamp"]){
            [self setWorkoutAsMarked:_bootcampView];
        }
        else if ([current isEqualToString:@"equipment"]){
            [self setWorkoutAsMarked:_equipmentView];
        }
        else if ([current isEqualToString:@"run"]){
            [self setWorkoutAsMarked:_runView];
        }
        else if ([current isEqualToString:@"team"]){
            [self setWorkoutAsMarked:_teamView];
        }
        else if ([current isEqualToString:@"crossfit"]){
            [self setWorkoutAsMarked:_crossfitView];
        }
        else if ([current isEqualToString:@"cardio"]){
            [self setWorkoutAsMarked:_cardioView];
        }
        else if ([current isEqualToString:@"dance"]){
            [self setWorkoutAsMarked:_danceView];
        }
        else if ([current isEqualToString:@"bodyweight"]){
            [self setWorkoutAsMarked:_bodyweightView];
        }
        else if ([current isEqualToString:@"fatburn"]){
            [self setWorkoutAsMarked:_fatburnView];
        }
        else if ([current isEqualToString:@"pilates"]){
            [self setWorkoutAsMarked:_pilatesView];
        }
        else if ([current isEqualToString:@"free"]){
            [self setWorkoutAsMarked:_freeView];
        }
        else if ([current isEqualToString:@"walk"]){
            [self setWorkoutAsMarked:_walkView];
        }
        else if ([current isEqualToString:@"yoga"]){
            [self setWorkoutAsMarked:_yogaView];
        }

    }
}

-(void)setWorkoutAsMarked:(UIView*)viewOfWorkout{
    
    if(![tickedWorkouts objectForKey:[NSString stringWithFormat:@"%@", viewOfWorkout]]){
        NSLog(@"Add tick");
        UIImageView *tickHolder = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(viewOfWorkout.frame)-(viewOfWorkout.frame.size.width/2.5), CGRectGetMaxY(viewOfWorkout.frame)+(viewOfWorkout.frame.size.height/2.3), 20, 15)];
        [tickHolder setContentMode:UIViewContentModeScaleAspectFit];
        UIImage *tick = [UIImage imageNamed:@"WORKOUTS TICK.png"];
        [tickHolder setImage:tick];
        
        [self.view addSubview:tickHolder];
        [tickedWorkouts setObject:tickHolder forKey:[NSString stringWithFormat:@"%@", viewOfWorkout]];
        
        
    }else{
        [[self.view.subviews objectAtIndex:[self.view.subviews indexOfObject:[tickedWorkouts objectForKey:[NSString stringWithFormat:@"%@", viewOfWorkout]]]] removeFromSuperview];
        [tickedWorkouts removeObjectForKey:[NSString stringWithFormat:@"%@", viewOfWorkout]];
        
    }
}

// Get the tap on imageview on scrollview and open the corresponding profile after...

-(void)tapDetected:(UIGestureRecognizer *)gesture{
    NSLog(@"single Tap on imageview %ld", gesture.view.tag);
    NSLog(@"Image view: %@", gesture.view);
    [self removeStandardWorkoutPhraseIfNeeded];
    
    switch (gesture.view.tag) {
        case 1:
            //Load up content to database...
            if(![self workoutsArrayContainsWorkout:@"hardcore"]){
                if([self notTooManyWorkouts]){
                    [self setWorkoutAsMarked:gesture.view];
                    [self updateWorkout:@"hardcore"];
                }else{
                    [self showAlertTooMany];
                }
            }else{
                [self setWorkoutAsMarked:gesture.view];
                [self removeWorkout:@"hardcore"];
            }
            break;
        case 2:
            if(![self workoutsArrayContainsWorkout:@"hiit"]){
                if([self notTooManyWorkouts]){
                    [self setWorkoutAsMarked:gesture.view];
                    [self updateWorkout:@"hiit"];
                }else{
                    [self showAlertTooMany];
                }
            }else{
                [self setWorkoutAsMarked:gesture.view];
                [self removeWorkout:@"hiit"];
            }
            break;
        case 3:
            if(![self workoutsArrayContainsWorkout:@"combat"]){
                if([self notTooManyWorkouts]){
                    [self setWorkoutAsMarked:gesture.view];
                    [self updateWorkout:@"combat"];
                }else{
                    [self showAlertTooMany];
                }
            }else{
                [self setWorkoutAsMarked:gesture.view];
                [self removeWorkout:@"combat"];
            }
            break;
        case 4:
            if(![self workoutsArrayContainsWorkout:@"lift"]){
                if([self notTooManyWorkouts]){
                    [self setWorkoutAsMarked:gesture.view];
                    [self updateWorkout:@"lift"];
                }else{
                    [self showAlertTooMany];
                }
            }else{
                [self setWorkoutAsMarked:gesture.view];
                [self removeWorkout:@"lift"];
            }
            break;
        case 5:
            if(![self workoutsArrayContainsWorkout:@"spin"]){
                if([self notTooManyWorkouts]){
                    [self setWorkoutAsMarked:gesture.view];
                    [self updateWorkout:@"spin"];
                }else{
                    [self showAlertTooMany];
                }
            }else{
                [self setWorkoutAsMarked:gesture.view];
                [self removeWorkout:@"spin"];
            }
            break;
        case 6:
            if(![self workoutsArrayContainsWorkout:@"bootcamp"]){
                if([self notTooManyWorkouts]){
                    [self setWorkoutAsMarked:gesture.view];
                    [self updateWorkout:@"bootcamp"];
                }else{
                    [self showAlertTooMany];
                }
            }else{
                [self setWorkoutAsMarked:gesture.view];
                [self removeWorkout:@"bootcamp"];
            }
            break;
        case 7:
            if(![self workoutsArrayContainsWorkout:@"equipment"]){
                if([self notTooManyWorkouts]){
                    [self setWorkoutAsMarked:gesture.view];
                    [self updateWorkout:@"equipment"];
                }else{
                    [self showAlertTooMany];
                }
            }else{
                [self setWorkoutAsMarked:gesture.view];
                [self removeWorkout:@"equipment"];
            }
            break;
        case 8:
            if(![self workoutsArrayContainsWorkout:@"run"]){
                if([self notTooManyWorkouts]){
                    [self setWorkoutAsMarked:gesture.view];
                    [self updateWorkout:@"run"];
                }else{
                    [self showAlertTooMany];
                }
            }else{
                [self setWorkoutAsMarked:gesture.view];
                [self removeWorkout:@"run"];
            }
            break;
        case 9:
            if(![self workoutsArrayContainsWorkout:@"team"]){
                if([self notTooManyWorkouts]){
                    [self setWorkoutAsMarked:gesture.view];
                    [self updateWorkout:@"team"];
                }else{
                    [self showAlertTooMany];
                }
            }else{
                [self setWorkoutAsMarked:gesture.view];
                [self removeWorkout:@"team"];
            }
            break;
        case 10:
            if(![self workoutsArrayContainsWorkout:@"crossfit"]){
                if([self notTooManyWorkouts]){
                    [self setWorkoutAsMarked:gesture.view];
                    [self updateWorkout:@"crossfit"];
                }else{
                    [self showAlertTooMany];
                }
            }else{
                [self setWorkoutAsMarked:gesture.view];
                [self removeWorkout:@"crossfit"];
            }
            break;
        case 11:
            if(![self workoutsArrayContainsWorkout:@"cardio"]){
                if([self notTooManyWorkouts]){
                    [self setWorkoutAsMarked:gesture.view];
                    [self updateWorkout:@"cardio"];
                }else{
                    [self showAlertTooMany];
                }
            }else{
                [self setWorkoutAsMarked:gesture.view];
                [self removeWorkout:@"cardio"];
            }
            break;
        case 12:
            if(![self workoutsArrayContainsWorkout:@"dance"]){
                if([self notTooManyWorkouts]){
                    [self setWorkoutAsMarked:gesture.view];
                    [self updateWorkout:@"dance"];
                }else{
                    [self showAlertTooMany];
                }
            }else{
                [self setWorkoutAsMarked:gesture.view];
                [self removeWorkout:@"dance"];
            }
            break;
        case 13:
            if(![self workoutsArrayContainsWorkout:@"bodyweight"]){
                if([self notTooManyWorkouts]){
                    [self setWorkoutAsMarked:gesture.view];
                    [self updateWorkout:@"bodyweight"];
                }else{
                    [self showAlertTooMany];
                }
            }else{
                [self setWorkoutAsMarked:gesture.view];
                [self removeWorkout:@"bodyweight"];
            }
            break;
        case 14:
            if(![self workoutsArrayContainsWorkout:@"fatburn"]){
                if([self notTooManyWorkouts]){
                    [self updateWorkout:@"fatburn"];
                }else{
                    [self showAlertTooMany];
                }
            }else{
                [self setWorkoutAsMarked:gesture.view];
                [self removeWorkout:@"fatburn"];
            }
            break;
        case 15:
            if(![self workoutsArrayContainsWorkout:@"pilates"]){
                if([self notTooManyWorkouts]){
                    [self setWorkoutAsMarked:gesture.view];
                    [self updateWorkout:@"pilates"];
                }else{
                    [self showAlertTooMany];
                }
            }else{
                [self setWorkoutAsMarked:gesture.view];
                [self removeWorkout:@"pilates"];
            }
            break;
        case 16:
            if(![self workoutsArrayContainsWorkout:@"free"]){
                if([self notTooManyWorkouts]){
                    [self setWorkoutAsMarked:gesture.view];
                    [self updateWorkout:@"free"];
                }else{
                    [self showAlertTooMany];
                }
            }else{
                [self setWorkoutAsMarked:gesture.view];
                [self removeWorkout:@"free"];
            }
            break;
        case 17:
            if(![self workoutsArrayContainsWorkout:@"walk"]){
                if([self notTooManyWorkouts]){
                    [self setWorkoutAsMarked:gesture.view];
                    [self updateWorkout:@"walk"];
                }else{
                    [self showAlertTooMany];
                }
            }else{
                [self setWorkoutAsMarked:gesture.view];
                [self removeWorkout:@"walk"];
            }
            break;
        case 18:
            if(![self workoutsArrayContainsWorkout:@"yoga"]){
                if([self notTooManyWorkouts]){
                    [self setWorkoutAsMarked:gesture.view];
                    [self updateWorkout:@"yoga"];
                }else{
                    [self showAlertTooMany];
                }
            }else{
                [self setWorkoutAsMarked:gesture.view];
                [self removeWorkout:@"yoga"];
                
            }
            break;
            
        default:
            break;
    }
    
    [self rightBarBarButtonItem];
    
}

-(void)rightBarBarButtonItem{
    UIBarButtonItem *readyButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Tick"] style:UIBarButtonItemStyleDone target:self action:@selector(ready)];
    self.navigationItem.rightBarButtonItem=readyButton;
}

-(void)noRightBarButtonItem{
    self.navigationItem.rightBarButtonItem = nil;
}

-(void)removeStandardWorkoutPhraseIfNeeded{
    for(int i = 0; i < [currentWorkouts count]; i++){
        if([[currentWorkouts objectAtIndex:i] isEqualToString:@"Your Workout"]){
            [currentWorkouts removeObjectAtIndex:i];
        }
    }
}

-(BOOL)workoutsArrayContainsWorkout:(NSString*)workout{
    for(int i = 0; i < [currentWorkouts count]; i++){
        if([[currentWorkouts objectAtIndex:i] isEqualToString:workout]){
            return YES;
        }
    }
    return NO;
}

-(BOOL)notTooManyWorkouts{
    NSLog(@"Not too many workouts? %d", numberOfWorkouts);
    if(numberOfWorkouts < 6){
        return YES;
    }else{
        return NO;
    }
}

-(void)updateWorkout:(NSString*)workout{
    [self removeStandardWorkoutPhraseIfNeeded];
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    [getRequest setObject:[NSString stringWithFormat:@"%lu", (unsigned long)[QBSession currentSession].currentUser.ID] forKey:@"user_id"];
    numberOfWorkouts += 1;
    
    [QBRequest objectsWithClassName:@"UserProperties" extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // response processing
        currentWorkoutsObject = [objects objectAtIndex:0];
        //        NSMutableArray *workoutsOld = [[currentWorkoutsObject.fields objectForKey:@"workout"] mutableCopy];
        
        [currentWorkouts addObject:workout];
        
        [currentWorkoutsObject.fields setObject:currentWorkouts forKey:@"workout"];
        
        [QBRequest updateObject:currentWorkoutsObject successBlock:^(QBResponse *response, QBCOCustomObject *object) {
            // object updated
            
        } errorBlock:^(QBResponse *response) {
            // error handling
            NSLog(@"Response error: %@", [response.error description]);
        }];
        
        
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
    }];
    
    [_ownUserDataObject.userData setObject:currentWorkouts forKey:@"workouts"];
    
}

-(void)showAlertTooMany{
    // Already 9 workouts chosen...
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Sorry :-("
                                  message:@"Not more than 6 workouts are possible to choose."
                                  preferredStyle:UIAlertControllerStyleAlert];
    alert.view.tintColor = [UIColor blackColor];
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   
                               }];
    [alert addAction:okButton];
    //[alert setMessage:self.sharedManagerEN.login_error_message];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)removeWorkout:(NSString*)workoutToRemove{
    if([currentWorkouts containsObject:workoutToRemove]){
        [currentWorkouts removeObject:workoutToRemove];
        NSLog(@"Workouts new: %@", currentWorkouts);
        numberOfWorkouts -= 1;
        
        if([currentWorkouts count] == 0){
            [currentWorkouts addObject:@"Your Workout"];
        }
        NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
        [getRequest setObject:[NSString stringWithFormat:@"%lu", (unsigned long)[QBSession currentSession].currentUser.ID] forKey:@"user_id"];
        
        [QBRequest objectsWithClassName:@"UserProperties" extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
            // response processing
            currentWorkoutsObject = [objects objectAtIndex:0];
            
            [currentWorkoutsObject.fields setObject:currentWorkouts forKey:@"workout"];
            
            [QBRequest updateObject:currentWorkoutsObject successBlock:^(QBResponse *response, QBCOCustomObject *object) {
                // object updated
                
            } errorBlock:^(QBResponse *response) {
                // error handling
                NSLog(@"Response error: %@", [response.error description]);
            }];
            
            
            
        } errorBlock:^(QBResponse *response) {
            // error handling
            NSLog(@"Response error: %@", [response.error description]);
        }];
        
        
    }
}

-(void)ready{
    EditProfileViewController *editVC = [[self.navigationController childViewControllers] objectAtIndex:1];
    ProfileViewController *profileVC = [[self.navigationController childViewControllers] objectAtIndex:0];
    [editVC.circleArray removeAllObjects];
    NSLog(@"current workouts: %@", currentWorkouts);
  
        for(int i = 0; i < [currentWorkouts count]; i++){
            
            NSMutableDictionary *currentCircleContent = [NSMutableDictionary new];
            
            if([[currentWorkouts objectAtIndex:i] isEqualToString:@"hardcore"]){
                [currentCircleContent setObject:[UIColor colorWithRed:0.173f green:0.192f blue:0.208f alpha:1.00f] forKey:@"color"];
                [currentCircleContent setObject:@"HARD\nCORE" forKey:@"workout"];
            }
            else if([[currentWorkouts objectAtIndex:i] isEqualToString:@"hiit"]){
                [currentCircleContent setObject:[UIColor colorWithRed:0.204f green:0.196f blue:0.149f alpha:1.00f] forKey:@"color"];
                [currentCircleContent setObject:@"HIIT" forKey:@"workout"];
            }
            else if([[currentWorkouts objectAtIndex:i] isEqualToString:@"combat"]){
                [currentCircleContent setObject:[UIColor colorWithRed:0.204f green:0.169f blue:0.180f alpha:1.00f] forKey:@"color"];
                [currentCircleContent setObject:@"COM\nBAT" forKey:@"workout"];
            }
            else if([[currentWorkouts objectAtIndex:i] isEqualToString:@"lift"]){
                [currentCircleContent setObject:[UIColor colorWithRed:0.243f green:0.275f blue:0.286f alpha:1.00f] forKey:@"color"];
                [currentCircleContent setObject:@"LIFT" forKey:@"workout"];
            }
            else if([[currentWorkouts objectAtIndex:i] isEqualToString:@"spin"]){
                [currentCircleContent setObject:[UIColor colorWithRed:0.349f green:0.341f blue:0.259f alpha:1.00f] forKey:@"color"];
                [currentCircleContent setObject:@"SPIN" forKey:@"workout"];
            }
            else if([[currentWorkouts objectAtIndex:i] isEqualToString:@"bootcamp"]){
                [currentCircleContent setObject:[UIColor colorWithRed:0.282f green:0.247f blue:0.259f alpha:1.00f] forKey:@"color"];
                [currentCircleContent setObject:@"BOOT\nCAMP" forKey:@"workout"];
            }
            else if([[currentWorkouts objectAtIndex:i] isEqualToString:@"equipment"]){
                [currentCircleContent setObject:[UIColor colorWithRed:0.349f green:0.384f blue:0.400f alpha:1.00f] forKey:@"color"];
                [currentCircleContent setObject:@"EQUIP\nMENT" forKey:@"workout"];
            }
            else if([[currentWorkouts objectAtIndex:i] isEqualToString:@"run"]){
                [currentCircleContent setObject:[UIColor colorWithRed:0.494f green:0.494f blue:0.373f alpha:1.00f] forKey:@"color"];
                [currentCircleContent setObject:@"RUN" forKey:@"workout"];
            }
            else if([[currentWorkouts objectAtIndex:i] isEqualToString:@"team"]){
                [currentCircleContent setObject:[UIColor colorWithRed:0.400f green:0.353f blue:0.369f alpha:1.00f] forKey:@"color"];
                [currentCircleContent setObject:@"TEAM" forKey:@"workout"];
            }
            else if([[currentWorkouts objectAtIndex:i] isEqualToString:@"crossfit"]){
                [currentCircleContent setObject:[UIColor colorWithRed:0.424f green:0.467f blue:0.486f alpha:1.00f] forKey:@"color"];
                [currentCircleContent setObject:@"CROSS\nFIT" forKey:@"workout"];
            }
            else if([[currentWorkouts objectAtIndex:i] isEqualToString:@"cardio"]){
                [currentCircleContent setObject:[UIColor colorWithRed:0.647f green:0.631f blue:0.482f alpha:1.00f] forKey:@"color"];
                [currentCircleContent setObject:@"CAR\nDIO" forKey:@"workout"];
            }
            else if([[currentWorkouts objectAtIndex:i] isEqualToString:@"dance"]){
                [currentCircleContent setObject:[UIColor colorWithRed:0.475f green:0.416f blue:0.439f alpha:1.00f] forKey:@"color"];
                [currentCircleContent setObject:@"DANCE" forKey:@"workout"];
            }
            else if([[currentWorkouts objectAtIndex:i] isEqualToString:@"bodyweight"]){
                [currentCircleContent setObject:[UIColor colorWithRed:0.502f green:0.573f blue:0.596f alpha:1.00f] forKey:@"color"];
                [currentCircleContent setObject:@"BODY\nWEIGHT" forKey:@"workout"];
            }
            else if([[currentWorkouts objectAtIndex:i] isEqualToString:@"fatburn"]){
                [currentCircleContent setObject:[UIColor colorWithRed:0.796f green:0.792f blue:0.584f alpha:1.00f] forKey:@"color"];
                [currentCircleContent setObject:@"FAT\nBURN" forKey:@"workout"];
            }
            else if([[currentWorkouts objectAtIndex:i] isEqualToString:@"pilates"]){
                [currentCircleContent setObject:[UIColor colorWithRed:0.608f green:0.522f blue:0.553f alpha:1.00f]forKey:@"color"];
                [currentCircleContent setObject:@"PILA\nTES" forKey:@"workout"];
            }
            else if([[currentWorkouts objectAtIndex:i] isEqualToString:@"free"]){
                [currentCircleContent setObject:[UIColor colorWithRed:0.600f green:0.659f blue:0.682f alpha:1.00f]forKey:@"color"];
                [currentCircleContent setObject:@"FREE" forKey:@"workout"];
            }
            else if([[currentWorkouts objectAtIndex:i] isEqualToString:@"walk"]){
                [currentCircleContent setObject:[UIColor colorWithRed:0.894f green:0.878f blue:0.659f alpha:1.00f]forKey:@"color"];
                [currentCircleContent setObject:@"WALK" forKey:@"workout"];
            }
            else if([[currentWorkouts objectAtIndex:i] isEqualToString:@"yoga"]){
                [currentCircleContent setObject:[UIColor colorWithRed:0.682f green:0.604f blue:0.624f alpha:1.00f]forKey:@"color"];
                [currentCircleContent setObject:@"YOGA" forKey:@"workout"];
            }
            [editVC.circleArray addObject:currentCircleContent];
            
        }
    
    [editVC clearCircles];
    editVC.workouts = [currentWorkouts mutableCopy];
    [profileVC.ownUserData setValue:currentWorkouts forKey:@"workouts"];
    [profileVC clearCicles];
    [profileVC setWorkoutCircles:[profileVC.ownUserData objectForKey:@"workouts"]];
    [self.navigationController popViewControllerAnimated:YES];

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
