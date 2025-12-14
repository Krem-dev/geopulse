const scraperService = require('./services/scraperService');
const newsService = require('./services/newsService');
require('dotenv').config();

async function testScraping() {
  console.log('🔍 Testing direct scraping...\n');

  try {
    // Test scraping
    console.log('1. Scraping news sources...');
    const articles = await scraperService.scrapeAllSources();
    console.log(`✅ Scraped ${articles.length} articles\n`);

    // Test NewsAPI
    console.log('2. Fetching from NewsAPI for Ghana...');
    const ghanaNews = await newsService.getLocalNews('Accra', 'Ghana', 'gh');
    console.log(`✅ Fetched ${ghanaNews.length} articles from NewsAPI\n`);

    // Save Ghana news
    console.log('3. Saving Ghana news to database...');
    await newsService.saveArticles(ghanaNews, 'Accra', 'Ghana');
    console.log('✅ Saved Ghana news\n');

    // Get latest news
    console.log('4. Retrieving latest news from database...');
    const latest = await newsService.getLatestNews(10);
    console.log(`✅ Found ${latest.length} articles in database\n`);

    if (latest.length > 0) {
      console.log('Sample articles:');
      latest.slice(0, 3).forEach((article, i) => {
        console.log(`\n${i + 1}. ${article.title}`);
        console.log(`   Source: ${article.source}`);
        console.log(`   City: ${article.city}, ${article.country}`);
        console.log(`   Published: ${article.published_at}`);
      });
    }

    console.log('\n✅ Test completed successfully!');
    process.exit(0);
  } catch (error) {
    console.error('❌ Test failed:', error.message);
    console.error(error.stack);
    process.exit(1);
  }
}

testScraping();
