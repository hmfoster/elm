module Main exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import String
import Regex
import Debug


main : Program Never
main =
    App.beginnerProgram { model = model, update = update, view = view }



-- Model


type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    , verification : { color : String, message : String }
    }


model : Model
model =
    Model "" "" "" { color = "", message = "" }



-- Update


type Msg
    = Name String
    | Password String
    | PasswordAgain String
    | Verify


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }

        Password password ->
            { model | password = password }

        PasswordAgain password ->
            { model | passwordAgain = password }

        Verify ->
            verify model


verify : Model -> Model
verify model =
    let
        pswd =
            model.password

        short =
            (String.length pswd) < 8

        missingChar =
            (charFind pswd "[a-z]") && (charFind pswd "[A-Z]") && (charFind pswd "\\d")

        ( color, message ) =
            if pswd /= model.passwordAgain then
                ( "red", "Passwords do not match!" )
            else if short then
                ( "red", "Password is too short" )
            else if not missingChar then
                ( "red", "Password must in include upper case, lower case, and numeric characters" )
            else
                ( "green", "OK" )

        verification =
            { color = color, message = message }
    in
        { model | verification = verification }


charFind : String -> String -> Bool
charFind str pattern =
    let
        result =
            Regex.contains (Regex.regex pattern) str

        x =
            Debug.log (toString result)
    in
        result



-- View


view : Model -> Html Msg
view model =
    div []
        [ Html.form []
            [ input [ placeholder "Enter Your Name", onInput Name ] []
            , input [ placeholder "Enter Your Passord", onInput Password ] []
            , input [ placeholder "Re-Enter Your Password", onInput PasswordAgain ] []
            ]
        , button [ onClick Verify ] [ text "Submit" ]
        , viewVerification model
        ]


viewVerification : Model -> Html msg
viewVerification model =
    div [ style [ ( "color", model.verification.color ) ] ] [ text model.verification.message ]
