import { json } from '@sveltejs/kit';
import { voteQueries } from '$lib/database.js';
import type { RequestHandler } from '@sveltejs/kit';

export const GET: RequestHandler = async () => {
	try {
		const recentVotes = voteQueries.getRecent.all();
		return json(recentVotes);
	} catch (error) {
		console.error('Error fetching recent votes:', error);
		return json({ error: 'Internal server error' }, { status: 500 });
	}
};