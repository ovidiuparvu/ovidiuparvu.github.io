---
layout: post
title: Auto-enabling Python logging when running in Jupyter kernerls
comments: true
tags: [logging,python,jupyter]
---

An approach is shown below for auto-enabling logging from inside a Python library when it is run in a Jupyter kernel.

```python
# mylib/__init__.py

import logging
import os


def _in_jupyter_kernel() -> bool:
    try:
        from IPython import get_ipython
    except ImportError:
        return False

    shell = get_ipython()
    return shell is not None and getattr(shell, "kernel", None) is not None


logger = logging.getLogger(__name__)

if not logger.handlers:
    if (
        _in_jupyter_kernel()
        and os.getenv("MYLIB_AUTO_LOGGING", "1") != "0"
    ):
        handler = logging.StreamHandler()
        handler.setFormatter(
            logging.Formatter("%(levelname)s: %(message)s")
        )
        logger.addHandler(handler)
        logger.setLevel(logging.INFO)
        logger.propagate = False
    else:
        logger.addHandler(logging.NullHandler())
```