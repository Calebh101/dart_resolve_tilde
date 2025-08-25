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
| Android | 🟥 | Unsupported due to restricted filesystem
| iOS | 🟥 | Unsupported due to restricted filesystem
| Web | 🟥 | Unsupported due to no filesystem

## Layout

### Constants

- `tilde`: This is defined in the top level, so if the package is imported, you can simply reference `tilde` to get `~` as a `String`.
- `Tilde.tilde`: This is the exact same thing as the above constant, except it's a static member of the `Tilde` class.

### Classes

`Tilde`: This is the main class for containing resources for resolving tildes.
- Static constant `Tilde.tilde`: Discussed above.
- Static `String` function `Tilde.resolve()`: This function is what actually resolves the tildes.
    - You can pass an optional positional `path` parameter to specify the path to actually expand. The default is just a tilde.
    - Note that this function does not fully expand the path; it only expands the first tilde in the included path if that tilde is at the beginning of the path.

## Usage

### Constants

```dart
import 'package:resolve_tilde/resolve_tilde.dart';

print(tilde);       // Output: '~'
print(Tilde.tilde); // Output: '~'
```

## Resolving

```dart
import 'package:resolve_tilde/resolve_tilde.dart';

if (Platform.isWindows) {
    print(Tilde.resolve());                         // Output: 'C:\Users\user'
    print(Tilde.resolve("~\\AppData\\Local"));      // Output: 'C:\Users\user\AppData\Local'
} else if (Platform.isMacOS || Platform.isLinux) {
    print(Tilde.resolve());                         // Output: '/home/user' or similar
    print(Tilde.resolve("~/Pictures/Screenshots")); // Output: '/home/user/Pictures/Screenshots' or similar
}
```