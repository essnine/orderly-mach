(use spork/htmlgen)
(use spork/mdz)

# I can use:
# - mdz for rendering the posts?
# - temple for the posts/forms/pages

(defn get-href-tag-item [raw-item]
    @{:link (raw-item 0) :text (raw-item 1)})

(defn get-as-list [list-contents is-ordered? &opt item-format-func]
    (def items @[  ])
    (each element list-contents
        (array/push items (item-format-func element)))
    (if (is-ordered?)
        (def tag-type "ol" ))
        (def tag-type "ul"))


(defn get-new-post-page [&args]
    ())


# page list will be sent to the template as a list of 
# tuples with title and link


(defn get-list-item-with-href [text link]
    (pp text)
    (pp link)
    (string/join [
        "<li href='"
        link
        "' target='_blank'>"
        text
        "</li>"]))

(defn generate-html-sidebar-list [posts-map]
    (def post-list-structure @[:ul ])
    (each post-item posts-map (
        array/push post-list-structure
        (get-list-item-with-href (post-item :title) (post-item :path))))
    (html post-list-structure))
