(import circlet)

(defn myserver
  "A simple HTTP server" [request]
  {:status 200
   :headers {"Content-Type" "text/html"} :body "Hello world!"})

(circlet/server myserver 8000)
