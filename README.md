# Material Motion Runtime for Apple Devices

[![Build Status](https://travis-ci.org/material-motion/material-motion-runtime-objc.svg?branch=develop)](https://travis-ci.org/material-motion/material-motion-runtime-objc)
[![codecov](https://codecov.io/gh/material-motion/material-motion-runtime-objc/branch/develop/graph/badge.svg)](https://codecov.io/gh/material-motion/material-motion-runtime-objc)

The Material Motion Runtime is a tool for describing motion declaratively.

## Declarative motion: motion as data

This library does not do much on its own. What it does do, however, is enable the expression of
motion as discrete units of data that can be introspected, composed, and sent over a wire.

This library encourages you to describe motion as data, or what we call *plans*. Plans are committed
to a *scheduler*. A scheduler coordinates the creation of *performers*, objects responsible for
translating plans into concrete execution.

## Installation

### Installation with CocoaPods

> CocoaPods is a dependency manager for Objective-C and Swift libraries. CocoaPods automates the
> process of using third-party libraries in your projects. See
> [the Getting Started guide](https://guides.cocoapods.org/using/getting-started.html) for more
> information. You can install it with the following command:
>
>     gem install cocoapods

Add `MaterialMotionRuntime` to your `Podfile`:

    pod 'MaterialMotionRuntime'

Then run the following command:

    pod install

### Usage

Import the Material Motion Runtime framework:

    @import MaterialMotionRuntime;

You will now have access to all of the APIs.

## Example apps/unit tests

Check out a local copy of the repo to access the Catalog application by running the following
commands:

    git clone https://github.com/material-motion/material-motion-runtime-objc.git
    cd material-motion-runtime-objc
    pod install
    open MaterialMotionRuntime.xcworkspace

## Guides

1. [Architecture](#architecture)
2. [How to define a new plan and performer type](#how-to-create-a-new-plan-and-performer-type)
3. [How to commit a plan to a scheduler](#how-to-commit-a-plan-to-a-scheduler)
4. [Configuring performers with plans](#configuring-performers-with-plans)

### Architecture

The Material Motion Runtime consists of two groups of APIs: a scheduler/transaction object and a
constellation of protocols loosely consisting of plan and performing types.

#### Scheduler + Transaction

The [Scheduler](https://material-motion.github.io/material-motion-runtime-objc/Classes/MDMScheduler.html)
object is a coordinating entity whose primary responsibility is to fulfill plans by creating
performers. You can create many schedulers throughout the lifetime of your application. A good rule
of thumb is to have one scheduler per interaction or transition.

[Transactions](https://material-motion.github.io/material-motion-runtime-objc/Classes/MDMTransaction.html)
are the mechanism by which plans are committed to a scheduler. Transactions allow the runtime to
minimize the API surface area of the scheduler while providing a vessel for plans to be transported
within.

#### Plan + Performing types

The [Plan](https://material-motion.github.io/material-motion-runtime-objc/Protocols/MDMPlan.html)
and [Performing](https://material-motion.github.io/material-motion-runtime-objc/Protocols/MDMPerforming.html)
protocol each define the minimal characteristics required for an object to be considered either a
plan or a performer, respectively, by the Material Motion Runtime.

Plans and performers have a symbiotic relationship. A plan is executed by the performer it defines.
Performer behavior is configured by the provided plan instances.

Learn more about the Material Motion Runtime by reading the
[Starmap](https://material-motion.gitbooks.io/material-motion-starmap/content/specifications/runtime/).

### How to create a new plan and performer type

The following steps provide copy-pastable snippets of code.

#### Step 1: Define the plan type

Questions to ask yourself when creating a new plan type:

- What do I want my plan/performer to accomplish?
- Will my performer need many plans to achieve the desired outcome?
- How can I name my plan such that it clearly communicates either a **behavior** or a
  **change in state**?

As general rules:

1. Plans with an *-able* suffix alter the **behavior** of the target, often indefinitely. Examples:
   Draggable, Pinchable, Tossable.
2. Plans that are *verbs* describe some **change in state**, often over a period of time. Examples:
   FadeIn, Tween, SpringTo.

Code snippets:

***In Objective-C:***

```objc
@interface <#Plan#> : NSObject
@end

@implementation <#Plan#>
@end
```

***In Swift:***

```swift
class <#Plan#>: NSObject {
}
```

#### Step 2: Define the performer type

Performers are responsible for fulfilling plans. Fulfillment is possible in a variety of ways:

- [PlanPerforming](https://material-motion.github.io/material-motion-runtime-objc/Protocols/MDMPlanPerforming.html): [Configuring performers with plans](#configuring-performers-with-plans)
- [DelegatedPerforming](https://material-motion.github.io/material-motion-runtime-objc/Protocols/MDMDelegatedPerforming.html)
- [ComposablePerforming](https://material-motion.github.io/material-motion-runtime-objc/Protocols/MDMComposablePerforming.html)

See the associated links for more details on each performing type.

> Note: only one instance of a type of performer **per target** is ever created. This allows you to
> register multiple plans to the same target in order to configure a performer. See
> [Configuring performers with plans](#configuring-performers-with-plans) for more details.

Code snippets:

***In Objective-C:***

```objc
@interface <#Performer#> : NSObject <MDMPerforming>
@end

@implementation <#Performer#> {
  UIView *_target;
}

- (instancetype)initWithTarget:(id)target {
  self = [super init];
  if (self) {
    assert([target isKindOfClass:[UIView class]]);
    _target = target;
  }
  return self;
}

@end
```

***In Swift:***

```swift
class <#Performer#>: NSObject, Performing {
  let target: UIView
  required init(target: Any) {
    self.target = target as! UIView
    super.init()
  }
}
```

#### Step 3: Make the plan type a formal Plan

Conforming to Plan requires:

1. that you define the type of performer your plan requires, and
2. that your plan be copyable.

Code snippets:

***In Objective-C:***

```objc
@interface <#Plan#> : NSObject <MDMPlan>
@end

@implementation <#Plan#>

- (Class)performerClass {
  return [<#Plan#> class];
}

- (id)copyWithZone:(NSZone *)zone {
  return [[[self class] allocWithZone:zone] init];
}

@end
```

***In Swift:***

```swift
class <#Plan#>: NSObject, Plan {
  func performerClass() -> AnyClass {
    return <#Performer#>.self
  }
  func copy(with zone: NSZone? = nil) -> Any {
    return <#Plan#>()
  }
}
```

### How to commit a plan to a scheduler

#### Step 1: Create and store a reference to a scheduler instance

Code snippets:

***In Objective-C:***

```objc
@interface MyClass ()
@property(nonatomic, strong) MDMScheduler* scheduler;
@end

- (instancetype)init... {
  ...
  self.scheduler = [MDMScheduler new];
  ...
}
```

***In Swift:***

```swift
class MyClass {
  let scheduler = Scheduler()
}
```

#### Step 2: Create a new transaction instance and associate plans with targets

Code snippets:

***In Objective-C:***

```objc
MDMTransaction *transaction = [MDMTransaction new];
[transaction addPlan:<#Plan instance#> toTarget:<#View instance#>];
```

***In Swift:***

```swift
let transaction = Transaction()
transaction.add(plan: <#Plan instance#>, to: <#View instance#>)
```

#### Step 3: Commit the transaction to the scheduler

Code snippets:

***In Objective-C:***

```objc
[self.scheduler commitTransaction:transaction];
```

***In Swift:***

```swift
scheduler.commit(transaction: transaction)
```

### Configuring performers with plans

Configuring performers with plans starts by making your performer conform to
[PlanPerforming](https://material-motion.github.io/material-motion-runtime-objc/Protocols/MDMPlanPerforming.html).

PlanPerforming requires that you implement the `addPlan:` method. This method will be called on a
performer each time a plan is committed to the scheduler that expects to be fulfilled by the
performer.

Code snippets:

***In Objective-C:***

```objc
@interface <#Performer#> (PlanPerforming) <MDMPlanPerforming>
@end

@implementation <#Performer#> (PlanPerforming)

- (void)addPlan:(id<MDMPlan>)plan {
  <#Plan#>* <#casted plan instance#> = plan;

  // Do something with the plan.
}

@end
```

***In Swift:***

```swift
extension <#Performer#>: PlanPerforming {
  func add(plan: Plan) {
    let <#casted plan instance#> = plan as! <#Plan#>

    // Do something with the plan.
  }
}
```

***Handling multiple plan types in Swift:***

Make use of Swift's typed switch/casing to handle multiple plan types.

```swift
func add(plan: Plan) {
  switch plan {
  case let <#plan instance 1#> as <#Plan type 1#>:
    ()

  case let <#plan instance 2#> as <#Plan type 2#>:
    ()

  case is <#Plan type 3#>:
    ()

  default:
    assert(false)
  }
}
```

## Contributing

We welcome contributions!

Check out our [upcoming milestones](https://github.com/material-motion/material-motion-runtime-objc/milestones).

Learn more about [our team](https://material-motion.gitbooks.io/material-motion-team/content/),
[our community](https://material-motion.gitbooks.io/material-motion-team/content/community/), and
our [contributor essentials](https://material-motion.gitbooks.io/material-motion-team/content/essentials/).

## License

Licensed under the Apache 2.0 license. See LICENSE for details.

