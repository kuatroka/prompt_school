<script lang="ts">
	import { onMount } from 'svelte';

	interface Park {
		id: number;
		name: string;
		image_url: string;
		elo_rating: number;
		total_votes: number;
	}

	interface Vote {
		winner_name: string;
		loser_name: string;
		timestamp: string;
	}

	let currentPair: Park[] = [];
	let rankings: Park[] = [];
	let recentVotes: Vote[] = [];
	let loading = false;
	let votingComplete = false;

	async function fetchRandomPair() {
		loading = true;
		try {
			const response = await fetch('/api/parks/random');
			const data = await response.json();
			if (response.ok) {
				currentPair = data;
				votingComplete = false;
			} else {
				console.error('Error fetching parks:', data.error);
			}
		} catch (error) {
			console.error('Error fetching parks:', error);
		} finally {
			loading = false;
		}
	}

	async function vote(winnerId: number, loserId: number) {
		loading = true;
		try {
			const response = await fetch('/api/vote', {
				method: 'POST',
				headers: {
					'Content-Type': 'application/json'
				},
				body: JSON.stringify({ winnerId, loserId })
			});
			const data = await response.json();
			if (response.ok) {
				votingComplete = true;
				await fetchRankings();
				await fetchRecentVotes();
				// Auto-load next pair after 2 seconds
				setTimeout(() => {
					fetchRandomPair();
				}, 2000);
			} else {
				console.error('Error recording vote:', data.error);
			}
		} catch (error) {
			console.error('Error recording vote:', error);
		} finally {
			loading = false;
		}
	}

	async function fetchRankings() {
		try {
			const response = await fetch('/api/rankings');
			const data = await response.json();
			if (response.ok) {
				rankings = data;
			}
		} catch (error) {
			console.error('Error fetching rankings:', error);
		}
	}

	async function fetchRecentVotes() {
		try {
			const response = await fetch('/api/recent-votes');
			const data = await response.json();
			if (response.ok) {
				recentVotes = data;
			}
		} catch (error) {
			console.error('Error fetching recent votes:', error);
		}
	}

	onMount(() => {
		fetchRandomPair();
		fetchRankings();
		fetchRecentVotes();
	});
</script>

<div class="min-h-screen bg-gradient-to-br from-green-50 to-blue-50 p-4">
	<div class="max-w-7xl mx-auto">
		<header class="text-center mb-8">
			<h1 class="text-4xl font-bold text-gray-800 mb-2">🏞️ National Parks Voting</h1>
			<p class="text-lg text-gray-600">Vote for your favorite national park and see the ELO rankings!</p>
		</header>

		<div class="grid lg:grid-cols-3 gap-8">
			<!-- Voting Section -->
			<div class="lg:col-span-2">
				<div class="bg-white rounded-xl shadow-lg p-6">
					<h2 class="text-2xl font-semibold text-center mb-6">Which park do you prefer?</h2>
					
					{#if loading && currentPair.length === 0}
						<div class="text-center py-12">
							<div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500 mx-auto"></div>
							<p class="mt-4 text-gray-600">Loading parks...</p>
						</div>
					{:else if currentPair.length === 2}
						<div class="grid md:grid-cols-2 gap-6">
							{#each currentPair as park}
								<button
									class="group relative overflow-hidden rounded-lg bg-white border-2 border-gray-200 hover:border-blue-400 transition-all duration-300 transform hover:scale-105 disabled:opacity-50 disabled:cursor-not-allowed"
									disabled={loading || votingComplete}
									on:click={() => {
									const otherPark = currentPair.find(p => p.id !== park.id);
									if (otherPark) vote(park.id, otherPark.id);
								}}
								>
									<div class="aspect-video overflow-hidden">
										<img
											src={park.image_url}
											alt={park.name}
											class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-300"
										/>
									</div>
									<div class="p-4">
										<h3 class="font-semibold text-lg text-gray-800 mb-2">{park.name}</h3>
										<div class="flex justify-between items-center text-sm text-gray-600">
											<span>ELO: {park.elo_rating}</span>
											<span>Votes: {park.total_votes}</span>
										</div>
									</div>
								</button>
							{/each}
						</div>
						
						{#if votingComplete}
							<div class="text-center mt-6 p-4 bg-green-100 rounded-lg">
								<p class="text-green-800 font-semibold">✅ Vote recorded! Loading next matchup...</p>
							</div>
						{/if}
					{/if}
					
					<div class="mt-6 text-center">
						<button
							class="px-6 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors disabled:opacity-50"
							disabled={loading}
							on:click={fetchRandomPair}
						>
							{loading ? 'Loading...' : 'Skip / New Matchup'}
						</button>
					</div>
				</div>
			</div>

			<!-- Sidebar -->
			<div class="space-y-6">
				<!-- Rankings -->
				<div class="bg-white rounded-xl shadow-lg p-6">
					<h3 class="text-xl font-semibold mb-4 text-gray-800">🏆 Top Rankings</h3>
					<div class="space-y-3 max-h-96 overflow-y-auto">
						{#each rankings.slice(0, 10) as park, index}
							<div class="flex items-center space-x-3 p-2 rounded-lg {index < 3 ? 'bg-yellow-50' : 'bg-gray-50'}">
								<span class="font-bold text-lg {index === 0 ? 'text-yellow-500' : index === 1 ? 'text-gray-400' : index === 2 ? 'text-orange-400' : 'text-gray-600'}">
									#{index + 1}
								</span>
								<img src={park.image_url} alt={park.name} class="w-12 h-12 object-cover rounded" />
								<div class="flex-1 min-w-0">
									<p class="font-medium text-sm text-gray-800 truncate">{park.name}</p>
									<p class="text-xs text-gray-600">ELO: {park.elo_rating} | Votes: {park.total_votes}</p>
								</div>
							</div>
						{/each}
					</div>
				</div>

				<!-- Recent Votes -->
				<div class="bg-white rounded-xl shadow-lg p-6">
					<h3 class="text-xl font-semibold mb-4 text-gray-800">📊 Recent Votes</h3>
					<div class="space-y-2 max-h-64 overflow-y-auto">
						{#each recentVotes as vote}
							<div class="text-sm p-2 bg-gray-50 rounded">
								<p class="font-medium text-green-600">{vote.winner_name}</p>
								<p class="text-gray-500">beat</p>
								<p class="font-medium text-red-600">{vote.loser_name}</p>
								<p class="text-xs text-gray-400 mt-1">{new Date(vote.timestamp).toLocaleString()}</p>
							</div>
						{/each}
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
