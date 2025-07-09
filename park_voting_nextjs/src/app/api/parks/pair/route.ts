import { NextResponse } from 'next/server';
import { dbOperations } from '@/lib/database';

export async function GET() {
  try {
    const pair = dbOperations.getRandomPair();
    
    if (!pair) {
      return NextResponse.json(
        { error: 'Not enough parks available' },
        { status: 400 }
      );
    }
    
    return NextResponse.json(pair);
  } catch (error) {
    console.error('Error fetching park pair:', error);
    return NextResponse.json(
      { error: 'Failed to fetch park pair' },
      { status: 500 }
    );
  }
}