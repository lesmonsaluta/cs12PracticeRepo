module PracProbs.Lab0303 exposing (..)
 
import Browser
import Random
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
 
-- type Model = Rerolling | RerollDone Int
type Model 
    = Roll 
    | Game {current : Int , win : Int}
    | Victory
 
type Msg 
    = MsgGotRandomInt Int 
    | Increment 
    | Decrement 
    | Reset
 
getRandomInt : Cmd Msg
getRandomInt = Random.generate MsgGotRandomInt (Random.int 1 100)
 
init : () -> (Model, Cmd Msg)
init _ = ( Roll , getRandomInt)
 
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case (msg, model) of
        (MsgGotRandomInt n, Roll) -> 
            (Game {current = 1, win = n}, Cmd.none)
        (Increment, Game data) ->
            if data.current  * 3 + 1 < data.win then
                ( Game { data | current = data.current * 3 + 1 }, Cmd.none)
            else
                (Victory, Cmd.none)

        (Decrement, Game data) ->
            (Game { data | current = data.current // 2}, Cmd.none)
        
        (Reset, Victory) -> init ()
        
        _ -> (model, Cmd.none)
        
view : Model -> Html Msg
view model =
    case model of
        Roll ->
            div []
                [ div [] [ text "Test" ] ]
        
        Game data -> 
            div []
            [ button [ onClick Increment ] [ text "+" ] -- 3n+1
            , div [] [ text <| String.fromInt data.current ]
            , button [ onClick Decrement ] [ text "-" ] -- n//2
            ]
            
        Victory ->
            div []
                [ text "Win Gatchalian"
                , button [onClick Reset] [text "Reset"]
                ]
 
subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none
 
main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , subscriptions = subscriptions
        , update = update
        }
