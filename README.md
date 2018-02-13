# elm-konami-code

Use the [Konami Code](https://en.wikipedia.org/wiki/Konami_Code) to do awesome (or boring) stuff on your website.

## Installation

```sh
elm-package install ahstro/elm-konami-code
```

## Usage

```elm
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
```
