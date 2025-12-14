(declare-project
  :name "orderly-mach"
  :description ```website stuff ```
  :version "0.0.1"
  :dependencies [
    "https://github.com/pyrmont/markable"
    "https://github.com/janet-lang/spork.git"
    "https://github.com/janet-lang/sqlite3"
    "https://github.com/janet-lang/circlet.git"])

(declare-executable
  :name "orderly-mach"
  :entry "main.janet"
  :install false)
