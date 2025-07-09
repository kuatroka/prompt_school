const { useState, useEffect } = React;
const { createRoot } = ReactDOM;

// API functions
const API_BASE = window.location.origin;

async function getRandomParkPair() {
  const response = await fetch(`${API_BASE}/api/parks/random-pair`);
  return response.json();
}

async function submitVote(winnerId, loserId) {
  const response = await fetch(`${API_BASE}/api/votes`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ winnerId, loserId })
  });
  return response.json();
}

async function getRankings(limit = 20) {
  const response = await fetch(`${API_BASE}/api/rankings?limit=${limit}`);
  return response.json();
}

async function getRecentVotes(limit = 10) {
  const response = await fetch(`${API_BASE}/api/recent-votes?limit=${limit}`);
  return response.json();
}

// Voting Component
function VotingSection({ onVote }) {
  const [parkPair, setParkPair] = useState([]);
  const [loading, setLoading] = useState(false);

  const loadNewPair = async () => {
    try {
      const pair = await getRandomParkPair();
      setParkPair(pair);
    } catch (error) {
      console.error('Error loading park pair:', error);
    }
  };

  useEffect(() => {
    loadNewPair();
  }, []);

  const handleVote = async (winnerId, loserId) => {
    setLoading(true);
    try {
      await submitVote(winnerId, loserId);
      onVote(); // Refresh rankings and recent votes
      loadNewPair(); // Load new pair
    } catch (error) {
      console.error('Error submitting vote:', error);
    } finally {
      setLoading(false);
    }
  };

  if (parkPair.length !== 2) {
    return (
      <div className="text-center py-8">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-green-600 mx-auto"></div>
        <p className="mt-4 text-gray-600">Loading parks...</p>
      </div>
    );
  }

  return (
    <div className="bg-white rounded-lg shadow-lg p-6 mb-8">
      <h2 className="text-2xl font-bold text-center mb-6 text-gray-800">
        Which park do you prefer?
      </h2>
      <div className="grid md:grid-cols-2 gap-6">
        {parkPair.map((park) => (
          <div key={park.id} className="text-center">
            <button
              onClick={() => handleVote(park.id, parkPair.find(p => p.id !== park.id).id)}
              disabled={loading}
              className="group w-full transition-all duration-200 hover:scale-105 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              <div className="bg-gray-100 rounded-lg overflow-hidden shadow-md group-hover:shadow-xl transition-shadow">
                <img
                  src={park.image_url}
                  alt={park.name}
                  className="w-full h-64 object-cover"
                  loading="lazy"
                />
                <div className="p-4">
                  <h3 className="text-lg font-semibold text-gray-800 group-hover:text-green-600 transition-colors">
                    {park.name}
                  </h3>
                  <p className="text-sm text-gray-600 mt-1">
                    ELO: {park.elo_rating} | Votes: {park.total_votes}
                  </p>
                </div>
              </div>
            </button>
          </div>
        ))}
      </div>
      {loading && (
        <div className="text-center mt-4">
          <div className="animate-spin rounded-full h-6 w-6 border-b-2 border-green-600 mx-auto"></div>
          <p className="text-sm text-gray-600 mt-2">Submitting vote...</p>
        </div>
      )}
    </div>
  );
}

// Rankings Component
function Rankings({ rankings }) {
  return (
    <div className="bg-white rounded-lg shadow-lg p-6 mb-8">
      <h2 className="text-2xl font-bold mb-6 text-gray-800">🏆 Top Rankings</h2>
      <div className="space-y-3">
        {rankings.map((park) => (
          <div key={park.name} className="flex items-center space-x-4 p-3 bg-gray-50 rounded-lg">
            <div className="flex-shrink-0">
              <span className={`inline-flex items-center justify-center w-8 h-8 rounded-full text-sm font-bold ${
                park.rank === 1 ? 'bg-yellow-400 text-yellow-900' :
                park.rank === 2 ? 'bg-gray-300 text-gray-800' :
                park.rank === 3 ? 'bg-orange-400 text-orange-900' :
                'bg-blue-100 text-blue-800'
              }`}>
                {park.rank}
              </span>
            </div>
            <img
              src={park.image_url}
              alt={park.name}
              className="w-16 h-16 object-cover rounded-lg"
              loading="lazy"
            />
            <div className="flex-1">
              <h3 className="font-semibold text-gray-800">{park.name}</h3>
              <p className="text-sm text-gray-600">
                ELO: {park.elo_rating} | Votes: {park.total_votes}
              </p>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

// Recent Votes Component
function RecentVotes({ recentVotes }) {
  return (
    <div className="bg-white rounded-lg shadow-lg p-6">
      <h2 className="text-2xl font-bold mb-6 text-gray-800">📊 Recent Votes</h2>
      <div className="space-y-4">
        {recentVotes.map((vote, index) => (
          <div key={index} className="border-l-4 border-green-500 pl-4 py-2">
            <div className="flex items-center space-x-2 text-sm text-gray-600 mb-2">
              <span>🕒</span>
              <span>{new Date(vote.timestamp).toLocaleString()}</span>
            </div>
            <div className="flex items-center space-x-4">
              <div className="flex items-center space-x-2">
                <img
                  src={vote.winner_image}
                  alt={vote.winner_name}
                  className="w-12 h-12 object-cover rounded"
                  loading="lazy"
                />
                <div>
                  <p className="font-semibold text-green-600">✓ {vote.winner_name}</p>
                  <p className="text-xs text-gray-500">Winner</p>
                </div>
              </div>
              <span className="text-gray-400">vs</span>
              <div className="flex items-center space-x-2">
                <img
                  src={vote.loser_image}
                  alt={vote.loser_name}
                  className="w-12 h-12 object-cover rounded opacity-60"
                  loading="lazy"
                />
                <div>
                  <p className="font-semibold text-gray-600">{vote.loser_name}</p>
                  <p className="text-xs text-gray-500">Runner-up</p>
                </div>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

// Main App Component
function App() {
  const [rankings, setRankings] = useState([]);
  const [recentVotes, setRecentVotes] = useState([]);
  const [activeTab, setActiveTab] = useState('vote');

  const refreshData = async () => {
    try {
      const newRankings = await getRankings(20);
      const newRecentVotes = await getRecentVotes(10);
      setRankings(newRankings);
      setRecentVotes(newRecentVotes);
    } catch (error) {
      console.error('Error refreshing data:', error);
    }
  };

  useEffect(() => {
    refreshData();
  }, []);

  return (
    <div className="min-h-screen bg-gradient-to-br from-green-50 to-blue-50">
      <div className="container mx-auto px-4 py-8">
        {/* Header */}
        <header className="text-center mb-8">
          <h1 className="text-4xl font-bold text-gray-800 mb-2">
            🏞️ National Parks Voting
          </h1>
          <p className="text-gray-600 text-lg">
            Vote for your favorite national parks and see how they rank!
          </p>
        </header>

        {/* Navigation Tabs */}
        <div className="flex justify-center mb-8">
          <div className="bg-white rounded-lg shadow-md p-1">
            <button
              onClick={() => setActiveTab('vote')}
              className={`px-6 py-2 rounded-md font-medium transition-colors ${
                activeTab === 'vote'
                  ? 'bg-green-600 text-white'
                  : 'text-gray-600 hover:text-green-600'
              }`}
            >
              Vote
            </button>
            <button
              onClick={() => setActiveTab('rankings')}
              className={`px-6 py-2 rounded-md font-medium transition-colors ${
                activeTab === 'rankings'
                  ? 'bg-green-600 text-white'
                  : 'text-gray-600 hover:text-green-600'
              }`}
            >
              Rankings
            </button>
            <button
              onClick={() => setActiveTab('recent')}
              className={`px-6 py-2 rounded-md font-medium transition-colors ${
                activeTab === 'recent'
                  ? 'bg-green-600 text-white'
                  : 'text-gray-600 hover:text-green-600'
              }`}
            >
              Recent Votes
            </button>
          </div>
        </div>

        {/* Content */}
        <div className="max-w-4xl mx-auto">
          {activeTab === 'vote' && <VotingSection onVote={refreshData} />}
          {activeTab === 'rankings' && <Rankings rankings={rankings} />}
          {activeTab === 'recent' && <RecentVotes recentVotes={recentVotes} />}
        </div>

        {/* Footer */}
        <footer className="text-center mt-12 text-gray-500">
          <p>Built with React, Bun, and SQLite | ELO Rating System</p>
        </footer>
      </div>
    </div>
  );
}

// Render the app
const container = document.getElementById('root');
const root = createRoot(container);
root.render(<App />);