module Main exposing (main)

import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Time exposing (Time, second)
import String exposing (padLeft)
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col


main = Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type TimerState = Paused | Ticking | Editing Bool

type alias Model = { 
  timeSetting: (Int, Int, Int),
  time: Int, 
  timerState: TimerState 
}

init : (Model, Cmd Msg)
init = let setting = (0, 25, 0) in let t = timeFromSetting setting in 
  ({timeSetting = setting, time = t, timerState = Paused }, Cmd.none)

timeFromSetting : (Int, Int, Int) -> Int
timeFromSetting (h, m, s) = h * 3600 + m * 60 + s

-- UPDATE

type Msg 
    = Tick Time
    | Start 
    | Pause 
    | Reset
    | SetHours String
    | SetMinutes String
    | SetSeconds String
    | ValidationError

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of 
    SetHours str -> 
      let (_, m, s) = model.timeSetting 
      in let h = Result.withDefault 0 (String.toInt str)
      in ({ model | timeSetting = (h, m, s), 
                    time = timeFromSetting (h, m, s), 
                    timerState = Editing True }, Cmd.none)

    SetMinutes str -> 
      let (h, _, s) = model.timeSetting 
      in let m = Result.withDefault 0 (String.toInt str)
      in ({ model | timeSetting = (h, m, s), 
                    time = timeFromSetting (h, m, s), 
                    timerState = Editing True }, Cmd.none)

    SetSeconds str -> 
      let (h, m, _) = model.timeSetting 
      in let s = Result.withDefault 0 (String.toInt str)
      in ({ model | timeSetting = (h, m, s),
                    time = timeFromSetting (h, m, s), 
                    timerState = Editing True }, Cmd.none)

    _ -> 
      ((case model.timerState of
        Ticking -> 
          (case msg of 
            Tick _ -> let s = model.time in let newState = if s > 1 then Ticking else Paused
                in { model | timerState = newState, time = s - 1 }
            Pause -> { model | timerState = Paused }
            Reset -> { model | timerState = Editing True }
            _ -> model)

        Paused -> 
          (case msg of  
            Start -> { model | timerState = Ticking }
            Reset -> { model | timerState = Editing True }
            _ -> model)

        Editing valid -> 
          (case msg of
            Start -> { model | timerState = Ticking }
            ValidationError -> { model | timerState = Editing False }
            _ -> model))
        , Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    case model.timerState of
        Ticking -> Time.every second Tick
        _ -> Sub.none


-- VIEW

view : Model -> Html Msg
view model =
  Grid.containerFluid []
  [ CDN.stylesheet
  , Grid.row [] 
    [ Grid.col [] 
      [ timeView model ] 
    ]
  , Grid.row [] 
    [ Grid.col [ Col.xs6 ]
      [
        button [ onClick Reset ] [ text "Reset" ] 
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
    Editing valid -> 
      let (h, m, s) = model.timeSetting in div []
        [ input [ type_ "number", placeholder "00", value (toString h), onInput SetHours ] []
        , text ":"
        , input [ type_ "number", placeholder "00", value (toString m), onInput SetMinutes ] []
        , text ":"      
        , input [ type_ "number", placeholder "00", value (toString s), onInput SetSeconds ] []
        ]
    _ -> 
      let s = model.time in div []
        [
          text (secondsToString s)
        ] 

startButton : Model -> Html Msg
startButton model = case model.timerState of 
  Ticking -> button [ onClick Pause ] [ text "Pause"]
  _ -> button [ onClick Start ] [ text "Start"]

secondsToString : Int -> String
secondsToString = hoursMinutesSeconds >> hoursMinutesSecondsString

hoursMinutesSeconds : Int -> (Int, Int, Int)
hoursMinutesSeconds s = 
  let h = s // 3600
  in let m = (s // 60) - (h * 60)
  in (h, m, s % 60)

hoursMinutesSecondsString : (Int, Int, Int) -> String
hoursMinutesSecondsString (h, m, s) = 
  let twoDigit x = padLeft 2 '0' (toString x) 
  in let hourString = if h > 0 then (twoDigit h) ++ ":" else ""
  in hourString ++ (twoDigit m) ++ ":" ++ (twoDigit s)