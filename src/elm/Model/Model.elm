module Model exposing (..)

import Time exposing (Time, second)
import Task exposing (perform)
import Notification exposing (Error, Permission, requestPermission)
import Keyboard exposing (KeyCode)

import View.Utils exposing (timeFromSetting)

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
    | KeyMsg KeyCode


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