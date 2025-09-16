---
layout: post
title: Running Python code with dependencies from the CLI
comments: true
tags: [python,uv,cli]
---

`uv` can be used to run Python code with dependencies from the CLI as shown in the example below.

```bash
uv run --with polars - <<EOF
import datetime as dt
import polars as pl

df = pl.DataFrame(
    {
        "name": ["Alice Archer", "Ben Brown", "Chloe Cooper", "Daniel Donovan"],
        "birthdate": [
            dt.date(1997, 1, 10),
            dt.date(1985, 2, 15),
            dt.date(1983, 3, 22),
            dt.date(1981, 4, 30),
        ],
        "weight": [57.9, 72.5, 53.6, 83.1],  # (kg)
        "height": [1.56, 1.77, 1.65, 1.75],  # (m)
    }
)

print(df)
EOF
```