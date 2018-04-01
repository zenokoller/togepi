# Togepi Timer

An egg timer written in Elm that emulates the stock iOS timer functionality.
Bundled as an Electron app using [this guide](https://medium.com/@ezekeal/building-an-electron-app-with-elm-part-1-boilerplate-3416a730731f).

## Running & Building 

### Elm Version in Browser

```
elm-install
elm-reactor
```

### Electron Version with Debugging

```
elm-install
elm make src/elm/Main.elm --output dist/elm/elm.js
electron src/electron/main.js
```

### Packaged Electron Version

```
elm-install
elm make src/elm/Main.elm --output dist/elm/elm.js
electron src/electron/main.js
```

## To Do:

- Add alert sound
- Use space instead of "s" (need to disable button focus)
- [Add menu and ⌘ + H](https://www.christianengvall.se/electron-menu/)