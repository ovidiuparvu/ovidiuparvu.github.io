---
layout: post
title: Anatomy of an Apache Parquet file
comments: true
tags: [apache,parquet]
---

The anatomy of an Apache Parquet file, as of the time of writing, is shown below.

```text
┌────────────────────────────────────────────────────────────────┐
│ "PAR1" ASCII string (4 bytes)                                  │
├────────────────────────────────────────────────────────────────┤
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ Row Group 1                                              │  │
│  │  ┌─────────────────────────────────────────────────────┐ │  │
│  │  │ Column Chunk 1                                      | |  |
|  |  | ┌─────────────────────────────────────────────────┐ | |  |
|  |  | | Page 1                                          | | |  |
|  |  | |                                                 | | |  |
|  |  | | - Page header metadata (Thrift)                 | | |  |
|  |  | | - Repetition levels                             | | |  |
|  |  | | - Definition levels                             | | |  |
|  |  | | - Values                                        | | |  |
|  |  | └─────────────────────────────────────────────────┘ | |  |
|  |  |  ... (additional pages)                             | |  |
│  │  └─────────────────────────────────────────────────────┘ │  │
│  │  ... (additional column chunks)                          │  │
│  └──────────────────────────────────────────────────────────┘  │
│  ... (additional row groups)                                   │
├────────────────────────────────────────────────────────────────┤
│ FileMetaData (Thrift)                                          │
├────────────────────────────────────────────────────────────────┤
│ FileMetadata size (4 bytes, little endian)                     |
├────────────────────────────────────────────────────────────────┤
│ "PAR1" ASCII string (4 bytes)                                  │
└────────────────────────────────────────────────────────────────┘
```

Details about:

- Repetition and definition levels are given in the [Dremel](https://static.googleusercontent.com/media/research.google.com/en//pubs/archive/36632.pdf) paper.
- The file and the page header metadata are given on the relevant [Apache Parquet](https://parquet.apache.org/docs/file-format/metadata/) webpage.
