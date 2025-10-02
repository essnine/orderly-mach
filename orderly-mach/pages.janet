(use spork/htmlgen)


# need to define a syntax/spec here for how to describe list elements as I
# need them for building pages
# considerations:
# has href?
# has custom nested tags?
# has custom tag attributes?
# can be composed recursively?

(defn get-as-list [list-contents is-ordered?]
    (each element list-contents)
    )