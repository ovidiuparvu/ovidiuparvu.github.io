---
layout: post
title: An intro to Polars
comments: true
tags: [polars,python,data,analysis]
---

First set up a virtual environment. Then go through the polars examples below.

## Set up a virtual environment

```bash
uv venv;
source .venv/bin/activate;
python -m ensurepip;
python -m pip install uv;
uv pip install jupyter pandas polars;
```

## Create a DataFrame

### Basic

```python
import polars as pl

pl.DataFrame({'key': ['A', 'B'], 'value': [1, 2]})
```

### Specify column types

```python
pl.DataFrame(
    {'key': ['A', 'B'], 'value': [1, 2]},
    schema_overrides={
        'key': pl.String,
        'value': pl.Int16,
    }
)
```

## Working with DataFrame columns

### Select columns

```python
import polars.selectors as cs

df = pl.DataFrame(
    {'key': ['A', 'B'], 'value': [1, 2]},
    schema_overrides={
        'key': pl.String,
        'value': pl.Int16,
    }
)
df.select('key')
df.select(cs.all() - cs.numeric())
```

### Add/replace columns

```python
df = pl.DataFrame(
    {'key': ['A', 'B'], 'value': [1, 2]},
    schema_overrides={
        'key': pl.String,
        'value': pl.Int16,
    }
)
df.with_columns(
    keyvalue=pl.col('key') + pl.col('value').cast(pl.String)
)
```

### Drop columns

```python
df = pl.DataFrame(
    {'key': ['A', 'B'], 'value': [1, 2]},
    schema_overrides={
        'key': pl.String,
        'value': pl.Int16,
    }
)
df.drop('value')
```

## Miscellaneous

- In Polars objects are usually immutable.
- In order to improve execution time performance use non-eval approach first, eval second, map_elements third (because of jumping btw. Python and a Rust binary)
- Use struct column type if the format/structure of a column is fixed. Otherwise use object type.
- pl.Array -> fixed size limit
- pl.Series()._get_buffers() -> underlying representation.
- .count() -> only valid values. .len() -> actual length including null values.
- pl.enable_string_cache() for global strings caching. Use StringCache context manager for non-global use cases.
- Data is stored in a columnar (Arrow) format when using Polars
- .collect([new_]streaming=True, gpu=True) for using streaming and/or GPUs when collecting results from a lazy DataFrame.
