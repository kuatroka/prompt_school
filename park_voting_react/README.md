# 🏞️ National Parks Voting App

An interactive web application for voting and ranking the best national parks in the United States using the ELO rating system. Built with React, Bun, SQLite, and Tailwind CSS.

## ✨ Features

- **Head-to-Head Voting**: Vote between two randomly selected national parks
- **ELO Rating System**: Chess-style ranking algorithm that accurately reflects voting results
- **Real-time Rankings**: See how parks rank against each other based on community votes
- **Recent Votes**: Track the latest voting activity
- **Responsive Design**: Works seamlessly on desktop and mobile devices
- **Fast Performance**: Built with Bun for lightning-fast JavaScript runtime
- **Persistent Data**: SQLite database stores all votes and rankings

## 🚀 Quick Start

### Prerequisites

- [Bun](https://bun.sh/) (latest version)
- Node.js 18+ (for compatibility)

### Installation

1. **Clone or navigate to the project directory**:
   ```bash
   cd park_voting_react
   ```

2. **Install dependencies**:
   ```bash
   bun install
   ```

3. **Start the development server**:
   ```bash
   bun run dev
   ```

4. **Open your browser** and visit:
   ```
   http://localhost:3000
   ```

## 🎮 How to Use

### Voting
1. Visit the homepage to see two randomly selected national parks
2. Click on the park you prefer
3. Your vote is recorded and ELO ratings are updated
4. A new pair of parks will be presented for the next vote

### Viewing Rankings
1. Click the "Rankings" tab to see the current leaderboard
2. Parks are ranked by their ELO rating (higher = better)
3. See each park's current rating and total vote count

### Recent Activity
1. Click "Recent Votes" to see the latest voting activity
2. View which parks won recent matchups
3. Track community voting patterns

## 🏗️ Project Structure

```
park_voting_react/
├── src/
│   ├── index.html          # Main HTML template
│   ├── index.jsx           # React application
│   └── database.js         # SQLite database operations
├── tests/
│   └── voting.spec.js      # Playwright tests
├── park-images.json        # National park data
├── server.js              # Bun server with API endpoints
├── package.json           # Dependencies and scripts
├── tailwind.config.js     # Tailwind CSS configuration
├── postcss.config.js      # PostCSS configuration
├── playwright.config.js   # Playwright test configuration
└── README.md             # This file
```

## 🔧 API Endpoints

The application provides several REST API endpoints:

- `GET /api/parks/random-pair` - Get two random parks for voting
- `POST /api/votes` - Submit a vote (requires `winnerId` and `loserId`)
- `GET /api/rankings?limit=20` - Get park rankings
- `GET /api/recent-votes?limit=10` - Get recent voting activity
- `GET /api/parks/:id` - Get specific park information

## 🧮 ELO Rating System

The app uses a chess-style ELO rating system to rank parks:

- **Starting Rating**: All parks begin with 1200 ELO
- **K-Factor**: 32 (determines rating change magnitude)
- **Calculation**: Based on expected vs actual outcomes
- **Updates**: Ratings adjust after each vote based on the relative strength of opponents

### How ELO Works
- When a highly-rated park beats a lower-rated park, it gains few points
- When a lower-rated park beats a higher-rated park, it gains many points
- This creates a balanced, competitive ranking system

## 🧪 Testing

The project includes comprehensive Playwright tests:

### Run Tests
```bash
# Install Playwright browsers (first time only)
bunx playwright install

# Run all tests
bunx playwright test

# Run tests in headed mode (see browser)
bunx playwright test --headed

# Run specific test file
bunx playwright test tests/voting.spec.js
```

### Test Coverage
- Homepage loading and navigation
- Voting functionality
- Rankings display
- Recent votes display
- API endpoint testing
- Mobile responsiveness
- Loading states

## 🛠️ Development

### Available Scripts

- `bun run dev` - Start development server
- `bun run start` - Start production server
- `bunx playwright test` - Run Playwright tests

### Database

The SQLite database (`parks.db`) is automatically created and initialized with:
- **parks table**: Stores park information, ELO ratings, and vote counts
- **votes table**: Records all voting activity with timestamps

Database operations are handled in `src/database.js` with functions for:
- Initializing tables and data
- Calculating ELO ratings
- Recording votes
- Retrieving rankings and recent activity

### Styling

The app uses Tailwind CSS v4 for styling:
- Responsive design with mobile-first approach
- Custom color scheme with green nature theme
- Smooth animations and transitions
- Accessible design patterns

## 🌟 Features in Detail

### Park Data
The app includes 63 US National Parks with:
- High-quality images from Wikimedia Commons
- Official park names
- Persistent ELO ratings
- Vote tracking

### User Experience
- **Fast Loading**: Optimized images and efficient data fetching
- **Smooth Interactions**: Loading states and transitions
- **Mobile Friendly**: Responsive design works on all devices
- **Accessible**: Proper semantic HTML and ARIA labels

### Performance
- **Bun Runtime**: Faster JavaScript execution
- **SQLite**: Lightweight, serverless database
- **Efficient Queries**: Optimized database operations
- **Image Optimization**: Properly sized park images

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Run the test suite
6. Submit a pull request

## 📝 License

This project is open source and available under the MIT License.

## 🙏 Acknowledgments

- National Park Service for the amazing parks
- Wikimedia Commons for park images
- React team for the excellent framework
- Bun team for the fast JavaScript runtime
- Tailwind CSS for the utility-first styling

---

**Built with ❤️ for nature lovers and voting enthusiasts!**
