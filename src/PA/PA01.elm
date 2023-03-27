module PA.PA01 exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Http
import Dict exposing (Dict)




type alias Region = String
type alias Province = String
type alias City = String
type alias Candidate = String


getProvinceSubsetWinner : InputData -> List Province -> List Candidate
getProvinceSubsetWinner _ _ = []

getWinnerOfEachCity : InputData -> Dict City (List Candidate)
getWinnerOfEachCity _ = Dict.empty

getLandslideVictories : InputData -> Candidate -> Dict Region (Int, Int)
getLandslideVictories _ _ = Dict.empty

getClosestContests : InputData -> Candidate -> List (Province, Candidate, (Int, Int))
getClosestContests _ _ = []

type alias InputData = 
    { regionCsv : String
    , provinceCsv : String
    , cityCsv : String
    , barangayCsv : String
    , candidateCsv : String
    , resultCsv : String
    }


type Model
    = FetchingData
        { regionCsv : Maybe String
        , provinceCsv : Maybe String
        , cityCsv : Maybe String
        , barangayCsv : Maybe String
        , candidateCsv : Maybe String
        , resultCsv : Maybe String
        }
    | DataReady InputData
    | ErrorState String


baseUrl = "https://cs12.upd-dcs.work/pa1/"

getRegionCsv = Http.get
    { url = baseUrl ++ "regions.csv"
    , expect = Http.expectString MsgGotRegionCsv
    }

getProvinceCsv = Http.get
    { url = baseUrl ++ "provinces.csv"
    , expect = Http.expectString MsgGotProvinceCsv
    }

getCityCsv = Http.get
    { url = baseUrl ++ "cities.csv"
    , expect = Http.expectString MsgGotCityCsv
    }

getBarangayCsv = Http.get
    { url = baseUrl ++ "barangays.csv"
    , expect = Http.expectString MsgGotBarangayCsv
    }

getCandidateCsv = Http.get
    { url = baseUrl ++ "candidates.csv"
    , expect = Http.expectString MsgGotCandidateCsv
    }

getResultsCsv = Http.get
    { url = baseUrl ++ "votes.csv"
    , expect = Http.expectString MsgGotResultCsv
    }


init : () -> (Model, Cmd Msg)
init _ =
    ( FetchingData
        { regionCsv = Nothing
        , provinceCsv = Nothing
        , cityCsv = Nothing
        , barangayCsv = Nothing
        , candidateCsv = Nothing
        , resultCsv = Nothing
        }
    , Cmd.batch
        [ getRegionCsv
        , getProvinceCsv
        , getCityCsv
        , getBarangayCsv
        , getCandidateCsv
        , getResultsCsv
        ]
    )


type Msg
    = MsgGotRegionCsv (Result Http.Error String)
    | MsgGotProvinceCsv (Result Http.Error String)
    | MsgGotCityCsv (Result Http.Error String)
    | MsgGotBarangayCsv (Result Http.Error String)
    | MsgGotCandidateCsv (Result Http.Error String)
    | MsgGotResultCsv (Result Http.Error String)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    let
        processResult oldCsvs =
            let
                returnError error =
                    (ErrorState <| Debug.toString error, Cmd.none)
            in
            case msg of
                MsgGotRegionCsv (Ok csv) ->
                    { oldCsvs | regionCsv = Just csv } |> finishState
                
                MsgGotProvinceCsv (Ok csv) ->
                    { oldCsvs | provinceCsv = Just csv } |> finishState
                
                MsgGotCityCsv (Ok csv) ->
                    { oldCsvs | cityCsv = Just csv } |> finishState
                
                MsgGotBarangayCsv (Ok csv) ->
                    { oldCsvs | barangayCsv = Just csv } |> finishState
                
                MsgGotCandidateCsv (Ok csv) ->
                    { oldCsvs | candidateCsv = Just csv } |> finishState
                
                MsgGotResultCsv (Ok csv) ->
                    { oldCsvs | resultCsv = Just csv } |> finishState
                    
                MsgGotRegionCsv (Err error) -> returnError error
                MsgGotProvinceCsv (Err error) -> returnError error
                MsgGotCityCsv (Err error) -> returnError error
                MsgGotBarangayCsv (Err error) -> returnError error
                MsgGotCandidateCsv (Err error) -> returnError error
                MsgGotResultCsv (Err error) -> returnError error
                    
        finishState csvs =
            case (csvs.regionCsv, csvs.provinceCsv, csvs.cityCsv) of
                (Just regionCsv, Just provinceCsv, Just cityCsv) ->  -- Elm is too opinionated
                    case (csvs.barangayCsv, csvs.candidateCsv, csvs.resultCsv) of
                        (Just barangayCsv, Just candidateCsv, Just resultCsv) ->
                            let
                                readyCsvs =
                                    { regionCsv = regionCsv
                                    , provinceCsv = provinceCsv
                                    , cityCsv = cityCsv
                                    , barangayCsv = barangayCsv
                                    , candidateCsv = candidateCsv
                                    , resultCsv = resultCsv
                                    }
                             in
                            (DataReady readyCsvs, Cmd.none)
                            
                        _ ->
                            (FetchingData csvs, Cmd.none)
                
                _ ->
                    (FetchingData csvs, Cmd.none)
        
    in
    case model of
        FetchingData csvs -> processResult csvs
        _ -> (model, Cmd.none)


view : Model -> Html Msg
view model =
    case model of
        FetchingData _ ->
            div [] [text "Fetching data..."]
            
        DataReady data ->
            let
                _ = data |> Debug.log ""
            in
            div [] [text "Data fetched; see logs"]
            
        ErrorState error ->
            div [] [text error]


subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
