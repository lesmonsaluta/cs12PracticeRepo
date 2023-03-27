module Lab03 exposing (..)

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (..)


-- MVU
-- Model: Data of app
-- View: What the user sees
-- Msg: User interaction
-- Update: How the Model changes as a response to a Msg


type alias Model =
    { p1Choice : String
    , p2Choice : String
    , p3Choice : String
    , p1Score : Int
    , p2Score : Int
    , p3Score : Int
    , winner : Int
    }


init : Model
init =
    { p1Choice = ""
    , p2Choice = ""
    , p3Choice = ""
    , p1Score = 0
    , p2Score = 0
    , p3Score = 0
    , winner = 0
    }


type Msg
    = MsgClick { player : Int, move : String }
    | MsgContinue
    | MsgReset


update : Msg -> Model -> Model
update msg model =
    let
        updateScoreOfWinner : Model -> Model
        updateScoreOfWinner current =
            if current.p1Choice /= "" && current.p2Choice /= "" && current.p3Choice /= "" then
                -- We have a winner
                if current.p1Choice == "rock" && current.p2Choice == "scissors" && current.p3Choice == "scissors" then
                    { current | p1Score = current.p1Score+1, winner = 1}
                else if current.p1Choice == "paper" && current.p2Choice == "rock" && current.p3Choice == "rock" then
                    { current | p1Score = current.p1Score+1, winner = 1}
                else if current.p1Choice == "scissors" && current.p2Choice == "paper" && current.p3Choice == "paper" then
                    { current | p1Score = current.p1Score+1, winner = 1}
                else if current.p2Choice == "rock" && current.p1Choice == "scissors" && current.p3Choice == "scissors" then
                    { current | p2Score = current.p2Score+1
                    , winner = 2}
                else if current.p2Choice == "paper" && current.p1Choice == "rock" && current.p3Choice == "rock" then
                    { current | p2Score = current.p2Score+1
                    , winner = 2}
                else if current.p2Choice == "scissors" && current.p1Choice == "paper" && current.p3Choice == "paper" then
                    { current | p2Score = current.p2Score+1
                    , winner = 2}
                else if current.p3Choice == "rock" && current.p1Choice == "scissors" && current.p2Choice == "scissors" then
                    { current | p3Score = current.p3Score+1
                    , winner = 3}
                else if current.p3Choice == "paper" && current.p1Choice == "rock" && current.p2Choice == "rock" then
                    { current | p3Score = current.p3Score+1
                    , winner = 3}
                else if current.p3Choice == "scissors" && current.p1Choice == "paper" && current.p2Choice == "paper" then
                    { current | p3Score = current.p3Score+1
                    , winner = 3}
                else
                    current
            else
                -- Still waiting for choice/s
                current
    in
    case msg of
        MsgClick { player, move } ->
            case player of
                1 -> 
                    { model | p1Choice = move }
                    |> updateScoreOfWinner
                2 -> 
                    { model | p2Choice = move }
                    |> updateScoreOfWinner
                3 -> 
                    { model | p3Choice = move }
                    |> updateScoreOfWinner
                    
                _ -> model

                
        MsgContinue ->
            { model | p1Choice = "", p2Choice = "" , p3Choice = "", winner = 0}
            
        MsgReset ->
            init


view : Model -> Html Msg
view model =
    let
        p1Elems =
            if model.p1Choice /= "" then
                [ text " is done" ]
            else
                [ button [onClick (MsgClick { player = 1, move = "rock" }), id("player1-rock")] [text "Rock"]
                , button [onClick (MsgClick { player = 1, move = "paper" }), id("player1-paper")] [text "Paper"]  
                , button [onClick (MsgClick { player = 1, move = "scissors" }), id("player1-scissors")] [text "Scissors"]  
                ]
            
        p2Elems =
            if model.p2Choice /= "" then
                [ text " is done" ]
            else
                [ button [onClick (MsgClick { player = 2, move = "rock" }), id("player2-rock")] [text "Rock"]
                , button [onClick (MsgClick { player = 2, move = "paper" }), id("player2-paper")] [text "Paper"]  
                , button [onClick (MsgClick { player = 2, move = "scissors" }), id("player2-scissors")] [text "Scissors"]  
                ]
              
        p3Elems =
            if model.p3Choice /= "" then
                [ text " is done" ]
            else
                [ button [onClick (MsgClick { player = 3, move = "rock" }), id("player3-rock")] [text "Rock"]
                , button [onClick (MsgClick { player = 3, move = "paper" }), id("player3-paper")] [text "Paper"]  
                , button [onClick (MsgClick { player = 3, move = "scissors" }), id("player3-scissors")] [text "Scissors"]  
                ]
            
        children =
            [ div [] [text <| ("Player 1: ")
                    , span [id("player1-score")] [text <| String.fromInt model.p1Score] 
                    , div [] p1Elems]
            , div [] [text <| ("Player 2: ")
                    , span [id("player2-score")] [text <| String.fromInt model.p2Score] 
                    , div [] p2Elems]
            , div [] [text <| ("Player 3: ")
                    , span [id("player3-score")] [text <| String.fromInt model.p3Score]  
                    , div [] p3Elems]
            ]
            
        winnerStatus = 
            if model.winner == 0 then
                "Draw"
            else
                "Player " ++ (String.fromInt <| model.winner)

    in
    if model.p1Score == 5 then
        div []
            [ span [id("overall-winner")] [text ("Player 1")]
            , button [onClick MsgReset, id("restart")] [ text "Reset" ]
            ]
    else if model.p2Score == 5 then
        div []
            [ span [id("overall-winner")] [text ("Player 2")]
            , button [onClick MsgReset, id("restart")] [ text "Reset" ]
            ]
    else if model.p3Score == 5 then
        div []
            [ span [id("overall-winner")] [text ("Player 3")]
            , button [onClick MsgReset, id("restart")] [ text "Reset" ]
            ]
    else if model.p1Choice /= "" && model.p2Choice /= "" && model.p3Choice /= ""then
        -- Show results
        div []
            [ div [] [span [id("result")] [text (winnerStatus)]]
            , div [] [span [id("player1-move")] [text (model.p1Choice)]]
            , div [] [span [id("player2-move")] [text (model.p2Choice)]]
            , div [] [span [id("player3-move")] [text (model.p3Choice)]]
            , button [onClick MsgContinue, id("continue")] [text "Continue"]
            ]
    else
        -- Show screen with buttons
        div [] children






main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }