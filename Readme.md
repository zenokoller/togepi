# Togepi Timer

An egg timer written in Elm that emulates the stock iOS timer functionality.
Bundled as an Electron app using [this guide](https://medium.com/@ezekeal/building-an-electron-app-with-elm-part-1-boilerplate-3416a730731f).

## Install

```
elm-install
elm make Main.elm --output elm.js
electron main.js
```

## To Do:

- Add keyboard controls
- Add alert sound
- Structure & refactor: See [here](https://becoming-functional.com/nine-guidelines-for-modular-elm-development-fe18d2f7885e) and [here](http://blog.jenkster.com/2016/04/how-i-structure-elm-apps.html)
- Make Electron bundle nicer
    - Fix editor layout
    - Include font with `@font-face`
    - Use [frameless window](https://electronjs.org/docs/api/frameless-window). Also consider dragging, see [here](https://medium.com/developers-writing/building-a-desktop-application-with-electron-204203eeb658)
    - Disallow resize
    - [Add app icon](https://www.christianengvall.se/electron-app-icons/)
- Use [electron-builder](https://github.com/electron-userland/electron-builder)
