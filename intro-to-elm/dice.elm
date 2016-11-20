module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (..)
import Html.App as App
import Random exposing (..)
import String


main : Program Never
main =
    App.program { init = init, view = view, update = update, subscriptions = subscriptions }



-- Model


type alias Dice =
    { diceFace1 : Int
    , diceFace2 : Int
    }


faces : List String
faces =
    [ "http://www.clipartkid.com/images/170/dice-faces-clipart-1-9-reaching-teachers-labd0b-clipart.png" ]


init : ( Dice, Cmd Msg )
init =
    ( Dice 1 1, Cmd.none )



-- Update


type Msg
    = Roll
    | NewFace ( Int, Int )


update : Msg -> Dice -> ( Dice, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model, Random.generate NewFace diePairGenerator )

        NewFace ( newFace1, newFace2 ) ->
            ( Dice newFace1 newFace2, Cmd.none )


dieGenerator : Random.Generator Int
dieGenerator =
    Random.int 1 6


diePairGenerator : Random.Generator ( Int, Int )
diePairGenerator =
    Random.pair dieGenerator dieGenerator



-- View


view : Dice -> Html Msg
view model =
    div []
        [ img [ src (getImg model.diceFace1) ] []
        , button [ onClick Roll ] [ text "Roll" ]
        , img [ src (getImg model.diceFace2) ] []
        ]


getImg : Int -> String
getImg diceFace =
    String.concat [ "./dice/", toString diceFace, ".jpg" ]



-- Subscriptions


subscriptions : Dice -> Sub Msg
subscriptions model =
    Sub.none
