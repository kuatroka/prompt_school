import { json } from '@sveltejs/kit';
import { parkQueries } from '$lib/database.js';
import type { RequestHandler } from '@sveltejs/kit';

export const GET: RequestHandler = async () => {
	try {
		const parks = parkQueries.getRandomPair.all();
		
		if (parks.length < 2) {
			return json({ error: 'Not enough parks available' }, { status: 400 });
		}
		
		return json(parks);
	} catch (error) {
		console.error('Error fetching random parks:', error);
		return json({ error: 'Internal server error' }, { status: 500 });
	}
};