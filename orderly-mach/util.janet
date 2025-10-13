(import spork/path :as path)
(import /orderly-mach/db :as db)


(defn get-pages-as-list [filter-condition]
    (print filter-condition)
    ()
)



(def header-links @[@{:path "/" :title "Home"} @{:path "/posts" :title "posts"} @{:path "/about" :title "About"}])

(defn load-sidebar []
    (print "Loading sidebar elements...")
    (def conn (db/get-database-connection "site.sqlite.db"))
    (def post-list (db/get-post-list-for-linking conn))
    (def sidebar-elems @{})
    (pp post-list)
    (each post post-list (do 
        (def post-row (table 
            :id (post :id)
            :title (post :title)
            :path (post :path)
            :created-at (post :created)))
        (put sidebar-elems (post :path) post-row)))
    sidebar-elems)


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


(defn expand-tilde [path]
  (var fixed-path path)
  (if (string/has-prefix? "~/" path)
    (set fixed-path (string/join @[(os/getenv "HOME") (string/slice path 1)] "")))
  fixed-path)
