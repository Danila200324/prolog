%-------------------------------
% Tic-Tac-Toe Game in Prolog
%-------------------------------

% Entry point to start the game
% Calls display_instructions/0 to show the initial instructions and
% start_game/0 to start the two-player game.
go :-
    display_instructions,
    start_game.

% Display instructions for the player
% Outputs the welcome message, instructions, and initial board layout.
display_instructions :-
    nl, write('Welcome to Tic-Tac-Toe!'), nl,
    write('Player X and Player O, take turns to make your moves.'), nl,
    write('Enter your move as a number (1-9) followed by a period.'), nl,
    write('The board positions are numbered as follows:'), nl,
    display_board([1,2,3,4,5,6,7,8,9]), nl.

% Start the game with an empty board and initiate the turn for Player X.
start_game :-
    InitialBoard = ['-','-','-','-','-','-','-','-','-'],
    play_game(InitialBoard, x).

% Display the current state of the board
% Formats and outputs the board in a 3x3 grid.
display_board([A,B,C,D,E,F,G,H,I]) :-
    format(' ~w | ~w | ~w ~n---+---+---~n ~w | ~w | ~w ~n---+---+---~n ~w | ~w | ~w ~n', [A,B,C,D,E,F,G,H,I]), nl.

% Manage the game loop
% Alternates turns between players, checks for a win or tie after each move.
play_game(Board, Player) :-
    display_board(Board),
    (game_over(Board, Winner) ->
        (Winner == tie -> write('Game ended in a tie!'), nl;
         format('Player ~w wins!', [Winner]), nl);
    next_move(Board, Player, NewBoard),
    switch_player(Player, NextPlayer),
    play_game(NewBoard, NextPlayer)).

% Prompt the current player for their move, validate it, and update the board.
next_move(Board, Player, NewBoard) :-
    format('Player ~w, enter your move: ', [Player]),
    read(Position),
    (valid_move(Board, Position) ->
        make_move(Board, Position, Player, NewBoard);
    invalid_move_message, next_move(Board, Player, NewBoard)).

% Switch to the other player.
switch_player(x, o).
switch_player(o, x).

% Check if a move is valid (position is between 1 and 9 and the cell is empty)
% Ensures the position is within the valid range and the cell is empty.
valid_move(Board, Position) :-
    integer(Position), Position >= 1, Position =< 9,
    nth1(Position, Board, '-').

% Make a move on the board
% Places the player's symbol at the specified position on the board.
make_move(Board, Position, Player, NewBoard) :-
    nth1(Position, Board, '-', Rest),
    nth1(Position, NewBoard, Player, Rest).

% Display an invalid move message
% Outputs a message indicating the move is invalid.
invalid_move_message :-
    write('Illegal move. Try again.'), nl.

% Determine if the game is over with a win for the given player or a tie
% Checks if there is a winner or if the board is full resulting in a tie.
game_over(Board, Winner) :-
    (win(Board, x) -> Winner = x;
     win(Board, o) -> Winner = o;
     board_full(Board) -> Winner = tie;
     fail).

% Check if the board is full
% Determines if there are no empty cells remaining on the board.
board_full(Board) :-
    \+ member('-', Board).

% Check for winning conditions
% Verifies if there is a row, column, or diagonal win for the given player.
win(Board, Player) :- row_win(Board, Player);
                      column_win(Board, Player);
                      diagonal_win(Board, Player).

% Row win conditions
% Checks if the player has three symbols in any row.
row_win(Board, Player) :- Board = [Player,Player,Player,_,_,_,_,_,_];
                          Board = [_,_,_,Player,Player,Player,_,_,_];
                          Board = [_,_,_,_,_,_,Player,Player,Player].

% Column win conditions
% Checks if the player has three symbols in any column.
column_win(Board, Player) :- Board = [Player,_,_,Player,_,_,Player,_,_];
                             Board = [_,Player,_,_,Player,_,_,Player,_];
                             Board = [_,_,Player,_,_,Player,_,_,Player].

% Diagonal win conditions
% Checks if the player has three symbols in any diagonal.
diagonal_win(Board, Player) :- Board = [Player,_,_,_,Player,_,_,_,Player];
                               Board = [_,_,Player,_,Player,_,Player,_,_].
