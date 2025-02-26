---
layout: post
title: Conditionally include typeguard in Python project
comments: true
tags: [Python,typeguard,conditional,performance]
---

In this post I will show how to use environment variables to conditionally include [typeguard](https://pypi.org/project/typeguard/) in a Python project. The source code underpinning this blog post is made available [here](https://github.com/ovidiuparvu/typeguard-conditional-import).

## Problem

Let's say we maintain some code using typeguard and a snippet of it is the following.

```python
from rich.console import Console
from typeguard import typechecked

@typechecked
class Formatter:
    def bold_green(self, text: str) -> str:
        return f"[bold green]{text}[/green bold]"

if __name__ == "__main__":
    console = Console()
    formatter = Formatter()
    console.print(formatter.bold_green("Hello, World!"))
```

As per [this](https://github.com/agronholm/typeguard/issues/468) issue, importing `typeguard` can add a noticeable execution time performance overhead to the import of a module.

Now let us assume you would like to use the same code for both of the following scenarios.

1. User wants to benefit from typeguard features and the execution time overhead that typeguard adds is acceptable.
2. User wants to use our code w/o typeguard because the execution time overhead that typeguard adds is _not_ acceptable.

So the question is how can we update the code to support both scenarios?

## Solution

One option is to use the value of an environment variable to decide whether to import typeguard annotations/types or dummy ones instead. The updated code using this approach is given below.

```python
import os
from typing import Any, Callable
from rich.console import Console


if os.getenv("ENABLE_TYPEGUARD", "1") == "1":
    from typeguard import typechecked
else:
    # Define a no-op decorator
    def typechecked(func: Callable[..., Any]) -> Callable[..., Any]:
        return func

@typechecked
class Formatter:
    def bold_green(self, text: str) -> str:
        return f"[bold green]{text}[/green bold]"

if __name__ == "__main__":
    console = Console()
    formatter = Formatter()
    console.print(formatter.bold_green("Hello, World!"))
```

If the value of the `ENABLE_TYPEGUARD` environment variable is set to a value different from `1` then typeguard is not used. Otherwise typeguard is used.
