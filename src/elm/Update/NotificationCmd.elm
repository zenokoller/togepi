module Update.NotificationCmd exposing (notificationCmd)

import Model exposing (..)
import Task exposing (attempt)
import Notification exposing (Notification, create, defaultOptions)

notificationCmd : Cmd Msg
notificationCmd = Notification "🛎" { defaultOptions | body = Just ("Timer is done!") }
  |> create
  |> attempt NotificationResult

