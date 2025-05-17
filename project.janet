(declare-project
  :name "orderly-mach"
  :description ```website stuff ```
  :version "0.0.0"
  :dependencies ["https://github.com/janet-lang/circlet.git" "https://github.com/pyrmont/markable" "https://github.com/joy-framework/http" "https://github.com/pyrmont/musty" "https://github.com/janet-lang/spork.git"])

(declare-source
  :prefix "orderly-mach"
  :source ["orderly-mach/init.janet"])
