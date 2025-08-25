# Resolve Tilde

Resolve Tilde is a quick and easy package to, well, resolve tildes. Tildes are the wavy symbols (`~`) that Dart can't naturally expand.

## Notes

- This package is in beta and has not yet been universally tested.

## Platform Support

| Platform | Supported | Notes |
| -------- | --------- | ----- |
| Windows | ✅ | Supported as of version 0.0.0
| macOS | ✅ | Supported as of version 0.0.0
| Linux | ✅ | Supported as of version 0.0.0
| Android | 🟥 |
| iOS | 🟥 |
| Fuchsia | 🟥 |
| Web | 🟥 |

## Layout

This package includes some constants.

- `tilde`: This is defined in the top level, so if the package is imported, you can simply reference `tilde` to get `~` as a `String`.
- `Tilde.tilde`: This is the exact same thing as the above constant, except it's a static member of the `Tilde` class.