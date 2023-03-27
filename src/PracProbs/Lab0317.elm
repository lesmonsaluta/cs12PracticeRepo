module PracProbs.Lab0317 exposing (..)

import Browser
import Random
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (id)
 
type Model 
    = Roll 
    | Game 
        { k : Int 
        , turn : Int
        , n : Int
        , hist1 : List Int
        , hist2 : List Int
        }
    | Victory Int
 
type Msg 
    = MsgGotRandomInt Int 
    | Increment Int
    | Restart
 
getRandomInt : Cmd Msg
getRandomInt = Random.generate MsgGotRandomInt (Random.int 1000 1000000)
 
init : () -> (Model, Cmd Msg)
init _ = (Roll , getRandomInt)
 
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case (msg, model) of
        --Initiate
        (MsgGotRandomInt randomNum, Roll) -> 
            (Game {k = 2, turn =1, n = randomNum, hist1 = [], hist2 = []}, Cmd.none)
          
        --Game
        (Increment x, Game data) ->
            if data.k  * x < data.n then
                if data.turn == 1 then
                    ( Game { data | k = data.k * x
                    , turn = 2
                    , hist1 = x::data.hist1}, Cmd.none)
                else 
                    ( Game { data | k = data.k * x
                    , turn = 1
                    , hist2 = x::data.hist2}, Cmd.none)
            --win
            else
                (Victory data.turn, Cmd.none)
        
        --Restart in game
        (Restart, _) -> (Roll, getRandomInt)
        
        --Dump
        _ -> (model, Cmd.none)
        
view : Model -> Html Msg
view model =
    case model of
        Roll ->
            div []
                [ div [] [ text "Test" ] ]
                
        Game data -> 
            Html.pre []
            [
                text "Current player is ",
                Html.span [id "current-player"] [text ("Player " ++ Debug.toString (data.turn))],
                text "\n",
                text "n: ",
                Html.span [id "n"] [Html.text (String.fromInt data.n)],
                text "\n",
                text "k: ",
                Html.span [id "k"] [Html.text (String.fromInt data.k)],
                text "\n",
                text "Player 1 moves: ",
                Html.span [id "moves-player1"] [Html.text (Debug.toString data.hist1)],
                text "\n",
                text "Player 2 moves: ",
                Html.span [id "moves-player2"] [Html.text (Debug.toString data.hist2)],
                text "\n",
                button [onClick (Increment 2), id "choice-2"] [text "2"],
                button [onClick (Increment 3), id "choice-3"] [text "3"],
                button [onClick (Increment 4), id "choice-4"] [text "4"],
                button [onClick (Increment 5), id "choice-5"] [text "5"],
                button [onClick (Increment 6), id "choice-6"] [text "6"],
                button [onClick (Increment 7), id "choice-7"] [text "7"],
                button [onClick (Increment 8), id "choice-8"] [text "8"],
                button [onClick (Increment 9), id "choice-9"] [text "9"],
                text "\n",
                button [onClick Restart, id "restart"] [text "restart"]
            ]
               

            
        Victory turn->
            div []
                [ text <| "Player " ++ String.fromInt (turn) ++ " wins",
                button [onClick Restart, id "restart"] [text "restart"]
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