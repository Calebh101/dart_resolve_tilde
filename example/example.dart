import 'dart:io';

import 'package:resolve_tilde/resolve_tilde.dart';

void main() {
  print("Top-level tilde: $tilde");
  print("Static nested tilde: ${Tilde.tilde}");

  if (Platform.isWindows) {
    print("User directory: ${Tilde.resolve()}");
    print("Local AppData directory: ${Tilde.resolve("~\\AppData\\Local")}");
  } else if (Platform.isMacOS) {
    print("User directory: ${Tilde.resolve()}");
    print("Documents directory: ${Tilde.resolve("~/Documents")}");
  } else if (Platform.isLinux) {
    print("User directory: ${Tilde.resolve()}");
    print("Screenshots directory: ${Tilde.resolve("~/Pictures/Screenshots")}");
  } else {
    throw UnsupportedError("Invalid platform: ${Platform.operatingSystem}");
  }
}
