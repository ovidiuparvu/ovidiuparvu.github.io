---
layout: post
title: Creating HTML reports from Python using Jinja
comments: true
tags: [html,report,python,jinja]
---

In this post we will go over one approach for generating HTML reports from Python using [Jinja](https://pypi.org/project/Jinja2).

Using Python for data loading and analysis is great due to the rich ecosystem of relevant Python packages. Using Jinja for creating HTML reports is great due to the powerful templating capabilities of Jinja.

## Step 1: Install Jinja

```sh
python -m uv pip install Jinja2
```

## Step 2: Create an html Jinja template

#### **templates/report.html.j2**

```html+jinja
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>{{ title }}</title>
  <style>
    table { border-collapse: collapse; width: 100%; }
    th, td { border: 1px solid #ccc; padding: 8px; }
    th { background: #f4f4f4; }
  </style>
</head>
<body>
  <h1>{{ title }}</h1>
  <table>
    <thead>
      <tr>
        <th>Name</th>
        <th>Value</th>
      </tr>
    </thead>
    <tbody>
      {% for item in items %}
      <tr>
        <td>{{ item.name }}</td>
        <td>{{ item.value }}</td>
      </tr>
      {% endfor %}
    </tbody>
  </table>
</body>
</html>
```

## Step 3: Load data and render template using it

#### **generate_report.py**

```python
from collections.abc import Mapping
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from jinja2 import Environment, FileSystemLoader


@dataclass
class Data:
    name: str
    value: str


def render_report(template_name: str, context: Mapping[str, object], output_path: Path) -> None:
    # 1. Configure Jinja to load from the 'templates' folder
    env = Environment(
        loader=FileSystemLoader("templates"),
        autoescape=True,  # for HTML safety
    )

    # 2. Load the template
    template = env.get_template(template_name)

    # 3. Render with your context
    rendered_html = template.render(**context)

    # 4. Write to a file
    with output_path.open("w", encoding="utf-8") as f:
        f.write(rendered_html)


if __name__ == "__main__":
    items = [
        Data(name="Region", value="EU"),
        Data(name="Weather", value="Hot"),
        Data(name="PopulationDensity", value="High"),
    ]
    context = {
        "title": "Regional report",
        "items": items,
    }
    render_report("report.html.j2", context, Path("report.html"))
```

## Step 4: Generate the report

```sh
python generate_report.py
```
