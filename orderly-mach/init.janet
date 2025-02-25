(import circlet)
(import http) # http client lib from joy framework
(import markable)
(import path)


(defn get-filename [filepath]
  (path/basename filepath))

(defn trim-file-name-for-path [filename]
  (var trimmed-filename "")
  (if (< 32 (length filename))
    (set trimmed-filename (string/slice filename 0 -32))
    (set trimmed-filename filename)
    )
  (def cleaned-filename (peg/replace-all ':W+ "-" trimmed-filename))
  (def filename-url-path (string "/" cleaned-filename))

  filename-url-path)

(defn convert-mdn-to-html [mdn-table]
  (def base-html-template (string (slurp "./orderly-mach/templates/home.html")))
  (var html-table @{})
  (loop [pair :in (pairs mdn-table)]
    (pp pair)
    (put html-table (pair 0) 
    {
          :headers {:content-type "text/html"} 
          :body (string/replace "{{body_content}}" (markable/markdown->html (pair 1)) base-html-template )
        }
    )
    )
  html-table)

(defn expand-tilde [path]
  (var fixed-path path)
  (if (string/has-prefix? "~/" path)
      (set fixed-path (string/join @((os/getenv "HOME") (string/slice path 1)) ""))
    )
  fixed-path)

(defn load-files
  "Load file text into memory" [posts-path]
  (var files @{})
  (def expanded-posts-path (expand-tilde posts-path))
  (def files-in-path (os/dir expanded-posts-path))
  (pp files-in-path)
  (loop [filepath :in files-in-path]
    (print "processing filepath: " filepath)
    (if (= (path/ext filepath) ".md")
      (do (var filename (get-filename filepath))
        (def expanded-filepath (string/join @[expanded-posts-path filepath] "/"))
        (put files (trim-file-name-for-path filename) (string (slurp expanded-filepath) ) ))
        (print "Skipping file: " filepath)
      ))

  files)

(defn prepare-pages [posts-path]
  (def filetext-table (load-files posts-path))
  (def filehtml-table (convert-mdn-to-html filetext-table))
  (put filehtml-table :default {:kind :static :root "."})
  (put filehtml-table "/favicon.ico" {:kind :file :file "./orderly-mach/templates/favicon.png" :mime "image/png"})
  (put filehtml-table "/8BITWONDERNominal.woff2" {:kind :file :file "./orderly-mach/templates/8BITWONDERNominal.woff2" :mime "application/octet-stream"})
  (pp (keys filehtml-table))
  filehtml-table)

(var posts-path (get (os/environ) "POSTSPATH" "~/posts"))

(circlet/server
  (->
    (prepare-pages posts-path)
    circlet/router
    circlet/logger)
  8000)
