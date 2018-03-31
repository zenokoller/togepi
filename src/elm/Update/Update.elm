module Update exposing (update)

import Model exposing (..)
import Update.Utils exposing (processKeyCode, notificationCmd)
import View.Utils exposing (timeFromSetting)

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

    KeyMsg code -> processKeyCode model code

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
            Start -> 
              let t = if model.time > 1 then model.time else timeFromSetting model.timeSetting
              in { model | time = t, timerState = Ticking }
            Reset -> { model | timerState = Editing }
            _ -> model, Cmd.none)

        Editing -> 
          (case msg of
            Start -> { model | time = timeFromSetting model.timeSetting, timerState = Ticking }
            _ -> model, Cmd.none)
