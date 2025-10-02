(import sqlite3 :as sql)

(defn get-database-connection [db-path]
	(print "db path is " db-path)
	(def db (sql/open db-path))
	db)


(defn get-posts-from-db [db]
	(def posts (sql/eval db "SELECT * FROM POSTS;"))
	posts)

(defn get-post-by-id [db id]
	(def post (sql/eval db "SELECT * FROM POSTS WHERE ID=" id))
	(pp (type post))
	post)

(defn get-post-list-for-linking [db]
	(def post-list (sql/eval db "SELECT id, title, created, path, tags from POSTS where POSTS.active=1"))
	(pp post-list)
	post-list)
