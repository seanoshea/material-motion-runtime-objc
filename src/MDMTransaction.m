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

#import "MDMTransaction.h"
#import "MDMTransaction+Private.h"
#import "MDMPerforming.h"
#import "MDMPlan.h"

@implementation MDMTransaction {
  NSMutableArray *_logs;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _logs = [NSMutableArray array];
  }
  return self;
}

- (void)addPlan:(NSObject<MDMPlan> *)plan toTarget:(id)target {
  [self commonAddPlan:plan toTarget:target withName:nil];
}

- (void)addPlan:(NSObject<MDMPlan> *)plan named:(NSString *)name toTarget:(id)target {
  NSParameterAssert(name.length > 0);
  [self commonRemovePlan:plan fromTarget:target named:name];
  [self commonAddPlan:plan toTarget:target withName:name];
}

- (void)removePlanNamed:(nonnull NSString *)name fromTarget:(nonnull id)target {
  [self commonRemovePlan:nil fromTarget:target named:name];
}

- (void)commonAddPlan:(NSObject<MDMPlan> *)plan toTarget:(id)target withName:(NSString *)name {
  [_logs addObject:[[MDMTransactionLog alloc] initWithPlan:[plan copy] target:target name:name removal:FALSE]];
}

- (void)commonRemovePlan:(NSObject<MDMPlan> *)plan fromTarget:(nonnull id)target named:(NSString *)named {
  [_logs addObject:[[MDMTransactionLog alloc] initWithPlan:plan target:target name:named removal:TRUE]];
}

- (NSArray<MDMTransactionLog *> *)logs {
  return _logs;
}

@end

@implementation MDMTransactionLog

- (instancetype)initWithPlan:(NSObject<MDMPlan> *)plan target:(id)target name:(NSString *)name removal:(BOOL)removal {
  self = [super init];
  if (self) {
    if (plan != nil) {
      _plans = @[ plan ];
    }
    _target = target;
    _name = [name copy];
    _removal = removal;
  }
  return self;
}

@end
