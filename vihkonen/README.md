# Vihkonen

Simple tool to help track expenses by ingesting a csv export provided by my bank. Work in progress.

Vihkonen, among other things, is a Finnish word for a small notebook, which is what I previously used for the same purpose.


## Dev notes

### Running

1. Run `yarn watch` to start the development version of the app.

### Releasing

1. Run `yarn release` to build a production version of the app.

### REPL

1. Connect to the `shadow-cljs` nREPL:
    ```sh
    lein repl :connect localhost:8777
    ```
    The REPL prompt, `shadow.user=>`, indicates that is a Clojure REPL, not ClojureScript.

2. In the REPL, switch the session to this project's running build id, `:app`:
    ```clj
    (shadow.cljs.devtools.api/nrepl-select :app)
    ```
    The REPL prompt changes to `cljs.user=>`, indicating that this is now a ClojureScript REPL.
3. See [`user.cljs`](dev/cljs/user.cljs) for symbols that are immediately accessible in the REPL
without needing to `require`.
