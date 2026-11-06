# Table of contents

* [API Specs](README.md)

## Guides

* [Authentication](guides/authentication.md)
* [Pagination and filtering](guides/pagination-and-filtering.md)
* [Versioning](guides/versioning.md)
* [API changelog](guides/changelog.md)

## Reference

* [ApplySG API](reference/README.md)
* ```yaml
  type: builtin:openapi
  props:
    models: true
    downloadLink: true
  dependencies:
    spec:
      ref:
        kind: openapi
        spec: applysg-api
  ```
