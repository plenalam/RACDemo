//
//  RACIndexController.m
//  RACDemo
//
//  Created by Plena on 2018/9/18.
//  Copyright © 2018年 Plena. All rights reserved.
//

#import "RACIndexController.h"
#import "RACSignalViewController.h"
#import "RACSubjectViewController.h"
#import "RACCommandViewController.h"
#import "RACTupleViewController.h"
#import "RACSchedulerViewController.h"
#import "CombinationViewController.h"
#import "TransformationViewController.h"
#import "FilterViewController.h"
#import "UtilityViewController.h"
#import "UIKitsViewController.h"
#import "SetOperatorsViewController.h"
#import "LoginViewController.h"
#import "AFNetworkingViewController.h"

@interface RACIndexController (){
    NSArray<NSArray *> * datasource;
}

@end

@implementation RACIndexController

- (void)viewDidLoad {
    [super viewDidLoad];
    datasource = @[@[@"RACSignal",@"RACSubject",@"RACCommand",@"RACTuple",@"RACScheduler"],
                   @[@"Transformation",@"Combination",@"Filter",@"Utility"],
                   @[@"UIKit",@"SetOperators",@"MVVM",@"AFNetworking"]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self navigationItem] setTitle:@"Index"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [datasource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[datasource objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    }
    [[cell textLabel]setText:[[datasource objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch ([indexPath section]) {
        case 0:{
            switch ([indexPath row]) {
                case 0:
                    [[self navigationController] pushViewController:[[RACSignalViewController alloc] init] animated:true ];
                    break;
                case 1:
                    [[self navigationController] pushViewController:[[RACSubjectViewController alloc] init] animated:true ];
                    break;
                case 2:
                    [[self navigationController] pushViewController:[[RACCommandViewController alloc] init] animated:true ];
                    break;
                case 3:
                    [[self navigationController] pushViewController:[[RACTupleViewController alloc] init] animated:true ];
                    break;
                case 4:
                    [[self navigationController] pushViewController:[[RACSchedulerViewController alloc] init] animated:true ];
                    break;
                default:
                    break;
            }
            break;
        }
        case 1:{
            switch ([indexPath row]) {
                case 0:
                    [[self navigationController] pushViewController:[[TransformationViewController alloc] init] animated:true ];
                    break;
                case 1:
                    [[self navigationController] pushViewController:[[CombinationViewController alloc] init] animated:true ];
                    break;
                case 2:
                    [[self navigationController] pushViewController:[[FilterViewController alloc] init] animated:true ];
                    break;
                case 3:
                    [[self navigationController] pushViewController:[[UtilityViewController alloc] init] animated:true ];
                    break;
                default:
                    break;
            }
            break;
        }
        case 2:{
            switch ([indexPath row]) {
                case 0:
                    [[self navigationController] pushViewController:[[UIKitsViewController alloc] init] animated:true ];
                    break;
                case 1:
                    [[self navigationController] pushViewController:[[SetOperatorsViewController alloc] init] animated:true ];
                    break;
                case 2:
                    [[self navigationController] pushViewController:[[LoginViewController alloc] init] animated:true ];
                    break;
                case 3:
                    [[self navigationController] pushViewController:[[AFNetworkingViewController alloc] init] animated:true ];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Basis";
        case 1:
            return @"Operators";
        case 2:
            return @"Usage";
        default:
            break;
    }
    return @"";
}
@end
