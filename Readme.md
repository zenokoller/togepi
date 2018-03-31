# Togepi Timer

An egg timer written in Elm that emulates the stock iOS timer functionality.
Bundled as an Electron app using [this guide](https://medium.com/@ezekeal/building-an-electron-app-with-elm-part-1-boilerplate-3416a730731f).

## Install

```
elm-install
elm make src/elm/Main.elm --output dist/elm.js
electron src/electron/main.js
```

## To Do:

- Refactor update into separate functions
- Add alert sound
- Use space instead of "s" (need to disable button focus)
- [Add app icon](https://www.christianengvall.se/electron-app-icons/)
- Use [electron-builder](https://github.com/electron-userland/electron-builder)
