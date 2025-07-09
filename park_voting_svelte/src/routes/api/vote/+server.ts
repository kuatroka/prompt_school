import { json } from '@sveltejs/kit';
import { recordVote } from '$lib/database.js';
import type { RequestHandler } from '@sveltejs/kit';

export const POST: RequestHandler = async ({ request }) => {
	try {
		const { winnerId, loserId } = await request.json();
		
		if (!winnerId || !loserId || winnerId === loserId) {
			return json({ error: 'Invalid park IDs' }, { status: 400 });
		}
		
		const result = recordVote(winnerId, loserId);
		
		return json({ success: true, result });
	} catch (error) {
		console.error('Error recording vote:', error);
		return json({ error: 'Internal server error' }, { status: 500 });
	}
};