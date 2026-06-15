---
layout: post
title: Subtracting DataFrame values inline
comments: true
tags: [subtraction,polars,dataframe]
---

Let us assume that we are working w/ the following polars DataFrame:

```
┌────────────┬─────┬─────┬─────┐
│ D          ┆ R   ┆ V   ┆ P   │
╞════════════╪═════╪═════╪═════╡
│ 2026-01-01 ┆ S   ┆ B   ┆ 1.2 │
│ 2026-01-01 ┆ S   ┆ U   ┆ 2.2 │
│ 2026-01-01 ┆ T   ┆ B   ┆ 3.0 │
│ 2026-01-01 ┆ T   ┆ U   ┆ 4.0 │
│ 2026-01-02 ┆ S   ┆ B   ┆ 5.2 │
│ 2026-01-02 ┆ S   ┆ U   ┆ 6.2 │
│ 2026-01-02 ┆ T   ┆ B   ┆ 7.0 │
│ 2026-01-02 ┆ T   ┆ U   ┆ 8.0 │
└────────────┴─────┴─────┴─────┘
```

We would like to compute the marginal DataFrame relative to `V` == `B`. One way to do this is given below:

```
num = cs.numeric()
marginal = df.with_columns(
    num - num.filter(pl.col("V") == "B").item().over(["D", "R"])
)
```
