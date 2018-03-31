module Main exposing (main)

import Html
import Model exposing (Msg, Model, init)
import Subscriptions exposing (subscriptions)
import Update exposing (update)
import View exposing (view)

main : Program Never Model Msg
main = Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
