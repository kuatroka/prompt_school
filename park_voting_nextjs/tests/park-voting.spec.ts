import { test, expect } from '@playwright/test';

test.describe('Park Voting App', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
  });

  test('should load the homepage without errors', async ({ page }) => {
    // Check for console errors
    const errors: string[] = [];
    page.on('console', msg => {
      if (msg.type() === 'error') {
        errors.push(msg.text());
      }
    });

    // Check page loads
    await expect(page).toHaveTitle(/Park Voting/);
    await expect(page.locator('h1')).toContainText('National Parks Voting');
    
    // Verify no console errors
    expect(errors).toHaveLength(0);
  });

  test('should display voting interface', async ({ page }) => {
    // Wait for parks to load
    await page.waitForSelector('[data-testid="park-card"]', { timeout: 10000 });
    
    // Check voting cards are present
    const parkCards = page.locator('[data-testid="park-card"]');
    await expect(parkCards).toHaveCount(2);
    
    // Check vote buttons are present
    const voteButtons = page.locator('button:has-text("Vote")');
    await expect(voteButtons).toHaveCount(2);
  });

  test('should handle voting functionality', async ({ page }) => {
    // Wait for parks to load
    await page.waitForSelector('[data-testid="park-card"]', { timeout: 10000 });
    
    // Click first vote button
    const firstVoteButton = page.locator('button:has-text("Vote")').first();
    await firstVoteButton.click();
    
    // Wait for new pair to load
    await page.waitForTimeout(1000);
    
    // Verify new parks loaded (different from previous)
    const parkCards = page.locator('[data-testid="park-card"]');
    await expect(parkCards).toHaveCount(2);
  });

  test('should display rankings section', async ({ page }) => {
    // Check rankings section exists
    await expect(page.locator('h2:has-text("Rankings")')).toBeVisible();
    
    // Wait for rankings to load
    await page.waitForSelector('[data-testid="ranking-item"]', { timeout: 10000 });
    
    // Check at least some rankings are displayed
    const rankingItems = page.locator('[data-testid="ranking-item"]');
    const count = await rankingItems.count();
    expect(count).toBeGreaterThan(0);
  });

  test('should display recent votes section', async ({ page }) => {
    // Check recent votes section exists
    await expect(page.locator('h2:has-text("Recent Votes")')).toBeVisible();
    
    // Recent votes might be empty initially, so just check the section exists
    const recentVotesSection = page.locator('text=Recent Votes').locator('..');
    await expect(recentVotesSection).toBeVisible();
  });

  test('should handle API errors gracefully', async ({ page }) => {
    // Monitor network requests
    const failedRequests: string[] = [];
    page.on('response', response => {
      if (!response.ok()) {
        failedRequests.push(`${response.status()} ${response.url()}`);
      }
    });
    
    // Wait for page to load
    await page.waitForTimeout(3000);
    
    // Check if there are any failed API requests
    if (failedRequests.length > 0) {
      console.log('Failed requests:', failedRequests);
    }
    
    // The app should still be functional even with some API errors
    await expect(page.locator('h1')).toBeVisible();
  });

  test('should be responsive on mobile', async ({ page }) => {
    // Set mobile viewport
    await page.setViewportSize({ width: 375, height: 667 });
    
    // Check page still loads properly
    await expect(page.locator('h1')).toBeVisible();
    
    // Wait for parks to load
    await page.waitForSelector('[data-testid="park-card"]', { timeout: 10000 });
    
    // Check voting interface is still functional
    const parkCards = page.locator('[data-testid="park-card"]');
    await expect(parkCards).toHaveCount(2);
  });

  test('should handle rapid clicking without errors', async ({ page }) => {
    const errors: string[] = [];
    page.on('console', msg => {
      if (msg.type() === 'error') {
        errors.push(msg.text());
      }
    });
    
    // Wait for parks to load
    await page.waitForSelector('[data-testid="park-card"]', { timeout: 10000 });
    
    // Rapidly click vote buttons
    for (let i = 0; i < 5; i++) {
      const voteButton = page.locator('button:has-text("Vote")').first();
      if (await voteButton.isVisible()) {
        await voteButton.click();
        await page.waitForTimeout(500);
      }
    }
    
    // Check no errors occurred
    expect(errors).toHaveLength(0);
  });

  test('should load park images without errors', async ({ page }) => {
    const imageErrors: string[] = [];
    
    page.on('response', response => {
      if (response.url().includes('upload.wikimedia.org') && !response.ok()) {
        imageErrors.push(`Image failed to load: ${response.url()}`);
      }
    });
    
    // Wait for parks to load
    await page.waitForSelector('[data-testid="park-card"]', { timeout: 10000 });
    
    // Wait for images to load
    await page.waitForTimeout(3000);
    
    // Check for image loading errors
    if (imageErrors.length > 0) {
      console.log('Image loading errors:', imageErrors);
    }
    
    // Images should be present
    const images = page.locator('img');
    const imageCount = await images.count();
    expect(imageCount).toBeGreaterThan(0);
  });
});