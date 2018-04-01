module Update exposing (update)

import Model exposing (..)
import Update.ProcessKeyCode exposing (processKeyCode)
import Update.NotificationCmd exposing (notificationCmd)
import View.Utils exposing (timeFromSetting)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of 
    SetHours str -> 
      let (_, m, s) = model.timeSetting 
      in let h = (Result.withDefault 0 (String.toInt str)) % 24
      in updateTimeSetting model (h, m, s)

    SetMinutes str -> 
      let (h, _, s) = model.timeSetting 
      in let m = (Result.withDefault 0 (String.toInt str) % 60)
      in updateTimeSetting model (h, m, s)

    SetSeconds str -> 
      let (h, m, _) = model.timeSetting 
      in let s = (Result.withDefault 0 (String.toInt str) % 60)
      in updateTimeSetting model (h, m, s)

    KeyMsg code -> processKeyCode model code

    _ -> 
      case model.timerState of
        Ticking -> updateWhenTicking model msg
        Paused -> updateWhenPaused model msg
        Editing -> updateWhenEditing model msg

updateTimeSetting : Model -> (Int, Int, Int) -> (Model, Cmd Msg)
updateTimeSetting model (h, m, s) = 
  ({ model | timeSetting = (h, m, s), 
             time = timeFromSetting (h, m, s), 
             timerState = Editing }, Cmd.none)

updateWhenTicking : Model -> Msg -> (Model, Cmd Msg)
updateWhenTicking model msg = 
  case msg of 
    Tick _ ->
      let s = model.time 
      in let newState = if s > 1 then Ticking else Paused
      in let cmd = if newState == Paused then notificationCmd else Cmd.none
      in ({ model | timerState = newState, time = s - 1 }, cmd)
    Pause -> ({ model | timerState = Paused }, Cmd.none)
    Reset -> ({ model | timerState = Editing }, Cmd.none)
    _ -> (model, Cmd.none)

updateWhenPaused : Model -> Msg -> (Model, Cmd Msg)
updateWhenPaused model msg = 
  (case msg of  
    Start -> 
      let t = if model.time > 1 then model.time else timeFromSetting model.timeSetting
      in { model | time = t, timerState = Ticking }
    Reset -> { model | timerState = Editing }
    _ -> model, Cmd.none)

updateWhenEditing : Model -> Msg -> (Model, Cmd Msg)
updateWhenEditing model msg = 
  (case msg of
    Start -> { model | time = timeFromSetting model.timeSetting, timerState = Ticking }
    _ -> model, Cmd.none)