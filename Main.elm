module Main exposing (main)

import Html exposing (Html, button, div, input, text, node, span)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Time exposing (Time, second)
import String exposing (padLeft)
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row
import Bootstrap.Grid.Col as Col
import Task exposing (Task, perform, attempt)
import Notification exposing (Error, Notification, Permission, create, defaultOptions, requestPermission)

main : Program Never Model Msg
main = Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type TimerState = Paused | Ticking | Editing

type alias Model = { 
  timeSetting: (Int, Int, Int),
  time: Int, 
  timerState: TimerState 
}

init : (Model, Cmd Msg)
init = let setting = (0, 25, 0) in let t = timeFromSetting setting in 
  (
    {timeSetting = setting, time = t, timerState = Paused }
  , perform RequestPermissionResult requestPermission 
  )

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
    | RequestPermissionResult Permission
    | NotificationResult (Result Error ())

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of 
    SetHours str -> 
      let (_, m, s) = model.timeSetting 
      in let h = (Result.withDefault 0 (String.toInt str)) % 24
      in ({ model | timeSetting = (h, m, s), 
                    time = timeFromSetting (h, m, s), 
                    timerState = Editing }, Cmd.none)

    SetMinutes str -> 
      let (h, _, s) = model.timeSetting 
      in let m = (Result.withDefault 0 (String.toInt str) % 60)
      in ({ model | timeSetting = (h, m, s), 
                    time = timeFromSetting (h, m, s), 
                    timerState = Editing }, Cmd.none)

    SetSeconds str -> 
      let (h, m, _) = model.timeSetting 
      in let s = (Result.withDefault 0 (String.toInt str) % 60)
      in ({ model | timeSetting = (h, m, s),
                    time = timeFromSetting (h, m, s), 
                    timerState = Editing }, Cmd.none)

    _ -> 
      case model.timerState of
        Ticking -> 
          case msg of 
            Tick _ -> 
              let s = model.time 
              in let newState = if s > 1 then Ticking else Paused
              in let cmd = if newState == Paused then notificationCmd else Cmd.none
              in ({ model | timerState = newState, time = s - 1 }, cmd)
            Pause -> ({ model | timerState = Paused }, Cmd.none)
            Reset -> ({ model | timerState = Editing }, Cmd.none)
            _ -> (model, Cmd.none)

        Paused -> 
          (case msg of  
            Start -> { model | time = timeFromSetting model.timeSetting, timerState = Ticking }
            Reset -> { model | timerState = Editing }
            _ -> model, Cmd.none)

        Editing -> 
          (case msg of
            Start -> { model | time = timeFromSetting model.timeSetting, timerState = Ticking }
            _ -> model, Cmd.none)

notificationCmd : Cmd Msg
notificationCmd = Notification "🛎" { defaultOptions | body = Just ("Timer is done!") }
  |> create
  |> attempt NotificationResult

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    case model.timerState of
        Ticking -> Time.every second Tick
        _ -> Sub.none


-- VIEW

view : Model -> Html Msg
view model =
  Grid.containerFluid [ class "timer-container" ]
  [ node "link" [ rel "stylesheet", href "bootstrap.min.css" ] []
  , node "link" [ rel "stylesheet", href "style.css" ] []
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

secondsToString : Int -> String
secondsToString = hoursMinutesSeconds >> hoursMinutesSecondsString

hoursMinutesSeconds : Int -> (Int, Int, Int)
hoursMinutesSeconds s = 
  let h = s // 3600
  in let m = (s // 60) - (h * 60)
  in (h, m, s % 60)

hoursMinutesSecondsString : (Int, Int, Int) -> String
hoursMinutesSecondsString (h, m, s) = 
  let hourString = if h > 0 then (twoDigitString h) ++ ":" else ""
  in hourString ++ (twoDigitString m) ++ ":" ++ (twoDigitString s)

twoDigitString : Int -> String
twoDigitString d = padLeft 2 '0' (toString d)
