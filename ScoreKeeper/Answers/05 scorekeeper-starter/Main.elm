module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App as App
import String


-- model


type alias Model =
    { players : List Player
    , name : String
    , playerId : Maybe Int
    , plays : List Play
    }


type alias Player =
    { id : Int
    , name : String
    , points : Int
    }


type alias Play =
    { id : Int
    , playerId : Int
    , name : String
    , points : Int
    }


initModel : Model
initModel =
    { players = []
    , name = ""
    , playerId = Nothing
    , plays = []
    }



-- update


type Msg
    = Edit Player
    | Score Player Int
    | Input String
    | Save
    | Cancel
    | DeletePlay Play


update : Msg -> Model -> Model
update msg model =
    case msg of
        Input name ->
            { model | name = name }

        Save ->
            if (String.isEmpty model.name) then
                model
            else
                save model

        Cancel ->
            { model | name = "", playerId = Nothing }

        Score player pts ->
            score model player pts

        Edit player ->
            { model | name = player.name, playerId = Just player.id }

        DeletePlay play ->
            deletePlay model play


deletePlay : Model -> Play -> Model
deletePlay model play =
    let
        newPlays =
            List.filter (\p -> p.id /= play.id) model.plays

        newPlayers =
            List.map
                (\player ->
                    if player.id == play.playerId then
                        { player | points = player.points - play.points }
                    else
                        player
                )
                model.players
    in
        { model | plays = newPlays }


score : Model -> Player -> Int -> Model
score model scorer pts =
    let
        newPlayers =
            List.map
                (\player ->
                    if player.id == scorer.id then
                        { player | points = player.points + pts }
                    else
                        player
                )
                model.players

        play =
            Play (List.length model.plays) scorer.id scorer.name pts
    in
        { model | players = newPlayers, plays = play :: model.plays }


save : Model -> Model
save model =
    case model.playerId of
        Just id ->
            edit model id

        Nothing ->
            add model


add : Model -> Model
add model =
    let
        newPlayer : Player
        newPlayer =
            { id = List.length model.players
            , name = model.name
            , points = 0
            }

        newPlayers =
            newPlayer :: model.players
    in
        { model | players = newPlayers, name = "" }


edit : Model -> Int -> Model
edit model id =
    let
        newPlayers =
            List.map
                (\player ->
                    if player.id == id then
                        { player | name = model.name }
                    else
                        player
                )
                model.players

        newPlays =
            List.map
                (\play ->
                    if play.playerId == id then
                        { play | name = model.name }
                    else
                        play
                )
                model.plays
    in
        { model
            | plays = newPlays
            , players = newPlayers
            , name = ""
            , playerId = Nothing
        }



-- view


view : Model -> Html Msg
view model =
    div [ class "scoreboard" ]
        [ h1 [] [ text "Score Keeper" ]
        , playerSection model
        , playerForm model
        , plays model
        ]


playerForm : Model -> Html Msg
playerForm model =
    Html.form [ onSubmit Save ]
        [ input
            [ type' "text"
            , placeholder "Add/Edit Player..."
            , onInput Input
            , value model.name
            , class (editInputClass model.playerId)
            ]
            []
        , button [ type' "submit" ] [ text "Save" ]
        , button [ type' "button", onClick Cancel ] [ text "Cancel" ]
        ]


editInputClass : Maybe Int -> String
editInputClass editPlayerId =
    case editPlayerId of
        Just id ->
            "edit"

        Nothing ->
            ""


playerSection : Model -> Html Msg
playerSection model =
    div []
        [ playerListHeader
        , playerList model
        , pointTotal model
        ]


playerListHeader : Html Msg
playerListHeader =
    header []
        [ div [] [ text "Name" ]
        , div [] [ text "Points" ]
        ]


playerList : Model -> Html Msg
playerList model =
    model.players
        |> List.sortBy .name
        |> List.map (player model.playerId)
        |> ul []


player : Maybe Int -> Player -> Html Msg
player editPlayerId player =
    li []
        [ i
            [ class "edit"
            , onClick (Edit player)
            ]
            []
        , div [ class (editPlayerClass editPlayerId player) ] [ text player.name ]
        , button
            [ type' "button", onClick (Score player 2) ]
            [ text "2pt" ]
        , button [ type' "button", onClick (Score player 3) ]
            [ text "3pt" ]
        , div [] [ text (toString player.points) ]
        ]


editPlayerClass : Maybe Int -> Player -> String
editPlayerClass editPlayerId player =
    case editPlayerId of
        Just id ->
            if id == player.id then
                "edit"
            else
                ""

        Nothing ->
            ""


pointTotal : Model -> Html Msg
pointTotal model =
    let
        total =
            List.map .points model.plays |> List.sum
    in
        footer []
            [ div [] [ text "Total: " ]
            , div [] [ text (toString total) ]
            ]


plays : Model -> Html Msg
plays model =
    div []
        [ playListHeader
        , playList model
        ]


playListHeader : Html Msg
playListHeader =
    header []
        [ div [] [ text "Plays" ]
        , div [] [ text "Points" ]
        ]


playList : Model -> Html Msg
playList model =
    model.plays
        |> List.map play
        |> ul []


play : Play -> Html Msg
play play =
    li []
        [ i
            [ class "remove"
            , onClick (DeletePlay play)
            ]
            []
        , div [] [ text play.name ]
        , div [] [ text (toString play.points) ]
        ]


main : Program Never
main =
    App.beginnerProgram { model = initModel, view = view, update = update }
