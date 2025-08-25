/// Support for resolve_tilde.
/// 
/// This library contains a top-level [tilde] variable that is the constant string of '~' and a [Tilde] class for the functions.
library;

import 'dart:io';

/// Constant string of '~'.
const String tilde = "~";

/// This exception is called when the resolver cannot find a home directory through the several methods used. This exception doesn't have a specific message, but instead uses the list [reasons] to gather every single reason that went wrong, then turn that into the [message] variable.
class HomeDirectoryNotFoundException implements Exception {
  /// Every single reason this exception went wrong. These can be descriptions, other exceptions/errors, etcetera.
  final List<Object> reasons;

  /// Combines [reasons] to make a message. If [reasons] is not provided, nothing is returned.
  String? get message => reasons.isNotEmpty ? reasons.map((x) => x.toString()).join(", ") : null;

  /// The constructor for [HomeDirectoryNotFoundException].
  /// 
  /// If [reasons] is not provided or is empty, then a message will not be generated.
  HomeDirectoryNotFoundException([this.reasons = const []]);

  /// Makes the exception a string and displays the different reasons. If [reasons] is empty, then no message is shown.
  @override
  String toString() {
    return ["HomeDirectoryNotFoundException for platform ${Platform.operatingSystem}", if (message != null) message].join(": ");
  }
}

/// The main class for resolving tildes. This class cannot be instantiated.
/// 
/// [tilde] is a constant string of '~', exactly like the top-level tilde variable.
class Tilde {
  /// Constant string of '~', exactly like the top-level tilde variable.
  static const String tilde = "~";

  // Private constructor.
  const Tilde._();

  /// Resolve a tilde in the specified [path] argument. [path] defaults to just a tilde. If the included path does not start with a tilde, then the path is just returned as-is.
  /// 
  /// The function uses several different methods of trying to obtain the home directory. Both platforms start with just trying to get an environmental variable, but will use [Process.run] if necessary. If they all fail, a [HomeDirectoryNotFoundException] is thrown containing details of each thing that went wrong.
  /// 
  /// Windows, macOS, and Linux are valid platforms. macOS and Linux use the same tactics. If a supported platform is not found, an [UnsupportedError] is thrown. If this is called on the web, then an error will be called even before [UnsupportedError] due to [Platform] being unsupported on the web.
  static String resolve([String path = tilde]) {
    if (!path.startsWith(tilde)) return path;
    String replaceWith;

    if (Platform.isLinux || Platform.isMacOS) {
      String? foundEnv = Platform.environment["HOME"];

      if (foundEnv?.isNotEmpty ?? false) {
        return foundEnv!;
      } else {
        try {
          ProcessResult result = Process.runSync('sh', ['-c', 'echo $tilde']);
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

    return path.replaceFirst(tilde, replaceWith);
  }
}
