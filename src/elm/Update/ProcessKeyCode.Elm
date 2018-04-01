module Update.ProcessKeyCode exposing (processKeyCode)

import Model exposing (..)
import Keyboard exposing (KeyCode)
import View.Utils exposing (timeFromSetting)

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
  