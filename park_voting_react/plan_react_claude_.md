You are tasked with building an interactive app for voting and ranking the best natural parks in the United States. The app should allow users to vote on parks head-to-head, calculate rankings based on the chess ELO system, and display overall rankings and recent votes. Follow these instructions carefully to complete the task.

First, here's the park images JSON data you'll be working with:

<park_images_json>
{{PARK_IMAGES_JSON}}
</park_images_json>

1. Project Setup:
   a. a bun project has already been initialised in this directory
   c. Install necessary dependencies:
      - Run `bun add react react-dom`
      - Run `bun add -d tailwindcss@latest postcss autoprefixer`
      - Run `bunx tailwindcss init -p`

2. Frontend Setup:
   a. Create a new file `src/index.jsx` for the main React component.
   b. Create a new file `src/index.html` for the HTML template.
   c. Update `src/index.html` to include the necessary structure and script tags.
   d. Configure Tailwind CSS by updating the `tailwind.config.js` file.

3. Implement the Voting System:
   a. Create a component for displaying two parks side by side.
   b. Implement a function to randomly select two parks for voting.
   c. Add click handlers to park images for vote submission.

4. Implement the ELO Ranking System:
   a. Create a function to calculate ELO ratings after each vote.
   b. Implement a system to update and store park rankings.

5. Set up SQLite Database:
   a. Create a new file `src/database.js` for database operations.
   b. Implement functions for initializing the database, inserting votes, and retrieving rankings.

6. Connect Frontend with Backend:
   a. Create API endpoints for submitting votes and retrieving rankings.
   b. Update the frontend to use these API endpoints.

7. Display Rankings and Recent Votes:
   a. Create a component to display the overall rankings.
   b. Implement a section to show recent votes.

8. Testing:
   a. Set up Playwright for frontend testing.
   b. Write tests for key functionalities like voting and displaying rankings.

Remember to use Bun as the JavaScript runtime and package manager. Use `bun` or `bunx` for running commands, and avoid using `npm`, `npx`, or `pnpm`. Utilize React for the frontend development and Tailwind CSS v4 for styling. Make sure to use the latest Phoenix and LiveView documentation by referencing context7.

When implementing the ELO ranking system, ensure that the algorithm accurately reflects the voting results and updates the rankings accordingly.

For the SQLite database, create appropriate tables to store park information, votes, and rankings. Implement efficient queries to retrieve and update data as needed.

Throughout the development process, follow best practices for code organization, error handling, and performance optimization. Use meaningful variable and function names, and include comments where necessary to explain complex logic.

Finally, thoroughly test the application using Playwright to ensure all features work as expected, including voting, ranking calculation, and data persistence.

Your final output should include the complete code for the application, organized into appropriate files and directories. Include a README file with instructions on how to set up and run the application.

PARK_IMAGES_JSON=park-images.json