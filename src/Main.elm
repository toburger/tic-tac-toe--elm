module Main exposing (..)

import Html exposing (..)
import Html.Attributes as A
import Html.Events as E
import Types exposing (..)
import GameLogic


type alias Model =
    { board : Board
    , currentPlayer : Player
    , gameState : GameState
    }


type Msg
    = Move ( Int, Int )
    | Restart


initialModel : Model
initialModel =
    { board = GameLogic.createBoard ( 3, 3 )
    , currentPlayer = PlayerX
    , gameState = Continue
    }


nextPlayer : Player -> Player
nextPlayer player =
    case player of
        PlayerX ->
            PlayerO

        PlayerO ->
            PlayerX


nextMove : ( Int, Int ) -> Model -> Model
nextMove ( x, y ) model =
    let
        newBoard =
            GameLogic.updateBoard ( x, y ) (Player model.currentPlayer) model.board

        nextPlayer_ =
            nextPlayer model.currentPlayer

        newGameState =
            GameLogic.getGameState newBoard
    in
        { model
            | board = newBoard
            , currentPlayer = nextPlayer_
            , gameState = newGameState
        }


update : Msg -> Model -> Model
update msg model =
    case msg of
        Move ( x, y ) ->
            if GameLogic.canUpdateBoard ( x, y ) model.board then
                nextMove ( x, y ) model
            else
                model

        Restart ->
            initialModel


type alias OnMove =
    ( Int, Int ) -> Msg


player : String -> String -> Html Msg
player src className =
    img [ A.class className, A.src src ] []


playerXImage : String
playerXImage =
    "https://toburger.github.io/tic-tac-toe/static/media/PlayerX.6a80d7b3.svg"


playerOImage : String
playerOImage =
    "https://toburger.github.io/tic-tac-toe/static/media/PlayerO.b936ed0a.svg"


restartImage : String
restartImage =
    "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADEAAAAxCAMAAABEQrEuAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAMAUExURQAAAJqtsJutsZqusZuuspyusZyusp2vs52ws56wtJ+xtZ+ytJ+ytaCxtKCxtaCytaGytqOzt6K0t6S0t6O0uKS0uKS1uaW2uKW2uae3uqe4uqe4u6i4u6m5vKm6vKq6vay8vqy8v669wK6+wK6+wbHAwrLAw7PBxLPCxLTCxLXDxbXDxrXExrbEx7jFyLnGyLnGybvIyrzJy77KzL7KzcDMzsHNz8LOz8LO0MPP0cTP0cTQ0sbR08fS08jS1MjT1cvU1svU18zV183W2M7X2c/Y2c/Y2tDY2tHZ29Ha29La3NPb3dPc3dTc3dbe39ff4Nff4dje4Njf4dng4Njg4dvh49vi49zj5N3j5d3k5d7k5uDl5uHm5+Hn6OHo6OPo6ePp6uTp6eTp6uXq6uXq6+fs7Ojs7ent7uru7uzv8Ozv8erx8uvx8+ry8uvy8+zw8O3x8uzx8+3y8uzy8+zy9O3z9e309O709e/19vDz8/Dz9PHz9fH09PH09fD19vH19/D29vH29/T29vT39/L2+PT3+PT3+fP4+PX4+PX4+fb5+vb6+vf6+/j5+fj5+vj6+vj6+/v8/P///wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMPhzfUAAAEAdFJOU////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////wBT9wclAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAGXRFWHRTb2Z0d2FyZQBwYWludC5uZXQgNC4wLjE2RGmv9QAABBRJREFUSEt9Vv9DGzUUryJpMsU7Y6utFh0i+AXQjZVNHTIU57Rz4hc2YG6iMueXjjq9q7FIb7153bhjOuQfju/lkrtrC35+uHz7fPLyXl6Sy8lDEHUD3/OD8KFu92BAEXVcxxWe53tt4ThuoLtT9CkCx/EiXUeEouGGuq7Ro/Abzb5hQOD0ajKKPcfd09VeBA2ha4hU4dd9XdtePz8/Vz29UNv8S/eIW+lciUI09lXp1aZ4nlDGGCWsfGpNdcp79WRlRiFcVXTPPUMYLxrYlIx9pgb2tkzUtEI4qlh5ntiabGCRV37CoQf1rqJoRaehijPDluZlwexlHIzqsS9KEdXxG04PaU4fbLKE48Et/MaKhnJrimjGAPjQeSQIFWRUeKpWHdbjh+BpsoKULUwHVGxh65MjlhTD5reBE2BAQfGHB2WL9wXJttIgA+g0TuuAEVCoOFXzekiDT06VyBO6gSCrwApg/TkZNKH6s53MyCjD73J7Z+1VktphEzgxzJ6TzXtQmzcmrOrG1eUyEHnljS92L42ka2XfAE8EoMDd/ueFZMRaPdivQKvARx59qXXt8cQKfRuIXSFzEfp/g+ruYsHe3Nkd1Xpa2LmUbJI1BsR9V+bQGXkh8Zt8cNtaOm4ssvH9SZM43PoFmI7MeXgq5tBZ1V3yZrPJOHRlPZmMXgGmG+UEOj4zonvZyXYaNcCxE17JtMlHwBS7OXWyJ4xpsvRt4hLCHv1z0pjMLwKzHeTUsR/XimdJbaUnHzlvzZjZ6AIwvaDfxoWvejafl1qvJTbej23EfhjP2Rknc2ghpK+3RxM/asAUYRyrt8zi7Re7k8d0HVo2+XgzjdU6MCFWaj9qSXd+7VqS9tbMRCE8aSbjNib8r7DnmCU3zarAyN9nH9H1/Dvt71aTEWsciA9hB1VeyTHjepGe+Hd+OPaFzh0cTCfBpu8CD1YEuYsX0XtpTPNvhtenbGaXYDu3d75PM+Ym8JpdUOxiKrZ4GiFa+bS9fUOHr/KcKkCgDqE6H7KBD8vZzMbZtDy7qDKQc16I+4psA1i+OoPyDkbrbjmTf0XOCKwqCzKrTMAlh3eJuqMvH3lbIaxyGzi+vktkR93S8/9z/TzFriOljutHhXTu4/fUkRJOPkeC28GvUjxQYnl6KJtSKSz2JQ7HS4kVMlBXtVxiyQ5nkK98jYNhzNEK6f2mio2XH0s2X4PS6l0cCuv6DdYK2Y6fHHlxjOZtswfcIk9OK59BYJ41o5AdM8d6ddSmjAIYH1/4Ie7s6OcGkChgFryxVe3Hyx+eW1i8eDVeKsB14mcVkSqk/D1+eQbgJXMhsgoZuof8h3gNkRoA9ChQ0xDdlBD5rtPLH1AAAuG4blMI4eJP0OA6BxWIKAz8btg3uYKU/wG8TKU6ZqxftgAAAABJRU5ErkJggg=="


playerX : String -> Html Msg
playerX =
    player playerXImage


playerO : String -> Html Msg
playerO =
    player playerOImage


playerXM : Html Msg
playerXM =
    playerX "PlayerX"


playerOM : Html Msg
playerOM =
    playerO "PlayerO"


playerXS : Html Msg
playerXS =
    playerX "PlayerX PlayerX--Small"


playerOS : Html Msg
playerOS =
    playerO "PlayerO PlayerO--Small"


dispatchCellValue : Cell -> Html Msg
dispatchCellValue cell_ =
    case cell_ of
        Empty ->
            span [ A.class "NoPlayer" ] []

        Player PlayerX ->
            playerXM

        Player PlayerO ->
            playerOM


cell : OnMove -> ( Int, Int ) -> Cell -> Html Msg
cell onMove ( x, y ) cell_ =
    button
        [ A.class "Cell"
        , A.disabled (cell_ /= Empty)
        , E.onClick (onMove ( x, y ))
        ]
        [ dispatchCellValue cell_ ]


row : OnMove -> Int -> List Cell -> Html Msg
row onMove x cells =
    div
        [ A.class "Board__Row"
        ]
        (cells
            |> List.indexedMap (\y -> cell onMove ( x, y ))
        )


board : OnMove -> Board -> Html Msg
board onMove board_ =
    div [ A.class "Board" ]
        (board_ |> List.indexedMap (row onMove))


dispatchPlayer : Player -> Html Msg
dispatchPlayer player =
    case player of
        PlayerX ->
            playerXS

        PlayerO ->
            playerOS


currentPlayer : Player -> Html Msg
currentPlayer currentPlayer_ =
    div [ A.class "CurrentPlayer" ]
        [ span [ A.class "CurrentPlayer__Text" ]
            [ text "Player: "
            , dispatchPlayer currentPlayer_
            ]
        ]


game : OnMove -> Board -> Player -> Html Msg
game onMove board_ currentPlayer_ =
    div []
        [ board onMove board_
        , currentPlayer currentPlayer_
        ]


gameOverPlayer : Player -> Html Msg
gameOverPlayer player =
    span []
        [ text "Player"
        , case player of
            PlayerX ->
                playerXS

            PlayerO ->
                playerOS
        , text "wins"
        ]


gameOver : Msg -> GameOver -> Html Msg
gameOver onRestart gameOver_ =
    div [ A.class "GameOver" ]
        [ img
            [ A.class "GameOver__Image"
            , E.onClick onRestart
            , A.src restartImage
            , A.alt "Restart"
            ]
            []
        , p [ A.class "GameOver__Text" ]
            [ case gameOver_ of
                Draw ->
                    text "It's a draw"

                Winner player ->
                    gameOverPlayer player
            ]
        ]


preloadImages : List (Html Msg)
preloadImages =
    [ playerXImage, playerOImage ]
        |> List.map
            (\href ->
                node "link" [ A.rel "prefetch", A.href href ] []
            )


app : Model -> Html Msg
app model =
    div
        [ A.class "App" ]
        [ case model.gameState of
            Continue ->
                game Move model.board model.currentPlayer

            GameOver gameOver_ ->
                gameOver Restart gameOver_
        ]


view : Model -> Html Msg
view model =
    div [] (app model :: preloadImages)


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initialModel
        , update = update
        , view = view
        }
