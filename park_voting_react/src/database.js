import { Database } from 'bun:sqlite';
import parkImages from '../park-images.json' assert { type: 'json' };

const db = new Database('parks.db');

// Initialize database tables
export function initializeDatabase() {
  // Create parks table
  db.exec(`
    CREATE TABLE IF NOT EXISTS parks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT UNIQUE NOT NULL,
      image_url TEXT NOT NULL,
      elo_rating INTEGER DEFAULT 1200,
      total_votes INTEGER DEFAULT 0
    )
  `);

  // Create votes table
  db.exec(`
    CREATE TABLE IF NOT EXISTS votes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      winner_id INTEGER NOT NULL,
      loser_id INTEGER NOT NULL,
      timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (winner_id) REFERENCES parks (id),
      FOREIGN KEY (loser_id) REFERENCES parks (id)
    )
  `);

  // Insert park data if not exists
  const insertPark = db.prepare(`
    INSERT OR IGNORE INTO parks (name, image_url) VALUES (?, ?)
  `);

  Object.entries(parkImages).forEach(([name, imageUrl]) => {
    insertPark.run(name, imageUrl);
  });
}

// ELO rating calculation
function calculateELO(winnerRating, loserRating, kFactor = 32) {
  const expectedWinner = 1 / (1 + Math.pow(10, (loserRating - winnerRating) / 400));
  const expectedLoser = 1 / (1 + Math.pow(10, (winnerRating - loserRating) / 400));
  
  const newWinnerRating = Math.round(winnerRating + kFactor * (1 - expectedWinner));
  const newLoserRating = Math.round(loserRating + kFactor * (0 - expectedLoser));
  
  return { newWinnerRating, newLoserRating };
}

// Submit a vote
export function submitVote(winnerId, loserId) {
  const transaction = db.transaction(() => {
    // Get current ratings
    const getParks = db.prepare('SELECT id, elo_rating, total_votes FROM parks WHERE id IN (?, ?)');
    const parks = getParks.all(winnerId, loserId);
    
    const winner = parks.find(p => p.id === winnerId);
    const loser = parks.find(p => p.id === loserId);
    
    if (!winner || !loser) {
      throw new Error('Invalid park IDs');
    }
    
    // Calculate new ELO ratings
    const { newWinnerRating, newLoserRating } = calculateELO(winner.elo_rating, loser.elo_rating);
    
    // Update ratings and vote counts
    const updatePark = db.prepare('UPDATE parks SET elo_rating = ?, total_votes = total_votes + 1 WHERE id = ?');
    updatePark.run(newWinnerRating, winnerId);
    updatePark.run(newLoserRating, loserId);
    
    // Record the vote
    const insertVote = db.prepare('INSERT INTO votes (winner_id, loser_id) VALUES (?, ?)');
    insertVote.run(winnerId, loserId);
    
    return { winnerId, loserId, newWinnerRating, newLoserRating };
  });
  
  return transaction();
}

// Get random pair of parks for voting
export function getRandomParkPair() {
  const getParks = db.prepare('SELECT * FROM parks ORDER BY RANDOM() LIMIT 2');
  return getParks.all();
}

// Get park rankings
export function getRankings(limit = 20) {
  const getRanked = db.prepare(`
    SELECT name, image_url, elo_rating, total_votes,
           ROW_NUMBER() OVER (ORDER BY elo_rating DESC) as rank
    FROM parks 
    ORDER BY elo_rating DESC 
    LIMIT ?
  `);
  return getRanked.all(limit);
}

// Get recent votes
export function getRecentVotes(limit = 10) {
  const getRecent = db.prepare(`
    SELECT 
      v.timestamp,
      w.name as winner_name,
      w.image_url as winner_image,
      l.name as loser_name,
      l.image_url as loser_image
    FROM votes v
    JOIN parks w ON v.winner_id = w.id
    JOIN parks l ON v.loser_id = l.id
    ORDER BY v.timestamp DESC
    LIMIT ?
  `);
  return getRecent.all(limit);
}

// Get park by ID
export function getParkById(id) {
  const getPark = db.prepare('SELECT * FROM parks WHERE id = ?');
  return getPark.get(id);
}

// Initialize database on module load
initializeDatabase();

export default db;