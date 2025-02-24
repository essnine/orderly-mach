# orderly-mach

At the moment, I want this program to emit a binary containing a sqlite db with all the posts I want to publish or serve, and a circlet server that hosts the endpoints serving the posts. The program can be part of a build pipeline running on github actions or some equivalent CI/CD runner, and the flow will then be something like:

- a github action script with this program is added to a repo of markdown files
- the action fetches and executes this program, emitting one of these:
  - a binary for the posts server
  - a sqlite3 db containing the posts and some metadata
- the subsequent steps in the action take the binary and pass it to flyio or something
- flyio servers from the binary
