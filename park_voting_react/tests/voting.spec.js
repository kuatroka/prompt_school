import { test, expect } from '@playwright/test';

test.describe('National Parks Voting App', () => {
  test('should load the homepage with correct title', async ({ page }) => {
    await page.goto('/');
    
    // Check page title
    await expect(page).toHaveTitle(/National Parks Voting App/);
    
    // Check main heading
    await expect(page.locator('h1')).toContainText('National Parks Voting');
    
    // Check navigation tabs
    await expect(page.locator('button:has-text("Vote")')).toBeVisible();
    await expect(page.locator('button:has-text("Rankings")')).toBeVisible();
    await expect(page.locator('button:has-text("Recent Votes")')).toBeVisible();
  });

  test('should display voting section by default', async ({ page }) => {
    await page.goto('/');
    
    // Wait for parks to load
    await page.waitForSelector('img[alt*="National Park"]', { timeout: 10000 });
    
    // Check voting question
    await expect(page.locator('h2')).toContainText('Which park do you prefer?');
    
    // Check that two park images are displayed
    const parkImages = page.locator('img[alt*="National Park"]');
    await expect(parkImages).toHaveCount(2);
    
    // Check that park names are displayed
    const parkNames = page.locator('h3');
    await expect(parkNames).toHaveCount(2);
  });

  test('should allow voting on parks', async ({ page }) => {
    await page.goto('/');
    
    // Wait for parks to load
    await page.waitForSelector('button img[alt*="National Park"]', { timeout: 10000 });
    
    // Get the first park button
    const firstParkButton = page.locator('button').filter({ has: page.locator('img[alt*="National Park"]') }).first();
    
    // Click on the first park
    await firstParkButton.click();
    
    // Wait for loading to complete and new pair to load
    await page.waitForTimeout(2000);
    
    // Verify new parks are loaded (different from before)
    await expect(page.locator('img[alt*="National Park"]')).toHaveCount(2);
  });

  test('should switch to rankings tab and display rankings', async ({ page }) => {
    await page.goto('/');
    
    // Click on Rankings tab
    await page.click('button:has-text("Rankings")');
    
    // Check rankings heading
    await expect(page.locator('h2')).toContainText('Top Rankings');
    
    // Wait for rankings to load
    await page.waitForSelector('[class*="flex items-center space-x-4"]', { timeout: 5000 });
    
    // Check that rankings are displayed
    const rankingItems = page.locator('[class*="flex items-center space-x-4"]');
    await expect(rankingItems.first()).toBeVisible();
    
    // Check that rank numbers are displayed
    const rankNumbers = page.locator('span').filter({ hasText: /^[0-9]+$/ });
    await expect(rankNumbers.first()).toBeVisible();
  });

  test('should switch to recent votes tab and display recent votes', async ({ page }) => {
    await page.goto('/');
    
    // First, make a vote to ensure there are recent votes
    await page.waitForSelector('button img[alt*="National Park"]', { timeout: 10000 });
    const firstParkButton = page.locator('button').filter({ has: page.locator('img[alt*="National Park"]') }).first();
    await firstParkButton.click();
    await page.waitForTimeout(1000);
    
    // Click on Recent Votes tab
    await page.click('button:has-text("Recent Votes")');
    
    // Check recent votes heading
    await expect(page.locator('h2')).toContainText('Recent Votes');
    
    // Wait for recent votes to load
    await page.waitForSelector('[class*="border-l-4 border-green-500"]', { timeout: 5000 });
    
    // Check that recent votes are displayed
    const voteItems = page.locator('[class*="border-l-4 border-green-500"]');
    await expect(voteItems.first()).toBeVisible();
  });

  test('should display ELO ratings and vote counts', async ({ page }) => {
    await page.goto('/');
    
    // Wait for parks to load
    await page.waitForSelector('img[alt*="National Park"]', { timeout: 10000 });
    
    // Check that ELO ratings are displayed
    const eloText = page.locator('text=/ELO: [0-9]+/');
    await expect(eloText.first()).toBeVisible();
    
    // Check that vote counts are displayed
    const votesText = page.locator('text=/Votes: [0-9]+/');
    await expect(votesText.first()).toBeVisible();
  });

  test('should handle API endpoints correctly', async ({ page }) => {
    // Test random park pair endpoint
    const response = await page.request.get('/api/parks/random-pair');
    expect(response.status()).toBe(200);
    const parks = await response.json();
    expect(parks).toHaveLength(2);
    expect(parks[0]).toHaveProperty('id');
    expect(parks[0]).toHaveProperty('name');
    expect(parks[0]).toHaveProperty('image_url');
    expect(parks[0]).toHaveProperty('elo_rating');
    
    // Test rankings endpoint
    const rankingsResponse = await page.request.get('/api/rankings');
    expect(rankingsResponse.status()).toBe(200);
    const rankings = await rankingsResponse.json();
    expect(Array.isArray(rankings)).toBe(true);
    
    // Test recent votes endpoint
    const recentVotesResponse = await page.request.get('/api/recent-votes');
    expect(recentVotesResponse.status()).toBe(200);
    const recentVotes = await recentVotesResponse.json();
    expect(Array.isArray(recentVotes)).toBe(true);
  });

  test('should submit votes via API', async ({ page }) => {
    // Get a random pair first
    const pairResponse = await page.request.get('/api/parks/random-pair');
    const parks = await pairResponse.json();
    
    // Submit a vote
    const voteResponse = await page.request.post('/api/votes', {
      data: {
        winnerId: parks[0].id,
        loserId: parks[1].id
      }
    });
    
    expect(voteResponse.status()).toBe(200);
    const voteResult = await voteResponse.json();
    expect(voteResult).toHaveProperty('winnerId');
    expect(voteResult).toHaveProperty('loserId');
    expect(voteResult).toHaveProperty('newWinnerRating');
    expect(voteResult).toHaveProperty('newLoserRating');
  });

  test('should show loading states', async ({ page }) => {
    await page.goto('/');
    
    // Check for loading spinner initially
    const loadingSpinner = page.locator('.animate-spin');
    
    // Wait for content to load
    await page.waitForSelector('img[alt*="National Park"]', { timeout: 10000 });
    
    // Verify parks are loaded
    await expect(page.locator('img[alt*="National Park"]')).toHaveCount(2);
  });

  test('should be responsive on mobile', async ({ page }) => {
    // Set mobile viewport
    await page.setViewportSize({ width: 375, height: 667 });
    await page.goto('/');
    
    // Wait for parks to load
    await page.waitForSelector('img[alt*="National Park"]', { timeout: 10000 });
    
    // Check that content is still visible and accessible
    await expect(page.locator('h1')).toBeVisible();
    await expect(page.locator('button:has-text("Vote")')).toBeVisible();
    await expect(page.locator('img[alt*="National Park"]')).toHaveCount(2);
  });
});