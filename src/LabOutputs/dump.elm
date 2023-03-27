module LabOutputs.dump exposing (..)

view : Model -> Html Msg
view model = 
    let
        playerToString : Player -> String --* converts player to string
        playerToString player =
            case player of
                Player1 -> "Player 1"
                Player2 -> "Player 2"
                Player3 -> "Player 3"
                Draw -> "Draw"  
        playerHelperSpan : Player -> String --* converts player to string for formalities (span and id)
        playerHelperSpan player =
            case player of
                Player1 -> "player1"
                Player2 -> "player2"
                Player3 -> "player3"
                Draw -> "draw" 
    in
    case model of
        Playing data ->
            let
                playerToHtml : Player -> Html Msg --* helper function for buttons
                playerToHtml player =
                    let
                        playerPoints = --* display points of players
                            case player of
                                Player1 -> data.p1points |> String.fromInt
                                Player2 -> data.p2points |> String.fromInt
                                Player3 -> data.p3points |> String.fromInt
                                Draw -> ""
                        
                        playerChoice = --* store choice of players
                            case player of 
                                Player1 -> data.p1choice
                                Player2 -> data.p2choice
                                Player3 -> data.p3choice
                                Draw -> Nothing
                    in
                    case playerChoice of 
                        Just _ -> --* if there's a choice, show they're done
                            div []
                                [ text <| (playerToString player ++ " - ")
                                , span [id (playerHelperSpan player ++ "-score")] [text <|  playerPoints], text " is done."]
                        Nothing -> --* if no choice, show as is
                            div []
                                [ text <| (playerToString player ++ " - ")
                                , span [id (playerHelperSpan player ++ "-score")] [text <|  playerPoints], text " "
                                , button [onClick (MsgPick player Rock), id (playerHelperSpan player ++ "-rock")] [text "Rock"]
                                , button [onClick (MsgPick player Paper), id (playerHelperSpan player ++ "-paper")] [text "Paper"]
                                , button [onClick (MsgPick player Scissors), id (playerHelperSpan player ++ "-scissors")] [text "Scissors"]
                                ]
            in
            div []
                [ div [] [text ("Round " ++ String.fromInt data.rounds)]
                , playerToHtml Player1
                , playerToHtml Player2
                , playerToHtml Player3
                ]
        RoundResult data winner ->
            let
                printDrawOrNot : Player -> Html Msg --* prints who's the winner
                printDrawOrNot p  =
                    if p == Draw then
                        div [] [text "Result: ", span [id "result"] [text "Draw"]]
                    else
                        div [] [text "Result: ", span [id "result"] [text <|  playerToString p]]
            in
            div []
                [ printDrawOrNot winner
                , div [] [span [id "player1-move"] [text <| ("Player 1: " ++ (data.p1choice |> Maybe.withDefault Paper |> Debug.toString))]]
                , div [] [span [id "player2-move"] [text <| ("Player 2: " ++ (data.p2choice |> Maybe.withDefault Paper |> Debug.toString))]]
                , div [] [span [id "player3-move"] [text <| ("Player 3: " ++ (data.p3choice |> Maybe.withDefault Paper |> Debug.toString))]]
                , button [onClick MsgContinue, id "continue"] [text "Continue"]
                ]
        Done winner ->
            div []
                [ div [] [span [id "overall-winner"] [text <| playerToString winner]]
                , button [onClick MsgReset, id "restart"] [text "Reset"]
                ]