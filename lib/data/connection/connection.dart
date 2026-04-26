// This file uses conditional exports to isolate platform-specific database 
// implementations. This is crucial for WASM builds, which strictly forbid 
// any reach into libraries that use 'dart:ffi' (like sqlite3 native).

export 'unsupported.dart'
  if (dart.library.ffi) 'native.dart'
  if (dart.library.js_interop) 'web.dart';
