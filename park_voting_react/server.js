import { createServer } from 'http';
import { readFileSync } from 'fs';
import { join } from 'path';
import { parse } from 'url';
import { 
  getRandomParkPair, 
  submitVote, 
  getRankings, 
  getRecentVotes,
  getParkById 
} from './src/database.js';

const PORT = process.env.PORT || 3001;

// MIME types for static files
const mimeTypes = {
  '.html': 'text/html',
  '.js': 'application/javascript',
  '.jsx': 'application/javascript',
  '.css': 'text/css',
  '.json': 'application/json',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.gif': 'image/gif',
  '.svg': 'image/svg+xml',
};

function getContentType(filePath) {
  const ext = filePath.substring(filePath.lastIndexOf('.'));
  return mimeTypes[ext] || 'text/plain';
}

// Helper function to read request body
function getRequestBody(req) {
  return new Promise((resolve, reject) => {
    let body = '';
    req.on('data', chunk => {
      body += chunk.toString();
    });
    req.on('end', () => {
      resolve(body);
    });
    req.on('error', reject);
  });
}

const server = createServer(async (req, res) => {
  const parsedUrl = parse(req.url, true);
  const pathname = parsedUrl.pathname;
  const query = parsedUrl.query;

  // API Routes
  if (pathname.startsWith('/api/')) {
    try {
      // CORS headers
      res.setHeader('Access-Control-Allow-Origin', '*');
      res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
      res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
      res.setHeader('Content-Type', 'application/json');

      if (req.method === 'OPTIONS') {
        res.writeHead(200);
        res.end();
        return;
      }

      if (pathname === '/api/parks/random-pair' && req.method === 'GET') {
        const pair = getRandomParkPair();
        res.writeHead(200);
        res.end(JSON.stringify(pair));
        return;
      }

      if (pathname === '/api/votes' && req.method === 'POST') {
        const body = await getRequestBody(req);
        const { winnerId, loserId } = JSON.parse(body);
        
        if (!winnerId || !loserId) {
          res.writeHead(400);
          res.end(JSON.stringify({ error: 'Missing winnerId or loserId' }));
          return;
        }

        const result = submitVote(parseInt(winnerId), parseInt(loserId));
        res.writeHead(200);
        res.end(JSON.stringify(result));
        return;
      }

      if (pathname === '/api/rankings' && req.method === 'GET') {
        const limit = parseInt(query.limit) || 20;
        const rankings = getRankings(limit);
        res.writeHead(200);
        res.end(JSON.stringify(rankings));
        return;
      }

      if (pathname === '/api/recent-votes' && req.method === 'GET') {
        const limit = parseInt(query.limit) || 10;
        const recentVotes = getRecentVotes(limit);
        res.writeHead(200);
        res.end(JSON.stringify(recentVotes));
        return;
      }

      if (pathname.startsWith('/api/parks/') && req.method === 'GET') {
        const id = pathname.split('/').pop();
        const park = getParkById(parseInt(id));
        if (!park) {
          res.writeHead(404);
          res.end(JSON.stringify({ error: 'Park not found' }));
          return;
        }
        res.writeHead(200);
        res.end(JSON.stringify(park));
        return;
      }

      res.writeHead(404);
      res.end(JSON.stringify({ error: 'API endpoint not found' }));
      return;
    } catch (error) {
      console.error('API Error:', error);
      res.writeHead(500);
      res.setHeader('Content-Type', 'application/json');
      res.end(JSON.stringify({ error: 'Internal server error' }));
      return;
    }
  }

  // Static file serving
  try {
    let filePath;
    
    if (pathname === '/' || pathname === '/index.html') {
      filePath = join(process.cwd(), 'src', 'index.html');
    } else if (pathname.startsWith('/src/')) {
      filePath = join(process.cwd(), pathname);
    } else {
      // Try to serve from src directory
      filePath = join(process.cwd(), 'src', pathname);
    }

    const file = readFileSync(filePath);
    const contentType = getContentType(filePath);
    
    res.setHeader('Content-Type', contentType);
    res.writeHead(200);
    res.end(file);
  } catch (error) {
    // If file not found, serve index.html for SPA routing
    if (pathname !== '/favicon.ico') {
      try {
        const indexFile = readFileSync(join(process.cwd(), 'src', 'index.html'));
        res.setHeader('Content-Type', 'text/html');
        res.writeHead(200);
        res.end(indexFile);
      } catch (indexError) {
        console.error('Error serving index.html:', indexError);
        res.writeHead(404);
        res.end('Not Found');
      }
    } else {
      res.writeHead(404);
      res.end('Not Found');
    }
  }
});

server.listen(PORT, () => {
  console.log(`🏞️  National Parks Voting App running at http://localhost:${PORT}`);
  console.log('📊 Database initialized with park data');
  console.log('🗳️  Ready for voting!');
});