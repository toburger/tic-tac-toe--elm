module GameLogic exposing (canUpdateBoard, createBoard, getField, getGameState, updateBoard)

import List.Extra as List
import Types exposing (..)


times : Int -> List Int
times x =
    List.range 1 x


createBoard : ( Int, Int ) -> List (List Cell)
createBoard ( width, height ) =
    List.map
        (always
            (List.map
                (always Empty)
                (times width)
            )
        )
        (times height)


updateBoard : ( Int, Int ) -> Cell -> Board -> Board
updateBoard ( x, y ) v board =
    board
        |> List.indexedMap
            (\x_ zs ->
                zs
                    |> List.indexedMap
                        (\y_ v_ ->
                            if x_ == x && y_ == y then
                                v

                            else
                                v_
                        )
            )


getField : ( Int, Int ) -> Board -> Maybe Cell
getField ( x, y ) board =
    board
        |> List.getAt x
        |> Maybe.andThen (List.getAt y)


canUpdateBoard : ( Int, Int ) -> Board -> Bool
canUpdateBoard ( x, y ) board =
    getField ( x, y ) board == Just Empty


checkRowsForWinner : Cell -> Board -> Bool
checkRowsForWinner v board =
    board
        |> List.any (List.all ((==) v))


checkColsForWinner : Cell -> Board -> Bool
checkColsForWinner v board =
    board
        |> List.transpose
        |> checkRowsForWinner v


checkDiagonalsForWinner : Cell -> Board -> Bool
checkDiagonalsForWinner v board =
    let
        getField_ =
            \a -> getField a board

        diag1 =
            [ getField_ ( 0, 0 ), getField_ ( 1, 1 ), getField_ ( 2, 2 ) ]

        diag2 =
            [ getField_ ( 2, 0 ), getField_ ( 1, 1 ), getField_ ( 0, 2 ) ]
    in
    [ diag1, diag2 ]
        |> List.any (List.all ((==) (Just v)))


checkForWinner : Cell -> Board -> Bool
checkForWinner v board =
    [ checkRowsForWinner, checkColsForWinner, checkDiagonalsForWinner ]
        |> List.any (\x -> x v board)


checkForDraw : Board -> Bool
checkForDraw board =
    board
        |> List.all (List.all ((/=) Empty))


getGameState : Board -> GameState
getGameState board =
    if checkForWinner (Player PlayerX) board then
        GameOver (Winner PlayerX)

    else if checkForWinner (Player PlayerO) board then
        GameOver (Winner PlayerO)

    else if checkForDraw board then
        GameOver Draw

    else
        Continue
