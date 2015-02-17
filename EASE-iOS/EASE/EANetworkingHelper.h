//
//  EANetworkingHelper.h
//  EASE
//
//  Created by Aladin TALEB on 12/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import <Wit.h>
#import "EAWorkflow.h"

@protocol EANetworkingHelperDelegate <NSObject>

@end

@interface EANetworkingHelper : NSObject <WitDelegate>
{
    EAWorkflow *workflow;
}

@property(nonatomic, weak) id <EANetworkingHelperDelegate> delegate;

+ (EANetworkingHelper *)sharedHelper;

-(void)witProcessed:(NSString*)string completionBlock:(void (^)(NSDictionary* results, NSError* error))completionBlock;

-(void)searchForWorkflowsWithConstraints:(NSDictionary*)constraints completionBlock:(void (^) (NSArray* workflows, NSError* error))completionBlock;

@end
