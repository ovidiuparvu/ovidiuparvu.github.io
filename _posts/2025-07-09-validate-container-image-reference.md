---
layout: post
title: Validate a container image reference in Python
comments: true
tags: [container,image,docker,python]
---

Container image references (that do no contain host names specified as IP addresses) can be validated in Python as follows:

```python
import re

# Container image reference format specification:
# https://pkg.go.dev/github.com/distribution/reference#pkg-overview
#
# Hosts specified as IP addresses are not supported (in the HOST_REGEX below)
DOMAIN_COMPONENT_REGEX = r"(?:[a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9])"
DOMAIN_NAME_REGEX = rf"{DOMAIN_COMPONENT_REGEX}(?:[.]{DOMAIN_COMPONENT_REGEX})*"
HOST_REGEX = DOMAIN_NAME_REGEX
PORT_NUMBER_REGEX = r"[0-9]+"
DOMAIN_REGEX = rf"{HOST_REGEX}(?::{PORT_NUMBER_REGEX})?"

SEPARATOR_REGEX = r"[_.]|__|[-]*"
ALPHA_NUMERIC_REGEX = r"[a-z0-9]+"
PATH_COMPONENT_REGEX = (
    rf"{ALPHA_NUMERIC_REGEX}(?:{SEPARATOR_REGEX}{ALPHA_NUMERIC_REGEX})*"
)
REMOTE_NAME_REGEX = rf"{PATH_COMPONENT_REGEX}(?:[/]{PATH_COMPONENT_REGEX})*"
NAME_REGEX = rf"(?:{DOMAIN_REGEX}/)?{REMOTE_NAME_REGEX}"
NAME_PATTERN = re.compile(rf"^{NAME_REGEX}$")

TAG_REGEX = r"[\w][\w.-]{0,127}"
TAG_PATTERN = re.compile(rf"^{TAG_REGEX}$")

NAME_TAG_REGEX = rf"{NAME_REGEX}(?::{TAG_REGEX})?"
NAME_TAG_PATTERN = re.compile(rf"^{NAME_TAG_REGEX}$")

DIGEST_HEX_REGEX = r"(?:[a-fA-F0-9]{32,})"
DIGEST_ALGORITHM_COMPONENT_REGEX = r"(?:[A-Za-z][A-Za-z0-9]*)"
DIGEST_ALGORITHM_SEPARATOR_REGEX = r"[+.-_]"
DIGEST_ALGORITHM_REGEX = rf"{DIGEST_ALGORITHM_COMPONENT_REGEX}(?:{DIGEST_ALGORITHM_SEPARATOR_REGEX}{DIGEST_ALGORITHM_COMPONENT_REGEX})*"
DIGEST_REGEX = rf"{DIGEST_ALGORITHM_REGEX}:{DIGEST_HEX_REGEX}"
DIGEST_PATTERN = re.compile(rf"^{DIGEST_REGEX}$")

CONTAINER_IMAGE_REFERENCE_REGEX = (
    rf"^{NAME_REGEX}(?::{TAG_REGEX})?(?:@{DIGEST_REGEX})?$"
)


def ensure_container_image(image: str) -> str:
    # We do not use CONTAINER_IMAGE_REFERENCE_REGEX directly here for execution time performance reasons.
    # Splitting the input image string into its constituent parts reduces the worst case execution time of the
    # function because the number of wildcards (combinations) considered for each regular expression evaluation
    # is smaller.
    digest_separator_index = image.rfind("@")
    if digest_separator_index >= 0:
        digest = image[digest_separator_index + 1 :]
        if not DIGEST_PATTERN.match(digest):
            raise ValueError(
                f"Invalid container image digest: {digest} ({image=}, {DIGEST_REGEX=})"
            )

    tag_end_index = (
        digest_separator_index if digest_separator_index >= 0 else len(image)
    )
    tag_separator_index = image.rfind(":", 0, tag_end_index)
    tag = image[tag_separator_index + 1 : tag_end_index]
    # Ensure that a separator from the domain is not considered as the tag separator
    tag_separator_index = tag_separator_index if "/" not in tag else -1
    if tag_separator_index >= 0:
        if not TAG_PATTERN.match(tag):
            raise ValueError(
                f"Invalid container image tag: {tag} ({image=}, {TAG_REGEX=})"
            )

    name_end_index = tag_separator_index if tag_separator_index >= 0 else tag_end_index
    name = image[:name_end_index]
    if not NAME_PATTERN.match(name):
        raise ValueError(
            f"Invalid container image name: {name} ({image=}, {NAME_REGEX=})"
        )
    return image
```

The `ensure_container_image()` function together with corresponding tests are made available on [GitHub](https://github.com/ovidiuparvu/ensure-container-image).