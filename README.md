# The Game of the Goose

Install the dependencies with `bundle`, then launch the game with `bundle exec ruby game.rb` (requires Ruby and the bundler gem).

Alternatively, with Docker: `docker build .` then, `docker run -it <image hash>`.

## Project structure

The game logic is implemented in a gem inside `goose_game`. The command line
interface is in `game.rb`.

## Commands

  * `quit`: exit the game
  * `add player Xx`: add player Xx
  * `move Xx 3, 2`: move player Xx by 5 positions
  * `move Xx`: move player Xx using a random dice roll
