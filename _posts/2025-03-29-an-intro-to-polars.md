---
layout: post
title: An intro to Polars
comments: true
tags: [polars,python,data,analysis]
---

This introduction to Polars is my attempt to make it easy for future me to recollect what I have learnt during Polars training sessions provided by [Quansight](https://quansight.com/training).

- [Set up a virtual environment](#set-up-a-virtual-environment)
- [Create a DataFrame](#create-a-dataframe)
  - [Basic](#basic)
  - [Specify column types](#specify-column-types)
  - [Reading from a file eagerly](#reading-from-a-file-eagerly)
  - [Reading from a file lazily](#reading-from-a-file-lazily)
- [Working with DataFrame columns](#working-with-dataframe-columns)
  - [Select columns](#select-columns)
  - [Add/replace columns](#addreplace-columns)
  - [Drop columns](#drop-columns)
- [Working with DataFrame rows](#working-with-dataframe-rows)
  - [Select rows](#select-rows)
  - [Select every N rows](#select-every-n-rows)
  - [Adding a row index column similar to what is used for pandas DataFrames](#adding-a-row-index-column-similar-to-what-is-used-for-pandas-dataframes)
- [Non-primitive data type columns](#non-primitive-data-type-columns)
  - [Lists](#lists)
    - [Creating lists from values](#creating-lists-from-values)
    - [Creating lists using values from other columns](#creating-lists-using-values-from-other-columns)
    - [Processing lists values](#processing-lists-values)
  - [Structs](#structs)
    - [Creating DataFrames with struct columns](#creating-dataframes-with-struct-columns)
    - [Unnesting a struct column](#unnesting-a-struct-column)
    - [Selecting a field of a struct column](#selecting-a-field-of-a-struct-column)
    - [Viewing the schema of a DataFrame containing struct columns](#viewing-the-schema-of-a-dataframe-containing-struct-columns)
  - [Arrays](#arrays)
- [Aggregations](#aggregations)
  - [Mean of the values in a column](#mean-of-the-values-in-a-column)
  - [Mean of the values in a column grouped by values in another column](#mean-of-the-values-in-a-column-grouped-by-values-in-another-column)
  - [Mean of the values in a column grouped by values in another column and joined back into the initial DataFrame](#mean-of-the-values-in-a-column-grouped-by-values-in-another-column-and-joined-back-into-the-initial-dataframe)
- [Handling missing/invalid values](#handling-missinginvalid-values)
  - [Null vs NaN in Polars](#null-vs-nan-in-polars)
  - [Counting values when some are missing/invalid](#counting-values-when-some-are-missinginvalid)
  - [Dropping missing/invalid values](#dropping-missinginvalid-values)
- [Working with multiple DataFrames](#working-with-multiple-dataframes)
  - [Joining DataFrames](#joining-dataframes)
  - [Concatenating DataFrames (vertically)](#concatenating-dataframes-vertically)
- [Categorical data](#categorical-data)
  - [Restricting values to Enum values](#restricting-values-to-enum-values)
- [Using LazyFrames instead of (eager) DataFrames](#using-lazyframes-instead-of-eager-dataframes)
  - [Textual representation of query plan](#textual-representation-of-query-plan)
  - [Digraph representation of query plan](#digraph-representation-of-query-plan)
- [Executing row-wise operations](#executing-row-wise-operations)
- [Streaming](#streaming)
- [Working with timeseries](#working-with-timeseries)
  - [Creating datetime Series](#creating-datetime-series)
  - [Filtering based on datetimes](#filtering-based-on-datetimes)
  - [Datetime difference between consecutive rows](#datetime-difference-between-consecutive-rows)
  - [Handling time zones](#handling-time-zones)
  - [Daylight Saving Time (DST)](#daylight-saving-time-dst)
- [Miscellaneous](#miscellaneous)

Right, let's get to it. First set up a virtual environment. Then go through the examples below.

## Set up a virtual environment

```bash
uv venv --seed;
source .venv/bin/activate;
python -m pip install uv;
python -m uv pip install jupyter pandas polars pyarrow;
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

### Reading from a file eagerly

```python
pl.read_parquet('dataset.parquet')
```

### Reading from a file lazily

```python
df = pl.scan_parquet('dataset.parquet')
df.collect()
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

pl.Array is used to represent a fixed-size collection of values. Conversely pl.List is used to represent a variable-size collection of values.

```python
pl.DataFrame(
    {
        'friends': [
            ['Mark', 'Mary'],
            ['John', 'Jane'],
        ],
    },
    schema={
        'friends': pl.Array(pl.String, 2),
    },
)
```

## Aggregations

### Mean of the values in a column

```python
df = pl.scan_parquet("../titanic.parquet")
df.select('survived').mean().collect()
```

### Mean of the values in a column grouped by values in another column

```python
df = pl.scan_parquet("../titanic.parquet")
df.group_by('class').agg(pl.col('survived').mean()).collect()
```

### Mean of the values in a column grouped by values in another column and joined back into the initial DataFrame

```python
df = pl.scan_parquet("../titanic.parquet")
df.select(
    'class',
    'survived',
    class_mean_survival = pl.col('survived').mean().over('class')
).collect()
```

## Handling missing/invalid values

### Null vs NaN in Polars

In Polars there is:

- null: missing data.
- nan: floating point number, which results from e.g. 0/0.

### Counting values when some are missing/invalid

```python
df = pl.scan_parquet("../titanic.parquet")
df.group_by('deck').len().collect()
```

### Dropping missing/invalid values

```python
df = pl.scan_parquet("../titanic.parquet")
df.drop_nulls().collect()
df.filter(pl.col('deck').is_not_null()).collect()
```

## Working with multiple DataFrames

### Joining DataFrames

```python
df1 = pl.DataFrame({'x': [0.2, 1.3, 9.1], 'y': [-9.2, 88.2, 1.5]})
df2 = pl.DataFrame({'x': [9.1, 0.2], 'z': [13124.0, 559.3]})
df1.join(df2, on='x')
```

### Concatenating DataFrames (vertically)

```python
df1 = pl.DataFrame({'x': [0.2, 1.3, 9.1], 'y': [-9.2, 88.2, 1.5]})
df2 = pl.DataFrame({'x': [9.1, 0.2], 'z': [13124.0, 559.3]})
pl.concat([df1, df2], how='diagonal')
```

## Categorical data

```python
# Use a StringCache for the code block below in order to map strings to the same uints when
# creating df1, df2 and pl.concat([df1, df2])
#
# Alternatively, use pl.enable_string_cache() to enable the global string cache if you do not
# have a large number of strings.
with pl.StringCache():
    df1 = pl.DataFrame(
        {"a": ["blue", "blue", "green"], "b": [4, 5, 6]},
        schema_overrides={"a": pl.Categorical},
    )
    df2 = pl.DataFrame(
        {"a": ["green", "green", "blue"], "b": [4, 5, 6]},
        schema_overrides={"a": pl.Categorical},
    )
    df1.with_columns(pl.col('a').to_physical().name.suffix('_physical'))
    df2.with_columns(pl.col('a').to_physical().name.suffix('_physical'))
    pl.concat([df1, df2])
```

### Restricting values to Enum values

```python
s = pl.Series(["flower", "tree", "flower"], dtype=pl.Enum(["flower", "tree", "bonsai"]))
s.dtype
```

## Using LazyFrames instead of (eager) DataFrames

- Using LazyFrames enables lazy evaluation makes it possible for optimizations to be applied automatically instead of requiring hand-rolled optimizations to be used instead.
- If you use expressions the lazy mode should be equivalent to the eager mode (except the need to call `.collect()` at the end).

### Textual representation of query plan

```python
import polars as pl

df = pl.LazyFrame({"a": [1, 2, 3], "b": [4, 5, 6]})
print(df.explain())
```

### Digraph representation of query plan

```python
df = pl.LazyFrame({"a": [1, 2, 3], "b": [4, 5, 6]})
df.show_graph()
```

## Executing row-wise operations

In order to execute some row-wise operations when using Polars one might need to use nested data types.

```python
df = pl.DataFrame({'a': [1, 2, 3], 'b': [4, 5, 6]})
df.select(pl.cum_sum_horizontal(pl.all())).unnest('cum_sum')
```

## Streaming

```python
df = pl.LazyFrame({"a": [1, 2, 3], "b": [4, 5, 6]})
df.with_columns(c=pl.col('a') + pl.col('b')).collect(engine='streaming')
```

## Working with timeseries

### Creating datetime Series

```python
pl.date_range(start=date(2025, 1, 1), end=date(2025, 1, 31), interval='1d')
pl.Series(['2025-01-01T01:43', '2025-01-03T18:44']).str.to_datetime()
pl.Series(["2025 January 01 01:43", "2025 January 03 18:44"]).str.to_datetime('%Y %B %d %H:%M')
```

### Filtering based on datetimes

```python
df = pl.DataFrame({
  'now': pl.date_range(start=date(2025, 1, 1), end=date(2025, 1, 31), interval='1d', eager=True)
})
df.filter(pl.col('now') > pl.date(2025, 1, 10))
df.filter(pl.col('now').dt.day() == 10)
```

### Datetime difference between consecutive rows

```python
df = pl.DataFrame({
  'now': pl.date_range(start=date(2025, 1, 1), end=date(2025, 1, 31), interval='1d', eager=True)
})
df['now'].diff()
```

### Handling time zones

```python
# Time stamp and time zone (if set) are stored separately
ser = pl.Series(['2025-01-01T01:43', '2025-01-03T18:44']).str.to_datetime()                           # time zone unaware
ser = pl.Series(['2025-01-01T01:43', '2025-01-03T18:44']).str.to_datetime(time_zone='Europe/London')  # time zone aware
# Change time zone w/o changing underlying timestamp
ser = ser.dt.convert_time_zone('Asia/Kathmandu')
# Change timestamp ignoring current time zone
ser = ser.dt.replace_time_zone('Asia/Kathmandu')
# Unset time zone
ser = ser.dt.replace_time_zone(time_zone=None)
```

### Daylight Saving Time (DST)

```python
# Convert a Series into a DataFrame
df = pl.datetime_range(
    date(2020, 10, 25),
    datetime(2020, 10, 25, 4),
    "1h",
    time_zone="Europe/London",
    eager=True,
).to_frame('date')
df = df.with_columns(
  # Determine the DST offset
  dst_offset=pl.col('date').dt.dst_offset(),
  # Add 1d to date ignoring DST
  day_plus_1d=pl.col('date').dt.offset_by('1d'),
  # Add 24h (i.e. 1d) to date considering DST
  day_plus_24h=pl.col('date').dt.offset_by('24h'),
)
```

## Miscellaneous

- Data is stored in a columnar (Arrow) format when using Polars.
- In Polars objects are usually immutable.
- In order to improve execution time performance use non-eval approach first, eval second, map_batches third and map_elements fourth (because of jumping btw. Python and a Rust binary)
- Use struct column type if the format/structure of a column is fixed. Otherwise use object type.
- pl.Series()._get_buffers() -> underlying representation.
- .collect([new_]streaming=True, gpu=True) for using streaming and/or GPUs when collecting results from a lazy DataFrame.
- Using sorted data enables Polars to use some optimizations which reduce execution time. Use `set_sorted` to tell Polars that data is sorted (Polars won't check, so use w/ care).
