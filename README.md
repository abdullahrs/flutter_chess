# flutter_chess

## Features
---
 - **Piece Movements** [✓] 
   - Normal moves [✓]
   - Captures [✓]
   - En-passant [✓]
   - Castling [✓]
     - Long Castling [✓]
     - Short Castling [✓]
     - No castling while the squares in between the castle and king are under attack. [✓]
 - **King statuses** [✓]
   - Other pieces cannot move while the king is under attack. [✓]
   - Only moves that can prevent an attack on the king are allowed. [✓]
   - If another piece is defending a piece, the king cannot take it. [✓]
   - If another piece is defending a square, the king cannot move to that square. [✓]
 - **Checkmate** [*X*]
   - If the king of the player who has the turn of the move is under attack and any move player can make does not break this situation, player is checkmated and popup appears. [*X*]
 - **Promotion** [*X*]
   - Pawn that reaches the eighth rank to be replaced by the player's choice of a bishop, knight rook, or queen of the same color . [*X*]
 - **Timer** [*X*]
   - Losing the game when the time is up. [*X*]
   - Time increase per move. [*X*] 
   - Bullet (1+0, 2+1), Blitz (3+0, 3+2, 5+0, 5+3), Rapid (10+0, 10+5, 15+10), Unlimited time options. [*X*]
 - **Resign** [*X*]
 - **Draw** [*X*]
   - Player's draw offer. [*X*]
   - Draw resulting from the repetition of the same moves. [*X*]
   - Draw causing by insufficient material. [*X*]
   - Draw causing by a lack of available moves to make(Stealmate). [*X*]
   - The 50 move-rule allows either player to claim a draw if no capture has been made or no pawn has been moved in the last 50 moves. [*X*]
 - **Draggable Pieces** [*X*]