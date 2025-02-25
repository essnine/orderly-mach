# orderly-mach

At the moment, I want this program to emit a binary containing a sqlite db with all the posts I want to publish or serve, and a circlet server that hosts the endpoints serving the posts. The program can be part of a build pipeline running on github actions or some equivalent CI/CD runner, and the flow will then be something like:

- a github action script with this program is added to a repo of markdown files
- the action fetches and executes this program, emitting one of these:
  - a binary for the posts server
  - a sqlite3 db containing the posts and some metadata
- the subsequent steps in the action take the binary and pass it to flyio or something
- flyio or whatever serves the posts from the binary

The reasons for working it out like this is entirely personal and one I am not going to second-guess for the purposes of this project - I hate seeing apps that should be self-contained programs turned into archives containing thousands of files for no purpose - I don't want configuration to look the same as the contents - I want the contents to sit within the fat binary first and then mayb be accessible and extensible while they're there, since ideally they'll be read or altered more often than reused in some way.

I also have this belief I want to run with for now: programs should be packaged into units when they are built, and then tested to make sure that the behavior lines up with expectations we have from the source code. This makes a build step a discrete transition from code to product, reducing the possibility pf using "hacks" of any sort to mitigate runtime issues, and it makes the programs truly distributable.

(I'll add more as hopefully my thoughts start to become more coherent with time and implementation.)

So far in, here's what's working and what's not. This is not an exhaustive list but it covers what I want to have done:
- [x] I can load pages
- [x] Pages are populated by content from markdown pages
- [x] favicon and font resources are working
- [-] Page styling works as expected
  - [x] Markdown converted to HTML and embedded looks OK
  - [ ] Can point the app to a custom HTML template
  - [ ] Static content picked up instead of hardcoded (this should be a quick circlet thing but I'll do it later)
  - [ ] ??? (Something will occur to me in a dream)
- [ ] Images or links in markdown are handled
- [ ] Loads everything into sqlite
- [ ] Emits binaries containing full site
- [ ] Composing HTML using the html module in the stdlib instead of the custom template
  - [ ] Compositional CSS and interactive elements
  - [ ] or HTMX
- [ ] ??? (Something will occur to me in a dream)
