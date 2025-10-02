# orderly-mach

At the moment, I want this program to emit a binary containing a sqlite db with all the posts I want to publish or serve, and a circlet server that hosts the endpoints serving the posts. The program can be part of a build pipeline running on github actions or some equivalent CI/CD runner, and the flow will then be something like:

- a github action script with this program is added to a repo of markdown files
- the action fetches and executes this program, emitting one of these:
  - a binary for the posts server
  - a sqlite3 db containing the posts and some metadata
- the subsequent steps in the action take the binary and pass it to flyio or something
- flyio or whatever serves the posts from the binary

The reasons for working it out like this is entirely personal and I am not going to second-guess for the purposes of this project - I hate seeing apps that should be self-contained programs turned into archives containing thousands of files for no purpose - I don't want configuration to look the same as the contents - I want the contents to sit within the fat binary first and then maybe be accessible and extensible while they're there, since ideally they'll be read or altered more often than reused in some way.

I also have this belief I want to run with for now: programs should be packaged into units when they are built, and then tested to make sure that the behavior lines up with expectations we have from the source code. This makes a build step a discrete transition from code to product, reducing the possibility pf using "hacks" of any sort to mitigate runtime issues, and it makes the programs truly distributable.

(I'll add more as hopefully my thoughts start to become more coherent with time and implementation.)

So far in, here's what's working and what's not. This is not an exhaustive list but it covers what I want to have done:
- [x] I can load pages
- [x] pages are populated by content from markdown pages
- [x] favicon and font resources are working
- [ ] page styling works as expected
  - [x] markdown converted to HTML and embedded looks OK
  - [x] can point the app to a custom HTML template
  - [x] static content picked up instead of hardcoded (this should be a quick circlet thing but I'll do it later)
- [x] images or links in markdown are handled
- [ ] loads everything into sqlite
- [ ] ~~emits binaries containing full site~~ not doing this for now because I'm daily driving a mac and I don't want to bother with the binaries stuff
- [ ] composing HTML using the html module in the stdlib instead of the custom template
  - [ ] compositional CSS and interactive elements
  - [ ] or HTMX ???
- [ ] ??? (something will occur to me in a dream)
- [ ] I need to document the env vars in use here


#### Notes on the code, Janet, JPM stuff:
- Installing sqlite3 is a little complicated - I found this flag to set before building deps, like so: `PKG_CONFIG_ALLOW_SYSTEM_CFLAGS=1 jpm -l deps`
- Most packages are listed in the JPM package repo so I can just pass a string instead of a table - I need the latter in case I want to pass a specific version
