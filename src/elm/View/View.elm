module View exposing (view)

import Html exposing (Html, button, div, input, text, node, span)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (..)
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row
import Bootstrap.Grid.Col as Col

import Model exposing (..)
import View.Utils exposing (secondsToString, twoDigitString)

view : Model -> Html Msg
view model =
  Grid.containerFluid [ class "timer-container" ]
  [ node "link" [ rel "stylesheet", href "../css/bootstrap.min.css" ] []
  , node "link" [ rel "stylesheet", href "../css/style.css" ] []
  , Grid.row [] 
    [ Grid.col [ Col.attrs [ class "time-view" ]] 
      [ timeView model ] 
    ]
  , Grid.row [ Row.attrs [ class "controls" ]] 
    [ Grid.col [ Col.xs6 ]
      [
        button [ class "btn btn-secondary", onClick Reset ] [ text "Reset" ] 
      ]
    , Grid.col [ Col.xs6 ] 
      [
        startButton model
      ]
    ]
  ]

timeView : Model -> Html Msg
timeView model = 
  case model.timerState of 
    Editing -> 
      let (h, m, s) = model.timeSetting in div []
        [ input [ type_ "text", placeholder "00", value (twoDigitString h), onInput SetHours ] []
        , text ":"
        , input [ type_ "text", placeholder "00", value (twoDigitString m), onInput SetMinutes ] []
        , text ":"      
        , input [ type_ "text", placeholder "00", value (twoDigitString s), onInput SetSeconds ] []
        ]
    _ -> 
      let s = model.time in div []
        [
          span [] [ text (secondsToString s)]
        ] 

startButton : Model -> Html Msg
startButton model = case model.timerState of 
  Ticking -> button [ class "btn btn-primary", onClick Pause ] [ text "Pause"]
  _ -> button [ class "btn btn-primary", onClick Start ] [ text "Start"]
