(import circlet)
(import http) # http client lib from joy framework
(import markable)
(import spork/path :as path)


(defn get-filename [filepath]
  (path/basename filepath))

(defn trim-file-name-for-path [filename]
  (var trimmed-filename "")
  (def filename-no-ext (string/slice filename 0 (- -1 (length (path/ext filename)))))
  (if (< 32 (length filename))
    (do
      (set trimmed-filename (string/slice filename-no-ext 0 -32)))
    (set trimmed-filename filename-no-ext))
  (def cleaned-filename (peg/replace-all ':W+ "-" trimmed-filename))
  (def filename-url-path (string "/" cleaned-filename))

  filename-url-path)

(defn convert-mdn-to-html [mdn-table]
  (def base-html-template (string (slurp "./orderly-mach/templates/home.html")))
  (var html-table @{})
  (loop [pair :in (pairs mdn-table)]
    (pp pair)
    (put html-table (pair 0)
         {:headers {:content-type "text/html"}
          :body (string/replace "{{body_content}}" (markable/markdown->html (pair 1)) base-html-template)}))
  html-table)

(defn expand-tilde [path]
  (var fixed-path path)
  (if (string/has-prefix? "~/" path)
    (set fixed-path (string/join @[(os/getenv "HOME") (string/slice path 1)] "")))
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
        (put files (trim-file-name-for-path filename) (string (slurp expanded-filepath))))
      (print "Skipping file: " filepath)))

  files)

(defn prepare-pages [posts-path]
  (def file-text-table (load-files posts-path))
  (def file-html-table (convert-mdn-to-html file-text-table))
  (put file-html-table :default {:kind :static :root "."})
  (put file-html-table "/favicon.ico" {:kind :file :file "./orderly-mach/templates/favicon.png" :mime "image/png"})
  (put file-html-table "/8BITWONDERNominal.woff2" {:kind :file :file "./orderly-mach/templates/8BITWONDERNominal.woff2" :mime "application/octet-stream"})
  (pp (keys file-html-table))
  file-html-table)

(def posts-path (get (os/environ) "POSTSPATH" "~/posts"))
(def default-page (get (os/environ) "DEFAULTPAGENAME" "site-home.md"))

(circlet/server
  (->
    (prepare-pages posts-path)    # table of routes
    circlet/router                # router middleware, accepts table of routes
    circlet/logger)               # logger middleware, accepts next middleware to be called within
  8000)
