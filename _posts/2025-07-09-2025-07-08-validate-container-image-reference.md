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
# Hosts specified as IP addresses are not supported in this implementation
LOWER_ALPHA_NUMERIC_REGEX = r'[a-z0-9]'
ALPHA_NUMERIC_REGEX = r'[a-zA-Z0-9]'
SEPARATOR_REGEX = r'[_.]|__|[-]*'

DOMAIN_COMPONENT_REGEX = fr'(?:[a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9])'
DOMAIN_NAME_REGEX = fr'{DOMAIN_COMPONENT_REGEX}(?:\.{DOMAIN_COMPONENT_REGEX})*'
HOST_REGEX = fr'{DOMAIN_NAME_REGEX}'
PORT_NUMBER_REGEX = r'[0-9]+'
DOMAIN_REGEX = fr'{HOST_REGEX}(?::{PORT_NUMBER_REGEX})?'

PATH_COMPONENT_REGEX = fr'{ALPHA_NUMERIC_REGEX}+(?:{SEPARATOR_REGEX}{ALPHA_NUMERIC_REGEX}+)*'
REMOTE_NAME_REGEX = fr'{PATH_COMPONENT_REGEX}(?:/{PATH_COMPONENT_REGEX})*'
NAME_REGEX = fr'(?:{DOMAIN_REGEX}/)?{REMOTE_NAME_REGEX}'

TAG_REGEX = r'[\w][\w.-]{0,127}'

DIGEST_HEX_REGEX = r'(?:[a-fA-F0-9]{32,})'
DIGEST_ALGORITHM_COMPONENT_REGEX = r'(?:[A-Za-z][A-Za-z0-9]*)'
DIGEST_ALGORITHM_SEPARATOR_REGEX = r'[+.-_]'
DIGEST_ALGORITHM_REGEX = fr'{DIGEST_ALGORITHM_COMPONENT_REGEX}(?:{DIGEST_ALGORITHM_SEPARATOR_REGEX}{DIGEST_ALGORITHM_COMPONENT_REGEX})*'
DIGEST_REGEX = fr'{DIGEST_ALGORITHM_REGEX}:{DIGEST_HEX_REGEX}'

CONTAINER_IMAGE_REFERENCE_PATTERN = re.compile(
    fr'^{NAME_REGEX}(?::{TAG_REGEX})?(?:@{DIGEST_REGEX})?$'
)

def ensure_container_image(image: str) -> str:
    if not CONTAINER_IMAGE_REFERENCE_PATTERN.match(image):
        raise ValueError(f"Invalid container image reference: {image}")
    return image
```

The `ensure_container_image()` function together with corresponding tests are made available on [GitHub](https://github.com/ovidiuparvu/ensure-container-image).