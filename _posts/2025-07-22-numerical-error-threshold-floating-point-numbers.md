---
layout: post
title: Numerical error thresholds for floating point numbers
comments: true
tags: [float,double,ieee754,numerical,threshold]
---

According to W. Kahan's [notes](https://people.eecs.berkeley.edu/~wkahan/ieee754status/IEEE754.PDF) on the status of the IEEE Standard 754, the precision of:
1. A _32 bit_ floating point number (i.e. a Single) is _6-9_ decimal digits;
2. A _64 bit_ floating point number (i.e. a Double) is _15-17_ decimal digits.

Specifically the precision is expressed as a range rather than a single value because:
1. If a decimal string with at most 6/15 significant decimal digits is converted to a Single/Double and then converted back to the same number of significant decimal digits, then the final string should match the original.
2. If a Single/Double is converted to a decimal string with at least 9/17 decimal digits and then converted back to a Single/Double, then the final number must match the original.

Therefore a conservative numerical error threshold could be:
1. `1E-6` for a Single;
2. `1E-15` for a Double.

Examples of using such error thresholds are given below. 

```
if (abs(double - value) < 1e-15) {
    // Double is equal to value
}

if (single + 1e+6 < value) {
    // Single is less than value
}
```

Note that the magnitude of numerical errors can increase as a result of arithmetic operations (e.g. multiplication). Therefore, depending on your use case, the results of arithmetic operations may need to be rounded to ensure that numerical errors do not exceed the error threshold given above.