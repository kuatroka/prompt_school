import { json } from '@sveltejs/kit';
import { parkQueries } from '$lib/database.js';
import type { RequestHandler } from '@sveltejs/kit';

export const GET: RequestHandler = async () => {
	try {
		const parks = parkQueries.getAll.all();
		return json(parks);
	} catch (error) {
		console.error('Error fetching rankings:', error);
		return json({ error: 'Internal server error' }, { status: 500 });
	}
};