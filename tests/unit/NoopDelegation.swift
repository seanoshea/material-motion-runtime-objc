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

/**
 A plan that immediately starts and completes some delegated work the first time a plan is
 added to a target.
 */
class NoopDelegation: NSObject, Plan {
  func performerClass() -> AnyClass {
    return Performer.self
  }

  private class Performer: NSObject, DelegatedPerforming {
    let target: Any
    required init(target: Any) {
      self.target = target
    }

    func setDelegatedPerformance(willStart: @escaping DelegatedPerformanceTokenReturnBlock,
                                 didEnd: @escaping DelegatedPerformanceTokenArgBlock) {
      let token = willStart()!
      didEnd(token)
    }
  }
}