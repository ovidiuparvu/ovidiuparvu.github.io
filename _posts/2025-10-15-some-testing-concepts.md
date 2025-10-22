---
layout: post
title: On automated developer-driven software testing
comments: true
tags: [testing,mock,fake]
---

Some things I have learned over the years about automated developer-driven software testing are outlined below.

## Why test?

1. Be able to confidently release changes to PROD.
    1. Catch bugs before they go out to PROD (and implicitly reduce amount of debugging the team needs to do).
2. Maintain the ability to safely change your software.
3. Document using tests the desired behaviour of your system.
4. Simplify code reviews by pairing software behaviour changes with thorough tests.
5. Ensure that you design usable software and APIs (both by tests and other programmatic consumers of it).

## Testing concepts

- Unit test: A test of relatively narrow scope.
- Integration test: A test of medium/large scope that verifies the behaviour of multiple integrated units/components.
- End-to-end (e2e) or system test: A large scope test that verifies the behaviour of the system under test end-to-end.
- UI test: A test for verifying that interacting with the UI in a certain way leads to the desired outcome.
- Performance test: A test for verifying that the system under test can perform a certain task within specific performance (e.g. execution time) constraints.
- Load test: A test for verifying if the system under test can successfully cope with a specific amount of load/usage/requests.
- Stress test: A test for verifying what happens when the system under test is overloaded.
- A/B testing: Verifying the impact of some changes (i.e. A) by making them available to a subset of users (e.g. 5%) while all other users continue to use the version of the system under test without the changes (i.e. B).
   - Useful for gradually rolling out changes and assessing the impact of them on a small fraction of users first.
- Test double: A function or an object that can stand in for a real implementation in a test.
   - Mock: A test double whose behaviour is defined inline in the test (setup).
   - Fake: A fake is a lightweight implementation of an API that behaves similar to the real implementation but isn't suitable for production.
- Stubbing: Stubbing is the process of giving behaviour to a (mock) function that otherwise has no behaviour on its own.

## Tips for writing good tests

1. Test everything that you don't want to break.
   1. The Beyonce rule is another way of saying this: "If you liked it, then you shoulda put a test on it".
2. Aim to write tests that are as self-contained, or hermetic, as possible.
   1. Ideally a test's body should contain all of the information needed to understand the test and nothing more.
   2. Writing clear self-contained tests sometimes means introducing some duplication across multiple test cases, therefore violating DRY. Strike a balance that is right for you between zero code duplication and maximum understandability of the tests.
3. Keep the logic inside the tests as simple as possible (e.g. by reducing the number of conditional and loop statements as much as possible).
4. Strive to write tests that do not need changing unless the requirements of the system under test change.
   1. Brittle tests are the opposite of this.
   2. Testing via public APIs helps with this because tests would use the system under test like users can.
   3. Write tests for behaviours that the system under test supports, not for each method that is implemented.
5. Aim to write failure messages that provide sufficient context to an engineer to diagnose the failure without needing to look at anything else.
6. Test using real dependencies instead of fakes/mocks where it is reasonable to do so.
   1. Here you will have to strike a balance between the amount of resources required to create, maintain and use fakes/mocks vs setting up and using test/staging versions of the real dependencies.
   2. If you use fakes, test them, to ensure their behaviour matches the behaviour of the system they represent.
7. A good test suite typically contains a mix of different test sizes and scopes (e.g. 80% unit tests, 15% integration tests, 5% e2e tests).