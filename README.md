# Pattern Matching Game
Matching Game Challenge Question for Shopify Mobile Development Intern in iOS

This application uses SpriteKit to draw the game grid and pattern sprites, URLSession to query the Shopify API and download images from the src strings, DispatchQueues, Timers and NotificationCenter for animations and observing changes to events. This is my first time using SpriteKit but I picked it over using Collection Views which may not be the best implementation for a game-related problem. Autolayout also works, tested on simulators and iPhone XS, portrait only though.

App icon generated using `https://appiconmaker.co`

### What I learnt from this
- SpriteKit is a pretty interesting framework to easily load and animate textures. 
- UIStepper/UIControl has no delegate protocols which make it a little bit harder to work with, used NotificationCenter and tags to deal with that. 
- Pulling only necessary data from large jsons with structs and Decodable.

## Requirements:
1. The user should have to find a minimum of 10 pairs to win. 
2. Keep track of how many pairs the user has found. 
3. When the user wins, display a message to let them know!
4. Make sure it compiles successfully.

### THE RULES FOR PLAYING "MEMORY"
1. Mix up the cards.
2. Lay them in rows, face down.
3. Turn over any two cards.
4. If the two cards match, keep them.
5. If they don't match, turn them back over.
6. Remember what was on each card and where it was.
7. Watch and remember during the other player's turn.
8. The game is over when all the cards have been matched.
9. The player with the most matches wins.

## Bonuses!
- [x] Make the game configurable to match 3 or 4 of the same products instead of 2.
- [x] Make the grid size configurable. (The player needs to match more than 10 sets of the same product).
- [x] Build a slick screen that keeps track of the user’s score.
- [x] Make a button that shuffles the game.
- [x] Feel free to make the app beautiful and add anything else you think would be cool!
