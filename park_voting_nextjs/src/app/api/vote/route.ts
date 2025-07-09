import { NextRequest, NextResponse } from 'next/server';
import { dbOperations } from '@/lib/database';

export async function POST(request: NextRequest) {
  try {
    const { winnerId, loserId } = await request.json();
    
    if (!winnerId || !loserId) {
      return NextResponse.json(
        { error: 'Winner ID and Loser ID are required' },
        { status: 400 }
      );
    }
    
    if (winnerId === loserId) {
      return NextResponse.json(
        { error: 'Winner and loser cannot be the same park' },
        { status: 400 }
      );
    }
    
    dbOperations.recordVote(winnerId, loserId);
    
    return NextResponse.json({ success: true });
  } catch (error) {
    console.error('Error recording vote:', error);
    return NextResponse.json(
      { error: 'Failed to record vote' },
      { status: 500 }
    );
  }
}