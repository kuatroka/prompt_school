import { NextResponse } from 'next/server';
import { dbOperations } from '@/lib/database';

export async function GET() {
  try {
    const parks = dbOperations.getAllParks();
    return NextResponse.json(parks);
  } catch (error) {
    console.error('Error fetching parks:', error);
    return NextResponse.json(
      { error: 'Failed to fetch parks' },
      { status: 500 }
    );
  }
}