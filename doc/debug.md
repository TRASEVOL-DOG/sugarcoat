## `sugar. debug`
Sugar features a simple debug log system with errors, warnings and simple messages.
The logs will be saved locally, at `%appdata%\LOVE\[project  (or Castle)]` if on Windows, and at `/Users/user/Library/Application Support/LOVE/[project  (or castle)]` if on Mac.
If you are using Castle, the logs will also appear in the development console.

- Contents:
  - [`start_log(file_name)`](#sugardebug-start_log-file_name--logtxt)
  - [`end_log()`](#sugardebug-end_log-)
  - [`catch_logs(foo)`](#sugardebug-catch_logs-foo)
  - [`log(str)`](#sugardebug-log-str)
  - [`w_log(str)`](#sugardebug-w_log-str)
  - [`r_log(str)`](#sugardebug-r_log-str)
  - [`assert(condition,str)`](#sugardebug-assert-condition-str)
  - [`abort(str)`](#sugardebug-abort-str)
  - [`abort_brutal(str)`](#sugardebug-abort_brutal-str)
  - [`write_clipboard(str)`](#sugardebug-write_clipboard-str)
  - [`read_clipboard()`](#sugardebug-read_clipboard-)

&#8202;

#### `sugar.debug. start_log ([file_name = "log.txt"])`
- Initializes the log system.
- The log will be saved to 'file_name' on the system.
- This is called by `init_sugar(...)`

&#8202;

#### `sugar.debug. end_log ()`
- Closes the log.
- Is called automatically on shutdown.

&#8202;

#### `sugar.debug. catch_logs (foo)`
- The function `foo` will be called every time a new line appears in the log, with that new line's content as a string argument.
- Can be useful to draw log lines on-screen.
- /!\ Do not call any of the logging functions inside `foo` or else **an infinite loop will occur**.

&#8202;

#### `sugar.debug. log (str)`
- Puts a new line in the log with the information 'str'.

&#8202;

#### `sugar.debug. w_log (str)`
- Puts a new **warning** line in the log with the information 'str'.

&#8202;

#### `sugar.debug. r_log (str)`
- Puts a new **error** line in the log with the information 'str'.

&#8202;

#### `sugar.debug. assert (condition, str)`
- Checks the condition and crashes if it isn't true. Logs and outputs the message 'str' on crash.

&#8202;

#### `sugar.debug. abort (str)`
- Shuts down sugar and terminates the program.

&#8202;

#### `sugar.debug. abort_brutal (str)`
- Terminates the program immediately, without shuting down sugar.

&#8202;

#### `sugar.debug. write_clipboard (str)`
- Writes 'str' to the system clipboard.

&#8202;

#### `sugar.debug. read_clipboard ()`
- Reads the system clipboard.
- Returns the clipboard's content as a string.
