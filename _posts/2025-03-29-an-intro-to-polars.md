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

df = pl.DataFrame({'key': ['A', 'B'], 'value': [1, 2]})
df.select('key')
df.select(cs.all() - cs.numeric())
```

### Add/replace columns

```python
df = pl.DataFrame({'key': ['A', 'B'], 'value': [1, 2]})
df.with_columns(
    keyvalue=pl.col('key') + pl.col('value').cast(pl.String)
)
```

### Drop columns

```python
df = pl.DataFrame({'key': ['A', 'B'], 'value': [1, 2]})
df.drop('value')
```

## Working with DataFrame rows

### Select rows

```python
df = pl.DataFrame({'key': ['A', 'B'], 'value': [1, 2]})
df.filter(pl.col('value') > 1)
```

### Select every N rows

```python
df = pl.DataFrame({'key': ['A', 'B'], 'value': [1, 2]})
df[::2]             # Gather every 2nd row
df.gather_every(2)  # Gather every 2nd row
```

### Adding a row index column similar to what is used for pandas DataFrames

```python
df = pl.DataFrame({'key': ['A', 'B'], 'value': [1, 2]})
df.with_row_index()
```

## Non-primitive data type columns

### Lists

#### Creating lists from values

```python
pl.DataFrame({'x': [4, 1, 7], 'y': [8, 2, 9], 'z': [[1, 2], [6, 2], [-2, 9]]})
```

#### Creating lists using values from other columns

```python
df = pl.DataFrame({'x': [4, 1, 7], 'y': [8, 2, 9]})
df.with_columns(x_y=pl.concat_list('x', 'y'))
```

#### Processing lists values

```python
df = pl.DataFrame({'x': [4, 1, 7], 'y': [8, 2, 9], 'z': [[1, 2], [6, 2], [-2, 9]]})
df.with_columns(z_mean=pl.col('z').list.mean())
```

### Structs

#### Creating DataFrames with struct columns

```python
df = pl.DataFrame({'cars': [{'make': 'Audi', 'year': 2020}, {'make': 'Volkswagen', 'year': 2024}]})
```

#### Unnesting a struct column

```python
df.unnest('cars')
```

#### Selecting a field of a struct column

```python
df.select(pl.col('cars').struct.field('make'))
```

#### Viewing the schema of a DataFrame containing struct columns

```python
df.schema
```

### Arrays

TODO: Continue from here

## Miscellaneous

- Data is stored in a columnar (Arrow) format when using Polars.
- In Polars objects are usually immutable.
- In order to improve execution time performance use non-eval approach first, eval second, map_elements third (because of jumping btw. Python and a Rust binary)
- Use struct column type if the format/structure of a column is fixed. Otherwise use object type.
- pl.Array -> fixed size limit
- pl.Series()._get_buffers() -> underlying representation.
- .count() -> only valid values. .len() -> actual length including null values.
- pl.enable_string_cache() for global strings caching. Use StringCache context manager for non-global use cases.
- .collect([new_]streaming=True, gpu=True) for using streaming and/or GPUs when collecting results from a lazy DataFrame.
