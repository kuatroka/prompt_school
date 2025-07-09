import Database from 'better-sqlite3';
import path from 'path';
import fs from 'fs';

// For debugging
console.log('Initializing database...');

const dbPath = path.join(process.cwd(), 'parks.db');
const db = new Database(dbPath);

// Initialize database tables
db.exec(`
  CREATE TABLE IF NOT EXISTS parks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT UNIQUE NOT NULL,
    image_url TEXT NOT NULL,
    elo_rating INTEGER DEFAULT 1200,
    total_votes INTEGER DEFAULT 0,
    wins INTEGER DEFAULT 0,
    losses INTEGER DEFAULT 0
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

export interface Park {
  id: number;
  name: string;
  image_url: string;
  elo_rating: number;
  total_votes: number;
  wins: number;
  losses: number;
}

export interface Vote {
  id: number;
  winner_id: number;
  loser_id: number;
  timestamp: string;
}

// ELO rating calculation
function calculateELO(winnerRating: number, loserRating: number, kFactor: number = 32): { newWinnerRating: number; newLoserRating: number } {
  const expectedWinner = 1 / (1 + Math.pow(10, (loserRating - winnerRating) / 400));
  const expectedLoser = 1 / (1 + Math.pow(10, (winnerRating - loserRating) / 400));
  
  const newWinnerRating = Math.round(winnerRating + kFactor * (1 - expectedWinner));
  const newLoserRating = Math.round(loserRating + kFactor * (0 - expectedLoser));
  
  return { newWinnerRating, newLoserRating };
}

// Database operations
export const dbOperations = {
  // Initialize parks from JSON data
  initializeParks: (parksData: Record<string, string>) => {
    const insertPark = db.prepare(`
      INSERT OR IGNORE INTO parks (name, image_url) 
      VALUES (?, ?)
    `);
    
    const insertMany = db.transaction((parks: Array<[string, string]>) => {
      for (const park of parks) {
        insertPark.run(park);
      }
    });
    
    const parksArray = Object.entries(parksData);
    insertMany(parksArray);
  },

  // Get all parks ordered by ELO rating
  getAllParks: (): Park[] => {
    const stmt = db.prepare('SELECT * FROM parks ORDER BY elo_rating DESC');
    return stmt.all() as Park[];
  },

  // Get a random pair of parks for voting
  getRandomPair: (): [Park, Park] | null => {
    const parks = dbOperations.getAllParks();
    if (parks.length < 2) return null;
    
    const shuffled = parks.sort(() => 0.5 - Math.random());
    return [shuffled[0], shuffled[1]];
  },

  // Record a vote and update ELO ratings
  recordVote: (winnerId: number, loserId: number) => {
    const getpark = db.prepare('SELECT * FROM parks WHERE id = ?');
    const winner = getpark.get(winnerId) as Park;
    const loser = getpark.get(loserId) as Park;
    
    if (!winner || !loser) {
      throw new Error('Invalid park IDs');
    }
    
    const { newWinnerRating, newLoserRating } = calculateELO(winner.elo_rating, loser.elo_rating);
    
    const updateWinner = db.prepare(`
      UPDATE parks 
      SET elo_rating = ?, total_votes = total_votes + 1, wins = wins + 1 
      WHERE id = ?
    `);
    
    const updateLoser = db.prepare(`
      UPDATE parks 
      SET elo_rating = ?, total_votes = total_votes + 1, losses = losses + 1 
      WHERE id = ?
    `);
    
    const insertVote = db.prepare(`
      INSERT INTO votes (winner_id, loser_id) 
      VALUES (?, ?)
    `);
    
    const transaction = db.transaction(() => {
      updateWinner.run(newWinnerRating, winnerId);
      updateLoser.run(newLoserRating, loserId);
      insertVote.run(winnerId, loserId);
    });
    
    transaction();
  },

  // Get recent votes with park names
  getRecentVotes: (limit: number = 10): Array<Vote & { winner_name: string; loser_name: string }> => {
    const stmt = db.prepare(`
      SELECT v.*, 
             w.name as winner_name, 
             l.name as loser_name
      FROM votes v
      JOIN parks w ON v.winner_id = w.id
      JOIN parks l ON v.loser_id = l.id
      ORDER BY v.timestamp DESC
      LIMIT ?
    `);
    return stmt.all(limit) as Array<Vote & { winner_name: string; loser_name: string }>;
  },

  // Get park by ID
  getParkById: (id: number): Park | null => {
    const stmt = db.prepare('SELECT * FROM parks WHERE id = ?');
    return stmt.get(id) as Park | null;
  }
};

// Initialize parks data on first run
if (typeof window === 'undefined') {
  try {
    const parksJsonPath = path.join(process.cwd(), 'park-images.json');
    console.log('Looking for parks data at:', parksJsonPath);
    if (fs.existsSync(parksJsonPath)) {
      console.log('Parks data file found, loading data...');
      const parksData = JSON.parse(fs.readFileSync(parksJsonPath, 'utf8'));
      console.log(`Loaded ${Object.keys(parksData).length} parks from JSON`);
      dbOperations.initializeParks(parksData);
      console.log('Parks initialized in database');
      
      // Verify parks were added to the database
      const parks = dbOperations.getAllParks();
      console.log(`Database contains ${parks.length} parks`);
    } else {
      console.error('Parks data file not found at:', parksJsonPath);
    }
  } catch (error) {
    console.error('Error initializing parks data:', error);
  }
}

export default db;