module KonamiCode
    exposing
        ( KonamiCode
        , Msg
        , init
        , subscribe
        , update
        )

{-| This amazingly necessary library allows you to see if the Konami
Code has been entered on your website.

    import KonamiCode exposing (KonamiCode)

    type alias Model =
        { konamiCode : KonamiCode
        }

    type Msg
        = KonamiCodeMsg KonamiCode.Msg

    init : ( Model, Cmd Msg )
    init =
        ( { konamiCode = KonamiCode.init }
        , Cmd.none
        )

    update : Msg -> Model -> ( Model, Cmd Msg )
    update msg model =
        case msg of
            KonamiCodeMsg msg ->
                let
                    ( newModel, konamiCodeEntered ) =
                        KonamiCode.update msg model
                in
                ( { newModel
                    | showEasterEgg =
                        model.showEasterEgg || konamiCodeEntered
                  }
                , Cmd.none
                )

    subscriptions : Model -> Sub Msg
    subscriptions model =
        KonamiCode.subscribe KonamiCodeMsg

@docs KonamiCode, Msg, init, update, subscribe

-}

import Keyboard exposing (KeyCode)


{-| An opaque type used to model the Konami Code.
-}
type KonamiCode
    = KonamiCode (List KeyCode)


{-| KonamiCode Msg type. Create a `Msg` to handle these.

    type Msg
        = KonamiCodeMsg KonamiCode.Msg

-}
type Msg
    = KeyPressed KeyCode


{-| KonamiCode model.
-}
type alias Model r =
    { r | konamiCode : KonamiCode }


{-| KonamiCode `subscribe`-function. To be used to subscribe to
hook up a handler for `Msg`s and when the code has been entered
correctly.

    subscriptions : Model -> Sub Msg
    subscriptions model =
        KonamiCode.subscribe KonamiCodeMsg

-}
subscribe : (Msg -> msg) -> Sub msg
subscribe tagger =
    Keyboard.downs (tagger << KeyPressed)


{-| KonamiCode update function. To be used with in your
`update`-function when matching against `KonamiCodeMsg`.

    update : Msg -> Model -> ( Model, Cmd Msg )
    update msg model =
        case msg of
            KonamiCodeMsg msg ->
                let
                    ( newModel, konamiCodeEntered ) =
                        KonamiCode.update msg model
                in
                ( { newModel
                    | showEasterEgg =
                        model.showEasterEgg || konamiCodeEntered
                  }
                , Cmd.none
                )

-}
update : Msg -> Model r -> ( Model r, Bool )
update msg model =
    case msg of
        KeyPressed keyCode ->
            let
                (KonamiCode konamiCode) =
                    model.konamiCode

                newCode =
                    (keyCode :: konamiCode)
                        |> List.take 10
                        |> KonamiCode
            in
            ( { model | konamiCode = newCode }
            , newCode == correctCode
            )


{-| Create an initial KonamiCode. To be used to set `konamiCode` when
initializing your `Model`.

    init : ( Model, Cmd Msg )
    init =
        ( { konamiCode = KonamiCode.init }
        , Cmd.none
        )

-}
init : KonamiCode
init =
    KonamiCode []


{-| The KonamiCode-value when the correct code has been entered.
-}
correctCode : KonamiCode
correctCode =
    KonamiCode [ 66, 65, 39, 37, 39, 37, 40, 40, 38, 38 ]
