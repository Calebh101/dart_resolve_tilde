/// Support for resolve_tilde.
library;

import 'dart:io';

/// Constant string of "~".
const String tilde = "~";

class HomeDirectoryNotFoundException implements Exception {
  List<Object> reasons;

  HomeDirectoryNotFoundException(this.reasons);

  @override
  String toString() {
    return "HomeDirectoryNotFoundException for platform ${Platform.operatingSystem}: ${reasons.map((x) => x.toString()).join(", ")}";
  }
}

class Tilde {
  /// Constant string of "~".
  static const String tilde = "~";
  
  static String resolve([String path = "~"]) {
    String replaceWith;

    if (Platform.isLinux || Platform.isMacOS) {
      String? foundEnv = Platform.environment["HOME"];

      if (foundEnv?.isNotEmpty ?? false) {
        return foundEnv!;
      } else {
        try {
          ProcessResult result = Process.runSync('sh', ['-c', 'echo ~']);
          if (result.stdout.toString().isEmpty) throw Exception("stdout was empty");
          replaceWith = result.stdout.toString().trim();
        } catch (e) {
          try {
            ProcessResult result = Process.runSync('getent', ['passwd', Platform.environment['USER'] ?? '']);
            if (result.stdout.toString().isEmpty) throw Exception("stdout was empty");
            replaceWith = result.stdout.toString().trim();
          } catch (x) {
            throw HomeDirectoryNotFoundException(["Environmental variable 'HOME' was null or empty", e, x]);
          }
        }
      }
    } else if (Platform.isWindows) {
      String? foundEnv = Platform.environment["USERPROFILE"];

      if (foundEnv?.isNotEmpty ?? false) {
        return foundEnv!;
      } else {
        String? drive = Platform.environment['HOMEDRIVE'];
        String? path = Platform.environment['HOMEPATH'];

        if ([drive, path].every((x) => x != null)) {
          return "$drive$path";
        } else {
          try {
            ProcessResult result = Process.runSync('powershell', ['-Command', '[Environment]::GetFolderPath("UserProfile")']);
            replaceWith = result.stdout.toString().trim();
          } catch (e) {
            throw HomeDirectoryNotFoundException(["Environmental variable 'USERPROFILE' was null or empty", if (drive == null) "Environmental variable 'HOMEDRIVE' was null or empty", if (path == null) "Environmental variable 'HOMEPATH' was null or empty", e]);
          }
        }
      }
    } else {
      throw UnsupportedError("Invalid platform: ${Platform.operatingSystem}");
    }

    return path.replaceAll(tilde, replaceWith);
  }
}
