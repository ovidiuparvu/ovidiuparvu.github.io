---
layout: post
title: Creating interactive plots using marimo
comments: true
tags: [plot,marimo,interactive]
---

Let's say we have the following data:

```python
from datetime import date
import polars as pl

eu_sales_df = pl.DataFrame({
    "day": [date(2025, 6, 1), date(2025, 6, 2), date(2025, 6, 3)],
    "profit": [9000, 7000, 8000],
})
us_sales_df = pl.DataFrame({
    "day": [date(2025, 6, 1), date(2025, 6, 2), date(2025, 6, 3)],
    "profit": [8500, 16000, 8200],
})
detailed_eu_sales_df = pl.DataFrame({
    "day": [date(2025, 6, 1), date(2025, 6, 1), date(2025, 6, 2), date(2025, 6, 2), date(2025, 6, 3), date(2025, 6, 3)],
    "brand": ["Ford", "VW", "Ford", "VW", "Ford", "VW"],
    "profit": [4000, 5000, 3000, 4000, 3500, 4500],    
})
detailed_us_sales_df = pl.DataFrame({
    "day": [date(2025, 6, 1), date(2025, 6, 1), date(2025, 6, 2), date(2025, 6, 2), date(2025, 6, 3), date(2025, 6, 3)],
    "brand": ["Ford", "VW", "Ford", "VW", "Ford", "VW"],
    "profit": [3900, 4600, 12000, 4000, 3600, 4600],
})
```

And let's say we would like to be able to easily compare daily profits for EU vs US and be able to break down profits for a particular day by brand. To do this we could use marimo as shown below.

TODO: Continue from here
