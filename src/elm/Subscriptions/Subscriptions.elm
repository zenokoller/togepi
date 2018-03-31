module Subscriptions exposing (..)

import Time exposing (Time, second)
import Keyboard exposing (presses)

import Model exposing (..)

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch 
    [ timeSub model
    , presses KeyMsg
    ]

timeSub : Model -> Sub Msg
timeSub model =
    case model.timerState of
        Ticking -> Time.every second Tick
        _ -> Sub.none