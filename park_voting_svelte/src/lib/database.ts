import Database from 'better-sqlite3';
import parkImages from './park-images.json';

const db = new Database('parks.db');

// Create tables
db.exec(`
  CREATE TABLE IF NOT EXISTS parks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT UNIQUE NOT NULL,
    image_url TEXT NOT NULL,
    elo_rating INTEGER DEFAULT 1200,
    total_votes INTEGER DEFAULT 0
  );

  CREATE TABLE IF NOT EXISTS votes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    winner_id INTEGER NOT NULL,
    loser_id INTEGER NOT NULL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (winner_id) REFERENCES parks (id),
    FOREIGN KEY (loser_id) REFERENCES parks (id)
  );
`);

// Initialize parks data if empty
const parkCount = db.prepare('SELECT COUNT(*) as count FROM parks').get() as { count: number };
if (parkCount.count === 0) {
  const insertPark = db.prepare('INSERT INTO parks (name, image_url) VALUES (?, ?)');
  
  for (const [name, imageUrl] of Object.entries(parkImages)) {
    insertPark.run(name, imageUrl);
  }
}

// ELO rating calculation
export function calculateEloRating(winnerRating: number, loserRating: number, kFactor = 32) {
  const expectedWinner = 1 / (1 + Math.pow(10, (loserRating - winnerRating) / 400));
  const expectedLoser = 1 / (1 + Math.pow(10, (winnerRating - loserRating) / 400));
  
  const newWinnerRating = Math.round(winnerRating + kFactor * (1 - expectedWinner));
  const newLoserRating = Math.round(loserRating + kFactor * (0 - expectedLoser));
  
  return { newWinnerRating, newLoserRating };
}

// Database operations
export const parkQueries = {
  getAll: db.prepare('SELECT * FROM parks ORDER BY elo_rating DESC'),
  getById: db.prepare('SELECT * FROM parks WHERE id = ?'),
  getRandomPair: db.prepare(`
    SELECT * FROM parks 
    ORDER BY RANDOM() 
    LIMIT 2
  `),
  updateRating: db.prepare('UPDATE parks SET elo_rating = ?, total_votes = total_votes + 1 WHERE id = ?')
};

export const voteQueries = {
  getRecent: db.prepare(`
    SELECT 
      v.timestamp,
      pw.name as winner_name,
      pl.name as loser_name
    FROM votes v
    JOIN parks pw ON v.winner_id = pw.id
    JOIN parks pl ON v.loser_id = pl.id
    ORDER BY v.timestamp DESC
    LIMIT 10
  `),
  insertVote: db.prepare('INSERT INTO votes (winner_id, loser_id) VALUES (?, ?)')
};

export function recordVote(winnerId: number, loserId: number) {
  const winner = parkQueries.getById.get(winnerId) as any;
  const loser = parkQueries.getById.get(loserId) as any;
  
  if (!winner || !loser) {
    throw new Error('Invalid park IDs');
  }
  
  const { newWinnerRating, newLoserRating } = calculateEloRating(winner.elo_rating, loser.elo_rating);
  
  // Update ratings and vote counts
  parkQueries.updateRating.run(newWinnerRating, winnerId);
  parkQueries.updateRating.run(newLoserRating, loserId);
  
  // Record the vote
  voteQueries.insertVote.run(winnerId, loserId);
  
  return { winner, loser, newWinnerRating, newLoserRating };
}

export default db;