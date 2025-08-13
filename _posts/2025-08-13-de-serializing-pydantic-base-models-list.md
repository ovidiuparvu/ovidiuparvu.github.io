---
layout: post
title: (De)serializing pydantic BaseModels list
comments: true
tags: [pydantic,serialization,json,BaseModel]
---

One approach for (de)serializing pydantic BaseModels lists is using [TypeAdapters](https://docs.pydantic.dev/latest/concepts/type_adapter/), an example of which is given below.

```python
from functools import cache
from pathlib import Path

from pydantic import BaseModel, TypeAdapter


class Building(BaseModel):
    name: str
    city: str
    floors: int


@cache
def make_building_list_adapter() -> TypeAdapter[list[Building]]:
    return TypeAdapter(list[Building])


def buildings_to_json_file(buildings: list[Building], file: Path) -> None:
    with file.open("wb") as f:
        adapter = make_building_list_adapter()
        json_bytes = adapter.dump_json(buildings)
        f.write(json_bytes)


def buildings_from_json_file(file: Path) -> list[Building]:
    with file.open("rb") as f:
        adapter = make_building_list_adapter()
        json_bytes = f.read()
        return adapter.validate_json(json_bytes)
```

A test illustrating how to use the above JSON (de)serialization methods is given [here](https://github.com/ovidiuparvu/pydantic-base-model-list-serialization/blob/main/test_building.py).