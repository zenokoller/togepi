module View.Utils exposing (..)

import String exposing (padLeft)

timeFromSetting : (Int, Int, Int) -> Int
timeFromSetting (h, m, s) = h * 3600 + m * 60 + s

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