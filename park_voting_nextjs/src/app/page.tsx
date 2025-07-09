'use client';

import { useState, useEffect } from 'react';
import Image from 'next/image';

interface Park {
  id: number;
  name: string;
  image_url: string;
  elo_rating: number;
  total_votes: number;
  wins: number;
  losses: number;
}

interface Vote {
  id: number;
  winner_id: number;
  loser_id: number;
  timestamp: string;
  winner_name: string;
  loser_name: string;
}

export default function Home() {
  const [currentPair, setCurrentPair] = useState<[Park, Park] | null>(null);
  const [rankings, setRankings] = useState<Park[]>([]);
  const [recentVotes, setRecentVotes] = useState<Vote[]>([]);
  const [loading, setLoading] = useState(false);
  const [votingDisabled, setVotingDisabled] = useState(false);

  // Fetch initial data
  useEffect(() => {
    fetchNewPair();
    fetchRankings();
    fetchRecentVotes();
  }, []);

  const fetchNewPair = async () => {
    try {
      const response = await fetch('/api/parks/pair');
      if (response.ok) {
        const pair = await response.json();
        setCurrentPair(pair);
      }
    } catch (error) {
      console.error('Error fetching park pair:', error);
    }
  };

  const fetchRankings = async () => {
    try {
      const response = await fetch('/api/parks');
      if (response.ok) {
        const parks = await response.json();
        setRankings(parks);
      }
    } catch (error) {
      console.error('Error fetching rankings:', error);
    }
  };

  const fetchRecentVotes = async () => {
    try {
      const response = await fetch('/api/votes?limit=5');
      if (response.ok) {
        const votes = await response.json();
        setRecentVotes(votes);
      }
    } catch (error) {
      console.error('Error fetching recent votes:', error);
    }
  };

  const handleVote = async (winnerId: number, loserId: number) => {
    if (votingDisabled) return;
    
    setVotingDisabled(true);
    setLoading(true);
    
    try {
      const response = await fetch('/api/vote', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ winnerId, loserId }),
      });
      
      if (response.ok) {
        // Refresh data after successful vote
        await Promise.all([
          fetchNewPair(),
          fetchRankings(),
          fetchRecentVotes()
        ]);
      }
    } catch (error) {
      console.error('Error recording vote:', error);
    } finally {
      setLoading(false);
      setTimeout(() => setVotingDisabled(false), 500); // Prevent rapid clicking
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-green-50 to-blue-50 p-4">
      <div className="max-w-7xl mx-auto">
        <header className="text-center mb-8">
          <h1 className="text-4xl font-bold text-gray-800 mb-2">
            🏞️ National Parks Voting
          </h1>
          <p className="text-lg text-gray-600">
            Vote for your favorite national park and see the ELO rankings!
          </p>
        </header>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Voting Section */}
          <div className="lg:col-span-2">
            <div className="bg-white rounded-xl shadow-lg p-6">
              <h2 className="text-2xl font-semibold text-gray-800 mb-6 text-center">
                Which park do you prefer?
              </h2>
              
              {currentPair && (
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  {currentPair.map((park) => (
                    <button
                      key={park.id}
                      onClick={() => handleVote(park.id, currentPair.find(p => p.id !== park.id)!.id)}
                      disabled={votingDisabled}
                      className="group relative overflow-hidden rounded-lg bg-gray-100 hover:bg-gray-50 transition-all duration-300 transform hover:scale-105 disabled:opacity-50 disabled:cursor-not-allowed"
                      data-testid="park-card"
                    >
                      <div className="aspect-[4/3] relative">
                        <Image
                          src={park.image_url}
                          alt={park.name}
                          fill
                          className="object-cover"
                          sizes="(max-width: 768px) 100vw, 50vw"
                        />
                        <div className="absolute inset-0 bg-black opacity-0 group-hover:opacity-20 transition-all duration-300" />
                      </div>
                      <div className="p-4">
                        <h3 className="text-lg font-semibold text-gray-800 group-hover:text-blue-600 transition-colors">
                          {park.name}
                        </h3>
                        <div className="flex justify-between text-sm text-gray-500 mt-2">
                          <span>ELO: {park.elo_rating}</span>
                          <span>Votes: {park.total_votes}</span>
                        </div>
                      </div>
                    </button>
                  ))}
                </div>
              )}
              
              {loading && (
                <div className="text-center mt-4">
                  <div className="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
                  <p className="text-gray-600 mt-2">Recording your vote...</p>
                </div>
              )}
            </div>
          </div>

          {/* Sidebar */}
          <div className="space-y-6">
            {/* Rankings */}
            <div className="bg-white rounded-xl shadow-lg p-6">
              <h2 className="text-xl font-semibold text-gray-800 mb-4">
                🏆 Top Rankings
              </h2>
              <div className="space-y-3">
                {rankings.slice(0, 10).map((park, index) => (
                  <div key={park.id} className="flex items-center space-x-3" data-testid="ranking-item">
                    <div className={`w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold ${
                      index === 0 ? 'bg-yellow-100 text-yellow-800' :
                      index === 1 ? 'bg-gray-100 text-gray-800' :
                      index === 2 ? 'bg-orange-100 text-orange-800' :
                      'bg-blue-100 text-blue-800'
                    }`}>
                      {index + 1}
                    </div>
                    <div className="flex-1 min-w-0">
                      <p className="text-sm font-medium text-gray-800 truncate">
                        {park.name}
                      </p>
                      <p className="text-xs text-gray-500">
                        ELO: {park.elo_rating} • {park.wins}W-{park.losses}L
                      </p>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* Recent Votes */}
            <div className="bg-white rounded-xl shadow-lg p-6">
              <h2 className="text-xl font-semibold text-gray-800 mb-4">
                📊 Recent Votes
              </h2>
              <div className="space-y-3">
                {recentVotes.map((vote) => (
                  <div key={vote.id} className="text-sm">
                    <p className="text-gray-800">
                      <span className="font-medium text-green-600">{vote.winner_name}</span>
                      <span className="text-gray-500"> beat </span>
                      <span className="font-medium text-red-600">{vote.loser_name}</span>
                    </p>
                    <p className="text-xs text-gray-400">
                      {new Date(vote.timestamp).toLocaleTimeString()}
                    </p>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}