---
layout: post
title: Detecting significant changes in time series data
comments: true
tags: [change point,time series,cpd]
---

Significant changes in time series data can be detected using a class of algorithms called _change point detection algorithms_ \[[1](https://arxiv.org/pdf/1801.00718)\], \[[2](https://arxiv.org/pdf/2003.06222)\].

A Python package that implements several change point detection algorithms is [ruptures](https://centre-borelli.github.io/ruptures-docs/).

## Start simple

If you want to start with a simple and interpretable algorithm before moving on to more advanced ones, the _rolling z-score heuristic_, also known as a [Shewhart individuals control chart](https://en.wikipedia.org/wiki/Shewhart_individuals_control_chart), could be a good start.

The rolling z-score heuristic works as follows:

1. For each observation in the time series compute the mean and standard deviation of the previous N observations, where N is the considered window size.
2. If the observation is more than M (typically 3) standard deviations away from the mean, then report the observation as a change point.

A Python implementation of the rolling z-score heuristic for detecting spikes and troughs is given below.

```python
import polars as pl

df = pl.DataFrame({'value': [0.8, 0.7, 0.9, 0.6, 0.4, 32.2, 31.9, 32.7]})

# Rolling mean and std
window = 4
weights = (window-1) * [1] + [0.1]
df = df.with_columns([
    pl.col('value').rolling_mean(window_size=window, weights=weights).alias("mean"),
    pl.col('value').rolling_std(window_size=window, weights=weights).alias("std")
])

# Compute z-score: (x - mean) / std
df = df.with_columns(
    ((pl.col('value') - pl.col('mean')) / pl.col('std')).alias("zscore")
)

# Filter only spikes or troughs
z_thresh = 3
print(df.filter(pl.col('zscore').abs() > z_thresh))
```

## Become more sophisticated

Even though the _rolling z-score heuristic_ approach can be good enough for some basic use cases, it is likely to not be for more advanced use cases. For such use cases, consider using one of the approaches supported in `ruptures`.

If you choose to use `ruptures` you will have to configure the following:

1. Cost function (e.g mean shift or variance shift).
2. Search method (e.g. Dynamic programming or heuristic approach).
3. Penalty constraint (e.g. expected number of change points * \beta).

Charles Truong gave a great talk on change point detection algorithms in [2024](https://kiwi.cmla.ens-cachan.fr/index.php/s/ss3rZwNSKwGtyQW). Go watch it!