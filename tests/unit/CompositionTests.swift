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

import XCTest
import MaterialMotionRuntime

// Tests related to the composition of plans.
class CompositionTests: XCTestCase {

  /**
   Test that plan composition results in the emitted plans being committed to the scheduler.

   The expectation of this test is that the scheduler's activity state changes from active to idle.
   */
  func testComposedDelegationCausesActivityStateChange() {
    let scheduler = Scheduler()

    let delegate = TestSchedulerDelegate()
    scheduler.delegate = delegate

    let transaction = Transaction()
    transaction.add(plan: Emit(plan: NoopDelegation()), to: NSObject())
    scheduler.commit(transaction: transaction)

    // The following steps are now expected to have occurred:
    //
    // 1. The Emit plan was committed to the scheduler.
    // 2. The Emit plan's performer emitted the NoopDelegation plan.
    // 3. The NoopDelegation plan changed the scheduler's activity state by immediately starting
    //    and completing some delegated work.

    XCTAssertTrue(delegate.activityStateDidChange)
    XCTAssertTrue(scheduler.activityState == .idle)
  }

  // A plan that emits an arbitrary plan.
  private class Emit: NSObject, Plan {
    var plan: Plan
    init(plan: Plan) {
      self.plan = plan
    }

    func performerClass() -> AnyClass {
      return Performer.self
    }

    private class Performer: NSObject, PlanPerforming, ComposablePerforming {
      let target: Any
      required init(target: Any) {
        self.target = target
      }

      func add(plan: Plan) {
        let emit = plan as! Emit
        let transaction = Transaction()
        transaction.add(plan: emit.plan, to: target)
        emitter.emit(transaction: transaction)
      }

      var emitter: TransactionEmitting!
      func set(transactionEmitter: TransactionEmitting) {
        emitter = transactionEmitter
      }
    }
  }

  // A plan that immediately starts and completes some delegated work the first time a plan is
  // added to a target.
  private class NoopDelegation: NSObject, Plan {
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
}
