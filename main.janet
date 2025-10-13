(import circlet)
(import http) # http client lib from joy framework
(import markable)
(import spork/path :as path)
(import ./orderly-mach/db :as db)
(import ./orderly-mach/util :as util)
(import ./orderly-mach/posts :as posts)



(def posts-path (get (os/environ) "POSTSPATH" "~/posts"))
(def default-page (get (os/environ) "DEFAULTPAGENAME" "site-home.md"))
(def pages (posts/prepare-pages posts-path))

(defn main [& args]
  (pp "running server now...")
  (circlet/server
    (->
      pages    # table of routes
      circlet/router                # router middleware, accepts table of routes
      circlet/logger)               # logger middleware, accepts next middleware to be called within
    8000 "0.0.0.0"))
