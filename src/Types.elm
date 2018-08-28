module Types exposing (Board, Cell(..), GameOver(..), GameState(..), Player(..))


type Player
    = PlayerX
    | PlayerO


type GameOver
    = Winner Player
    | Draw


type GameState
    = GameOver GameOver
    | Continue


type Cell
    = Player Player
    | Empty


type alias Board =
    List (List Cell)
