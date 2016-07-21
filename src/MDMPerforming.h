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

/**
 A class conforming to MDMPerforming is expected to implement the plan of motion described by objects
 that conform to MDMPlan.
 */
@protocol MDMPerforming <NSObject>

#pragma mark Designated initializer

/** The receiver is expected to execute its plan to the provided target. */
- (nonnull instancetype)initWithTarget:(nonnull id)target;

@end

@protocol MDMPlan;

/** A class conforming to this protocol will be provided with plan instances. */

@protocol MDMPlanPerforming <MDMPerforming>

#pragma mark Adding plans to a performer

/**
 Provides the performer with an plan.
 
 The performer may choose to store this plan or to simply extract necessary information and cache
 it separately.

 @param plan The plan that required this type of performer.
 */
- (void)addPlan:(nonnull id<MDMPlan>)plan;

@end

/**
 A class conforming to MDMDelegatedPerforming is expected to delegate execution to an external system.
 */
@protocol MDMDelegatedPerforming <MDMPerforming>

#pragma mark Delegating performing

/**
 The performer must call this method before delegated execution begins.

 This is not recursive.
 */
@property(nonnull, copy) void (^delegatedPerformanceWillStartNamed)(NSString *_Nonnull);

/**
 The performer must call this method after delegated execution ends.

 This is not recursive.
 */
@property(nonnull, copy) void (^delegatedPerformanceDidEndNamed)(NSString *_Nonnull);

@end
