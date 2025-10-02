(import /orderly-mach/db :as db)


(defn get-pages-as-list [filter-condition]
    (print filter-condition)
    ()
)

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
