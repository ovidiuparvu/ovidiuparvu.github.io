---
layout: post
title: Python project cookiecutter
comments: true
tags: [python,cookiecutter,library,cli,typer]
---

In order to make it easier and faster than it is usually to create a new library or CLI Python project I have created [this](https://github.com/ovidiuparvu/python-project-cookiecutter/tree/main) cookiecutter; see the README.md file in the linked repository for details on how to use it.

The cookiecutter uses:

1. [hatch](https://hatch.pypa.io/dev/) for Python package and virtual environments management.
2. [uv](https://docs.astral.sh/uv/) for Python package management.
3. [ruff](https://docs.astral.sh/ruff/) for linting and formatting.
4. [mypy](https://mypy.readthedocs.io/en/stable/index.html) for type checking.
5. [pylint](https://github.com/pylint-dev/pylint) for linting.
6. [pytest](https://docs.pytest.org/en/stable/) for testing.
7. [pypgrade](https://pypi.org/project/pyupgrade/) for upgrading to newer Python language syntax.
8. [typer](https://typer.tiangolo.com/) and [rich](https://github.com/Textualize/rich) for CLI applications.
9. [mkdocs](https://www.mkdocs.org/) for creating documentation pages.

Examples of toy Python projects created using the cookiecutter are linked below.
1. Library: .
2. CLI tool: .