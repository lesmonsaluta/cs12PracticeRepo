module Checkers.Lab03.Lab03 exposing (main)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)


type alias Data =
    { marioChoice : Maybe Choice
    , luigiChoice : Maybe Choice
    , princessPeachChoice : Maybe Choice
    , drawChoice : Maybe Choice
    , marioScore : Int
    , luigiScore : Int
    , princessPeachScore : Int
    , drawScore : Int
    , round : Int
    
    }
type Model
    = Loading Data
    | RoundResult Data Player
    | Winner Player


type Choice
    = R
    | P
    | S

type Player
    = Mario
    | Luigi
    | PrincessPeach
    | Draw


type Msg
    = MsgClick Player Choice
    | MsgContinue
    | MsgReset


init : Model
init = Loading
    { marioChoice = Nothing
    , luigiChoice = Nothing
    , princessPeachChoice = Nothing
    , drawChoice = Nothing
    , marioScore = 0
    , luigiScore = 0
    , princessPeachScore = 0
    , drawScore = 0
    , round = 1
    }


update : Msg -> Model -> Model
update msg model =
    case (msg, model) of
        (MsgClick player choice, Loading data) ->
            let
                dataWithChoice =
                    case player of
                        Mario -> { data | marioChoice = Just choice}
                        Luigi -> { data | luigiChoice = Just choice}
                        PrincessPeach -> { data | princessPeachChoice = Just choice}
                        Draw -> { data | drawChoice = Just choice}

                getRoundWinner : Data -> Maybe Player
                getRoundWinner current =
                    case (current.marioChoice, current.luigiChoice, current.princessPeachChoice) of
                        (Just a, Just b, Just c) ->
                            getWinner a b c

                        _ ->
                            Nothing


                getWinner : Choice -> Choice -> Choice -> Maybe Player
                getWinner a b c =
                    case (a, b, c) of
                        (R, S, S) -> Just Mario
                        (S, P, P) -> Just Mario
                        (P, R, R) -> Just Mario

                        (R, P, R) -> Just Luigi
                        (S, R, S) -> Just Luigi
                        (P, S, P) -> Just Luigi

                        (S, S, R) -> Just PrincessPeach
                        (P, P, S) -> Just PrincessPeach
                        (R, R, P) -> Just PrincessPeach

                        _ -> Just Draw


                updateScore : Data -> Data
                updateScore current =
                    case getRoundWinner dataWithChoice of
                        Just winner ->
                            case winner of
                                Mario -> { current | marioScore = current.marioScore + 1, round = current.round + 1 }
                                Luigi -> { current | luigiScore = current.luigiScore + 1, round = current.round + 1 }
                                PrincessPeach -> { current | princessPeachScore = current.princessPeachScore + 1, round = current.round + 1 }
                                Draw -> { current | round = current.round + 1 }
                        
                        Nothing -> current

                dataUpdated =
                    updateScore dataWithChoice
            in
            case getRoundWinner dataWithChoice of
                Just winner ->
                    if dataUpdated.marioScore == 5 then
                        Winner Mario
                        
                    else if dataUpdated.luigiScore == 5 then
                        Winner Luigi
                        
                     else if dataUpdated.princessPeachScore == 5 then
                        Winner PrincessPeach
                        
                    else
                  
                        RoundResult dataUpdated winner

                Nothing ->
                    Loading dataWithChoice

        (MsgContinue, RoundResult data winner) ->
            (Loading 
                {data | marioChoice = Nothing, luigiChoice = Nothing, princessPeachChoice = Nothing})
                    

        (MsgReset, _) ->
            init
        
        _ ->
            model

--QQ 
view : Model -> Html Msg
view model =
    let
        playerToStr : Player -> String
        playerToStr player =
            case player of
                Mario -> "Player 1"
                Luigi -> "Player 2"
                PrincessPeach -> "Player 3"
                Draw -> "Draw"

        makePlayerHtml : Player -> Data -> Html Msg
        makePlayerHtml player data =
            let
                playerScore =
                    case player of
                        Mario -> data.marioScore |> String.fromInt
                        Luigi -> data.luigiScore |> String.fromInt
                        PrincessPeach -> data.princessPeachScore |> String.fromInt
                        Draw -> data.drawScore |> String.fromInt

                choice =
                    case player of
                        Mario -> data.marioChoice
                        Luigi -> data.luigiChoice
                        PrincessPeach -> data.princessPeachChoice
                        Draw -> data.drawChoice
            in
            case choice of
                Just _ ->
                    div []
                        [ text <| playerToStr player
                        , text <| " (" ++ playerScore ++ ") is done"
                        ]

                Nothing ->
                    div []
                        [ text <| playerToStr player
                        , text <| " (" ++ playerScore ++ ") "
                        , button [onClick (MsgClick player R)] [text "R"]
                        , button [onClick (MsgClick player P)] [text "P"]
                        , button [onClick (MsgClick player S)] [text "S"]
                        ]
    in
    case model of
        Loading data ->
            div []
                [ text ("Round " ++ (data.round |> String.fromInt))
                , makePlayerHtml Mario data
                , makePlayerHtml Luigi data
                , makePlayerHtml PrincessPeach data
                ]

        RoundResult data winner ->
            let
                resultHeader =
                    if winner == Draw then
                        text <| playerToStr winner
                    else
                        text <| playerToStr winner ++ " wins"
            in
            div []
                [ div [] [resultHeader]
                , div [] [text <| "Player 1: " ++ (data.marioChoice |> Maybe.withDefault R |> Debug.toString)]
                , div [] [text <| "Player 2: " ++ (data.luigiChoice |> Maybe.withDefault R |> Debug.toString)]
                , div [] [text <| "Player 3: " ++ (data.princessPeachChoice |> Maybe.withDefault R |> Debug.toString)]
                , button [onClick MsgContinue] [text "Continue"]
                ]

        Winner winner ->
            div []
                [ text <| playerToStr winner ++ " wins"
                , button [onClick MsgReset] [text "Reset"]
                ]


main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }

