build an interactive app for voting and ranking the best  natural parks.

The app should allow users to vote on parks head to head, then calculate a ranking for the parks based on the chess ELO system.

The app should permanently display and match up along the overall rankings and recent votes.

- The voting should be done by clicking on the park's image.
- The ranking should be displayed under the voting part.
- Data should be saved into a SQLite DB

## Tech Stack
- JS  runtime: bun
- package manager: bun
- commands to run 'bun' or 'bunx'
- DO NOT use 'npm', `npx` or `pnpm` 
- JS development frameworks: react
- tailwind v4 - !careful with setting it up, use context7 to read latest docs!
- SQLite


## Data
- Use data with images and corresponding urls from file `src/frontend/src/park-images.json` which has the images for the parks extracted from wikipedia page https://en.wikipedia.org/wiki/List_of_national_parks_of_the_United_States

## Development Rules
- Use context7 mcp to get the latest phoenix and liveview docs
- use playwrite mcp to test front end