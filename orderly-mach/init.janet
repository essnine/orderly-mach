(import circlet)
(import http) # http client lib from joy framework
(import markable)
(import path)


(defn get-filename [filepath]
  (path/basename filepath))

(defn trim-file-name-for-path [filename]
  (var trimmed-filename "")
  (if (< 32 (length filename))
    (do
      (set
        (trimmed-filename (string/slice filename 0 -32))
        (trimmed-filename filename))))
  (def cleaned-filename (peg/replace-all ':W+ "-" trimmed-filename))
  (def stub (string/slice 0 -8 (hash cleaned-filename)))
  (def filename-url-path (string/join @[cleaned-filename stub] "-"))

  filename-url-path)

(defn convert-mdn-to-html [mdn-table]
  (var html-table @{})
  (loop [pair :in (pairs mdn-table)]
    (put html-table (pair 0) (markable/markdown->html (pair 1))))
  html-table)

(defn expand-tilde [path]
  (if (string/has-prefix? "~/" path)
    (string (os/getenv "HOME") (string/slice path 1))
    path))

(defn load-files
  "Load file text into memory" [posts-path]
  (var files '{})
  (def files-in-path (os/dir (expand-tilde posts-path)))
  (print files-in-path)
  (loop [filepath :in files-in-path]
    (print "processing filepath: " filepath)
    (if (= (path/ext filepath) "md")
      (do (var filename (get-filename filepath))
        (put files (trim-file-name-for-path filename) (slurp filepath))
        (print "Skipping file: " filepath))))

  files)

(defn prepare-pages [posts-path]
  (def filetext-table (load-files posts-path))
  (def filehtml-table (convert-mdn-to-html filetext-table))
  (print (keys filehtml-table))
  filehtml-table)

(def posts-path (get (os/environ) "POSTSPATH" "~/posts"))

(circlet/server
  (->
    (prepare-pages posts-path)
    circlet/router
    circlet/logger)
  8000)
