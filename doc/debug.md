## `sugar.debug`
Sugar features a simple debug log system with errors, warnings and simple messages.
The logs will be saved locally, at `%appdata%\LOVE\[project (or Castle)]` if on Windows, and at `/Users/user/Library/Application Support/LOVE/[project (or castle)]` if on Mac.
If you are using Castle, the logs will also appear in the development console.

#### `sugar.debug.start_log([file_name = "log.txt"])`
- Initializes the log system.
- The log will be saved to 'file_name' on the system.

#### `sugar.debug.end_log()`
- Closes the log.
- Is called automatically on shutdown.

#### `sugar.debug.log(str)`
- Puts a new line in the log with the information 'str'.

#### `sugar.debug.w_log(str)`
- Puts a new **warning** line in the log with the information 'str'.

#### `sugar.debug.r_log(str)`
- Puts a new **error** line in the log with the information 'str'.

#### `sugar.debug.assert(condition, str)`
- Checks the condition and crashes if it isn't true. Logs and outputs the message 'str' on crash.

#### `sugar.debug.abort(str)`
- Shuts down sugar and terminates the program.

#### `sugar.debug.abort_brutal(str)`
- Terminates the program immediately, without shuting down sugar.

#### `sugar.debug.write_clipboard(str)`
- Writes 'str' to the system clipboard.

#### `sugar.debug.read_clipboard()`
- Reads the system clipboard.
- Returns the clipboard's content as a string.
