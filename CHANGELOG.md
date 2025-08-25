## 0.0.0

- Initial beta version. This package has not been universally tested yet.

# 0.0.1

- New `Tilde.resolveOrNull` function for safety.
- `HomeDirectoryNotFoundException`'s `reasons` list is now `List<Object?>` instead of `List<Object>` for extra internal safety. The `reasons` list is now filtered out at message creation.