(import markable :as mk)
(import spork/mdz :as mdz)
(import spork/path :as path)
(import /orderly-mach/util :as util)
(import /orderly-mach/pages :as pages)

(defn add-content-to-html [md-text]
  (def base-html-template (string (slurp "./orderly-mach/templates/index.html")))
  (string/replace "{{ content }}" (mk/markdown->html md-text) base-html-template))

(defn add-links-to-html [links html-body]
  (string/replace
    "{{ links }}" (
      pages/generate-html-sidebar-list
      links) html-body))

(defn convert-mdn-to-html [mdn-table]
  (var html-table @{})
  (loop [pair :in (pairs mdn-table)]
    (pp pair)
    (put html-table (pair 0)
         {:headers {:content-type "text/html"}
          :body (add-content-to-html (pair 1))}))
  html-table)

(defn load-files
  "Load file text into memory" [posts-path]
  (var files @{})
  (def expanded-posts-path (util/expand-tilde posts-path))
  (loop [filepath :in (os/dir expanded-posts-path)]
    (print "processing filepath: " filepath)
    (if (= (path/ext filepath) ".md")
      (do 
        (put files 
          (util/trim-file-name-for-path (util/get-filename filepath)) 
          (string (slurp (string/join @[expanded-posts-path filepath] "/")))))
      (print "Skipping file: " filepath)))
  files)

(defn prepare-pages [posts-path]
  (def file-html-table (convert-mdn-to-html (load-files posts-path)))
  (put file-html-table :default (file-html-table "/home"))
  (put file-html-table
    "/favicon.ico" {
      :kind :file
      :file "./orderly-mach/templates/favicon.png"
      :mime "image/png"})
  (pp (keys file-html-table))
  file-html-table)
