(declare-project
  :name "orderly-mach"
  :description ```website stuff ```
  :version "0.0.0"
  :dependencies [
    "https://github.com/janet-lang/circlet.git"
    "https://github.com/pyrmont/markable"
    "https://github.com/joy-framework/http"
    "https://github.com/janet-lang/spork.git"
    "https://github.com/janet-lang/sqlite3"])

(declare-executable
  :name "orderly-mach"
  :entry "orderly-mach/main.janet"
  :install false)
