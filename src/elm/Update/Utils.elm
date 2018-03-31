module Update.Utils exposing (notificationCmd, processKeyCode)

import Model exposing (..)
import Task exposing (attempt)
import Notification exposing (Notification, create, defaultOptions)
import Keyboard exposing (KeyCode)
import View.Utils exposing (timeFromSetting)

notificationCmd : Cmd Msg
notificationCmd = Notification "🛎" { defaultOptions | body = Just ("Timer is done!") }
  |> create
  |> attempt NotificationResult

processKeyCode : Model -> KeyCode -> (Model, Cmd Msg)
processKeyCode model code = 
  ((case code of
    114 -> -- "r"
      { model | timerState = Editing } 
    
    115 -> -- "s"
      case model.timerState of 
        Ticking -> { model | timerState = Paused }
        Paused ->               
          let t = if model.time > 1 then model.time else timeFromSetting model.timeSetting
          in { model | time = t, timerState = Ticking }
        Editing -> { model | time = timeFromSetting model.timeSetting, timerState = Ticking }

    _ -> model
  ), Cmd.none)