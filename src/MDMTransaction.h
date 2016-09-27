/*
 Copyright 2016-present The Material Motion Authors. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <Foundation/Foundation.h>

@protocol MDMPlan;

/**
 The MDMTransaction class acts as a register of operations that may be committed to an instance of
 MDMScheduler.
 */
NS_SWIFT_NAME(Transaction)
@interface MDMTransaction : NSObject

#pragma mark Adding plans to a transaction

/**
Associates a plan with a given target.

@param plan The plan to add to this transaction.
@param target The target on which the plan can operate.
*/
- (void)addPlan:(nonnull id<MDMPlan>)plan
       toTarget:(nonnull id)target
  NS_SWIFT_NAME(add(plan:to:));

/**
 Associates a named plan with a given target.
 
 @param plan The plan to add to this transaction.
 @param target The target on which the plan can operate.
 @param name String identifier for the plan.
 */
- (void)addPlan:(nonnull id<MDMPlan>)plan
       toTarget:(nonnull id)target
       withName:(nonnull NSString *)name
  NS_SWIFT_NAME(add(plan:to:withName:));

/**
 Removes a named plan from the transaction.
 
 @param plan The plan to add to this transaction.
 @param target The target on which the plan can operate.
 @param name String identifier for the plan
 */
- (void)removePlanNamed:(nonnull NSString *)name
             fromTarget:(nonnull id)target
  NS_SWIFT_NAME(removePlan(named:from:));

@end
