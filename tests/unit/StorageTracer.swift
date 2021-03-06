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

import MaterialMotionRuntime

class StorageTracer: NSObject, Tracing {
  var addedPlans: [Plan] = []
  var createdPerformers: [Performing] = []
  var removedPlanNames: [String] = []

  func didAddPlan(_ plan: Plan, to target: Any) {
    addedPlans.append(plan)
  }

  func didRemovePlanNamed(_ name: String, from target: Any) {
    removedPlanNames.append(name)
  }

  func didCreatePerformer(_ performer: Performing, for target: Any) {
    createdPerformers.append(performer)
  }
}
