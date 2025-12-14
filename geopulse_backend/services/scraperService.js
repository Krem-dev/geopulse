const axios = require('axios');
const cheerio = require('cheerio');
const db = require('../config/database');
const newsSources = require('../config/newsSources');

class ScraperService {
  constructor() {
    this.allSources = newsSources;
  }

  getSourcesForCountry(country) {
    return this.allSources[country] || [];
  }

  async scrapeSource(source) {
    try {
      console.log(`🔍 Scraping ${source.name}...`);

      const { data } = await axios.get(source.url, {
        headers: {
          'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
        timeout: 10000,
      });

      const $ = cheerio.load(data);
      const articles = [];

      $(source.selector).each((i, el) => {
        const title = $(el).text().trim();
        const href = $(el).attr('href');

        if (title && title.length > 10) {
          const url = href?.startsWith('http')
            ? href
            : new URL(href || '', source.url).href;

          articles.push({
            title,
            url,
            source: source.name,
            city: source.city,
            country: source.country,
            publishedAt: new Date(),
          });
        }
      });

      console.log(`✅ Scraped ${articles.length} articles from ${source.name}`);
      return articles;
    } catch (error) {
      console.error(`❌ Error scraping ${source.name}:`, error.message);
      return [];
    }
  }

  async scrapeForCountries(countries) {
    const allArticles = [];

    for (const country of countries) {
      const sources = this.getSourcesForCountry(country);
      
      if (sources.length === 0) {
        console.log(`⚠️  No news sources configured for ${country}`);
        continue;
      }

      console.log(`📰 Scraping ${sources.length} sources for ${country}...`);

      for (const sourceConfig of sources) {
        const source = {
          ...sourceConfig,
          city: this.getMainCity(country),
          country: country,
        };
        
        const articles = await this.scrapeSource(source);
        allArticles.push(...articles);
      }
    }

    await this.saveScrapedArticles(allArticles);
    return allArticles;
  }

  getMainCity(country) {
    const mainCities = {
      'Ghana': 'Accra',
      'Nigeria': 'Lagos',
      'USA': 'New York',
      'UK': 'London',
      'Canada': 'Toronto',
      'Kenya': 'Nairobi',
      'South Africa': 'Johannesburg',
    };
    return mainCities[country] || 'Unknown';
  }

  async saveScrapedArticles(articles) {
    const connection = await db.getConnection();
    try {
      console.log(`📝 Saving ${articles.length} scraped articles to database...`);
      
      let savedCount = 0;
      let duplicateCount = 0;
      let errorCount = 0;

      for (const article of articles) {
        try {
          const publishedAt = new Date().toISOString().slice(0, 19).replace('T', ' ');
          const coords = this.getCityCoordinates(article.city, article.country);

          const query = `
            INSERT INTO articles 
            (title, source, url, city, country, latitude, longitude, published_at, created_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())
            ON DUPLICATE KEY UPDATE updated_at = NOW()
          `;

          const result = await connection.execute(query, [
            article.title,
            article.source,
            article.url,
            article.city,
            article.country,
            coords.lat,
            coords.lng,
            publishedAt,
          ]);

          if (result[0].affectedRows > 0) {
            savedCount++;
          } else {
            duplicateCount++;
          }
        } catch (error) {
          if (error.message.includes('Duplicate entry')) {
            duplicateCount++;
          } else {
            errorCount++;
            console.error('❌ Error saving scraped article:', error.message);
          }
        }
      }

      console.log(`✅ Scraped articles - Saved: ${savedCount}, Duplicates: ${duplicateCount}, Errors: ${errorCount}`);
    } finally {
      connection.release();
    }
  }

  getCityCoordinates(city, country) {
    const cityCoords = {
      'London-UK': { lat: 51.5074, lng: -0.1278 },
      'New York-USA': { lat: 40.7128, lng: -74.006 },
      'Global-Global': { lat: 0, lng: 0 },
    };
    return cityCoords[`${city}-${country}`] || { lat: 0, lng: 0 };
  }
}

module.exports = new ScraperService();
