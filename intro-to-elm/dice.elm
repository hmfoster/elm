module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)


-- import Html.Attributes exposing (..)

import Html.App as App
import Random exposing (..)
import String
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Array


main : Program Never
main =
    App.program { init = init, view = view, update = update, subscriptions = subscriptions }



-- Model


type alias Dice =
    { diceFace1 : Int
    , diceFace2 : Int
    }


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
        [ button [ onClick Roll ] [ Html.text "Roll" ]
        , div []
            [ makeFace model.diceFace1
            , makeFace model.diceFace2
            ]
        ]


getImg : Int -> String
getImg diceFace =
    String.concat [ "./dice/", toString diceFace, ".jpg" ]


makeFace : Int -> Html Msg
makeFace diceFace =
    let
        faces =
            Array.fromList [ makeOne, makeTwo, makeThree, makeFour, makeFive, makeSix ]

        face =
            Array.get diceFace faces
    in
        Svg.svg
            [ Svg.Attributes.width "120"
            , Svg.Attributes.height "120"
            , viewBox "0 0 120 120"
            ]
            [ g []
                [ rect
                    [ x "10"
                    , y "10"
                    , Svg.Attributes.width "100"
                    , Svg.Attributes.height "100"
                    , rx "15"
                    , ry "15"
                    ]
                    []
                , Maybe.withDefault makeOne face
                ]
            ]


makeOne : Svg a
makeOne =
    g []
        [ diceCircle "60" "60" ]


makeTwo : Svg a
makeTwo =
    g []
        [ diceCircle "35" "35"
        , diceCircle "85" "85"
        ]


makeThree : Svg a
makeThree =
    g []
        [ diceCircle "35" "35"
        , diceCircle "60" "60"
        , diceCircle "85" "85"
        ]


makeFour : Svg a
makeFour =
    g []
        [ diceCircle "35" "35"
        , diceCircle "35" "85"
        , diceCircle "85" "35"
        , diceCircle "85" "85"
        ]


makeFive : Svg a
makeFive =
    g []
        [ diceCircle "35" "35"
        , diceCircle "35" "85"
        , diceCircle "85" "35"
        , diceCircle "60" "60"
        , diceCircle "85" "85"
        ]


makeSix : Svg a
makeSix =
    g []
        [ diceCircle "35" "35"
        , diceCircle "35" "60"
        , diceCircle "35" "85"
        , diceCircle "85" "35"
        , diceCircle "85" "60"
        , diceCircle "85" "85"
        ]


diceCircle : String -> String -> Svg a
diceCircle x y =
    circle
        [ cx x, cy y, r "10", fill "white" ]
        []



-- Subscriptions


subscriptions : Dice -> Sub Msg
subscriptions model =
    Sub.none
