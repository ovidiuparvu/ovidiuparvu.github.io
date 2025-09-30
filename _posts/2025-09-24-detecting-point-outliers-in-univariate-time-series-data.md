---
layout: post
title: Detecting point outliers in univariate time series data
comments: true
tags: [point,outlier,time series,univariate]
---

Let us denote the univariate time series data as $X = [x_0, x_1, ..., x_n]$.

## Approaches using thresholds

### Z-score

$$
outlier(x_i) = |x_i - \mu| > k\sigma
$$

where $\mu$ represents the mean, $\sigma$ the standard deviation, and the constant $k$ = 2 or 3 typically.

### Modified z-score using median absolute deviation (MAD)

$$
outlier(x_i) = \left| 0.6745 * \frac{x_i - median(X)}{MAD(X)} \right| > 3.5 \\
MAD(X) = median(|x_i - median(X)|)
$$

### Interquartile range (IQR)

$$
outlier(x_i) = x_i \notin [quartile_1(X) - k * IQR(X), quartile_3(X) + k  * IQR(X)] \\
IQR(X) = quartile_3(X) - quartile_1(X)
$$

where the constant $k$ = 1.5 typically.

### Interpercentile range* (IPR*)

$$
outlier(x_i, c, t) = \begin{cases}
    false \text{, if } n < c \\ 
    x_i \notin [ \\
        \text{  }min(-t, percentile(5, X) - k * IPR(X)), \\
        \text{  }max(t, percentile(95, X) + k  * IPR(X)) \\
    ] \text{, otherwise.}
\end{cases} \\
IPR(X) = percentile(95, X) - percentile(5, X)
$$

where the constant $k$ = 1.5 typically.

## Further reading

For a comprehensive review on point outlier detection in univariate time series data see [this](https://dl.acm.org/doi/10.1145/3444690) paper.