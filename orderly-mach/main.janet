(import circlet)
(import markable)
(import peg)

(defn load-files
	"Load file text into memory" [paths]
	(var files @{})
	(loop [filepath :in paths]
		(if (= (path/ext filepath) "md")
			(set files (trim-file-name-for-path filepath) (slurp filepath))
			(print "Skipping file: " filepath)
		)
	)
	files
)

(defn trim-file-name-for-path [filename]
	(if-let (< 32 (length filename))
		(trimmed-filename (string/slice filename 0 -32))
		(trimmed-filename filename)
	)
	(let cleaned-filename (peg/replace-all ':W+ "-" trimmed-filename))
	(let stub (string/slice 0 -8 (hash cleaned-filename)))
	(let filename-url-path (string/join @(cleaned-filename stub) "-"))
	filename-url-path
	)

(defn convert-mdn-to-html [mdn-table]
	(var html-table @{})
	(loop [pair :in (pairs mdn-table)]
		(set html-table (pair 0) (markable/markdown->html (pair 1)))
	)
	html-table
)

(defn prepare-paths [paths]
	(def filetext-table (load-files paths))
	(def filehtml-table (convert-mdn-to-html filetext-table))
	(print (keys filehtml-table))
	filehtml-table
)


(circlet/server
	(-> 
		(prepare-paths "./posts")
		circlet/router
		circlet/logger)
	8000)
