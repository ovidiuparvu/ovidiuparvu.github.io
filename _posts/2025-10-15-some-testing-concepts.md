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

- Unit test: TODO
- Fake: TODO
- Mock: TODO

## Tips for writing good tests

1. Test everything that you don't want to break.
   1. The Beyonce rule is another way of saying this: "If you liked it, then you shoulda put a test on it".
2. Aim to write tests that are as self-contained, or hermetic, as possible.
3. Keep the logic inside the tests as simple as possible by reducing conditional and loop statements as much as possible, ideally down to 0.
4. Test using real dependencies instead of fakes/mocks where it is reasonable to do so.
   1. Here you will have to strike a balance between amount of resources required to create, maintain and use fakes/mocks vs setting up and using test/staging versions of the real dependencies.
5. A good test suite typically contains a mix of different test sizes and scopes (e.g. 80% unit tests, 15% integration tests, 5% e2e tests).