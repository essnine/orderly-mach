(import /orderly-mach/db :as db)


(defn get-pages-as-list [filter-condition]
    (print filter-condition)
    ()
)

(defn load-sidebar []
    (print "Loading sidebar elements...")
    (def conn (db/get-database-connection "site.sqlite.db"))
    (def post-list (db/get-post-list-for-linking conn))
    (def sidebar-elems @[])
    (each post post-list (array/push sidebar-elems @{:id (post :id) :title (post :title) :page-path (post "path")}))
    sidebar-elems)