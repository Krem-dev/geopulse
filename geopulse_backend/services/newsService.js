const axios = require('axios');
const db = require('../config/database');
const scraperService = require('./scraperService');
const userLocationService = require('./userLocationService');

class NewsService {
  constructor() {
    this.newsApiKey = process.env.NEWS_API_KEY;
    this.scrapeInterval = process.env.SCRAPE_INTERVAL || 300000;
    this.newsFetchInterval = process.env.NEWS_FETCH_INTERVAL || 60000;
  }

  async getNewsByCountry(countryCode) {
    try {
      const response = await axios.get(
        'https://newsapi.org/v2/top-headlines',
        {
          params: {
            apiKey: this.newsApiKey,
            country: countryCode,
            sortBy: 'publishedAt',
            pageSize: 50,
          },
          timeout: 10000,
        }
      );
      return response.data.articles || [];
    } catch (error) {
      console.error(`❌ Error fetching news for ${countryCode}:`, error.message);
      return [];
    }
  }

  async searchNewsByCity(city, country) {
    try {
      const response = await axios.get(
        'https://newsapi.org/v2/everything',
        {
          params: {
            apiKey: this.newsApiKey,
            q: `${city} ${country}`,
            sortBy: 'publishedAt',
            language: 'en',
            pageSize: 50,
          },
          timeout: 10000,
        }
      );
      return response.data.articles || [];
    } catch (error) {
      console.error(`❌ Error searching news for ${city}:`, error.message);
      return [];
    }
  }

  async getLocalNews(city, country, countryCode) {
    console.log(`📍 Fetching local news for ${city}, ${country}`);

    const apiNews = await this.getNewsByCountry(countryCode);
    const searchNews = await this.searchNewsByCity(city, country);

    const allNews = [...apiNews, ...searchNews];

    const uniqueNews = Array.from(
      new Map(allNews.map((item) => [item.title, item])).values()
    );

    return uniqueNews.sort(
      (a, b) => new Date(b.publishedAt) - new Date(a.publishedAt)
    );
  }

  async saveArticles(articles, city, country) {
    const connection = await db.getConnection();
    try {
      const coords = this.getCityCoordinates(city, country);
      console.log(`📝 Saving ${articles.length} articles for ${city}, ${country} at coords: ${coords.lat}, ${coords.lng}`);

      let savedCount = 0;
      let duplicateCount = 0;
      let errorCount = 0;

      for (const article of articles) {
        try {
          const publishedAt = article.publishedAt
            ? new Date(article.publishedAt).toISOString().slice(0, 19).replace('T', ' ')
            : new Date().toISOString().slice(0, 19).replace('T', ' ');

          const query = `
            INSERT INTO articles 
            (title, description, image_url, source, url, published_at, city, country, latitude, longitude, created_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())
            ON DUPLICATE KEY UPDATE updated_at = NOW()
          `;

          const result = await connection.execute(query, [
            article.title || '',
            article.description || '',
            article.urlToImage || '',
            article.source?.name || 'Unknown',
            article.url || '',
            publishedAt,
            city,
            country,
            coords.lat,
            coords.lng,
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
            console.error('❌ Error saving article:', error.message);
          }
        }
      }

      console.log(`✅ Saved: ${savedCount}, Duplicates: ${duplicateCount}, Errors: ${errorCount}`);
    } finally {
      connection.release();
    }
  }

  getCityCoordinates(city, country) {
    const cityCoords = {
      'Accra-Ghana': { lat: 5.6037, lng: -0.187 },
      'Lagos-Nigeria': { lat: 6.5244, lng: 3.3792 },
      'New York-USA': { lat: 40.7128, lng: -74.006 },
      'London-UK': { lat: 51.5074, lng: -0.1278 },
      'Toronto-Canada': { lat: 43.6532, lng: -79.3832 },
      'Nairobi-Kenya': { lat: -1.2921, lng: 36.8219 },
      'Cairo-Egypt': { lat: 30.0444, lng: 31.2357 },
      'Kampala-Uganda': { lat: 0.3476, lng: 32.5825 },
      'Dar es Salaam-Tanzania': { lat: -6.8, lng: 39.2833 },
      'Addis Ababa-Ethiopia': { lat: 9.0320, lng: 38.7469 },
    };
    return cityCoords[`${city}-${country}`] || { lat: 0, lng: 0 };
  }

  async getNewsForLocation(lat, lng, radius = 50, limit = 20) {
    const connection = await db.getConnection();
    try {
      const limitNum = parseInt(limit, 10) * 10;
      const query = `
        SELECT * FROM articles
        WHERE latitude IS NOT NULL AND longitude IS NOT NULL
        ORDER BY published_at DESC
        LIMIT ${limitNum}
      `;

      const [rows] = await connection.execute(query);

      const filtered = rows.filter((article) => {
        const distance = this.calculateDistance(
          lat,
          lng,
          article.latitude,
          article.longitude
        );
        return distance <= radius;
      });

      return filtered;
    } catch (error) {
      console.error('Error getting news for location:', error.message);
      return [];
    } finally {
      connection.release();
    }
  }

  calculateDistance(lat1, lon1, lat2, lon2) {
    const R = 6371;
    const dLat = ((lat2 - lat1) * Math.PI) / 180;
    const dLon = ((lon2 - lon1) * Math.PI) / 180;
    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos((lat1 * Math.PI) / 180) *
        Math.cos((lat2 * Math.PI) / 180) *
        Math.sin(dLon / 2) *
        Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
  }

  async getNewsByCity(city, limit = 20) {
    const connection = await db.getConnection();
    try {
      const limitNum = parseInt(limit, 10);
      const query = `
        SELECT * FROM articles
        WHERE LOWER(city) = LOWER(?)
        ORDER BY published_at DESC
        LIMIT ${limitNum}
      `;

      const [rows] = await connection.execute(query, [city]);
      return rows;
    } catch (error) {
      console.error('Error getting news by city:', error.message);
      return [];
    } finally {
      connection.release();
    }
  }

  async getLatestNews(limit = 50) {
    const connection = await db.getConnection();
    try {
      const limitNum = parseInt(limit, 10);
      console.log(`📰 Fetching latest ${limitNum} articles from database...`);
      
      const query = `
        SELECT * FROM articles
        ORDER BY published_at DESC
        LIMIT ${limitNum}
      `;

      const [rows] = await connection.execute(query);
      console.log(`✅ Found ${rows.length} articles in database`);
      return rows;
    } catch (error) {
      console.error('❌ Error getting latest news:', error.message);
      console.error('Stack:', error.stack);
      return [];
    } finally {
      connection.release();
    }
  }

  startNewsAggregation() {
    console.log('🔄 Starting real-time news aggregation service...');

    const aggregateNews = async () => {
      console.log(`📰 [${new Date().toISOString()}] Aggregating news...`);

      const userLocations = await userLocationService.getAllUserLocations();

      if (userLocations.length === 0) {
        console.log('⚠️  No user locations found. Waiting for users to connect...');
        return;
      }

      console.log(`📍 Found ${userLocations.length} unique user locations`);

      const uniqueCountries = [...new Set(userLocations.map(loc => loc.country))];
      console.log(`🌍 Unique countries: ${uniqueCountries.join(', ')}`);

      for (const { city, country } of userLocations) {
        try {
          const countryCode = this.getCountryCode(country);
          const news = await this.getLocalNews(city, country, countryCode);
          await this.saveArticles(news, city, country);
          console.log(`✅ Saved ${news.length} articles for ${city}, ${country}`);
        } catch (error) {
          console.error(`Error aggregating news for ${city}:`, error.message);
        }
      }

      const scrapedNews = await scraperService.scrapeForCountries(uniqueCountries);
      console.log(`✅ Scraped ${scrapedNews.length} articles from local sources`);
    };

    aggregateNews();

    setInterval(aggregateNews, this.newsFetchInterval);
  }

  getCountryCode(country) {
    const countryMap = {
      'Nigeria': 'ng',
      'Ghana': 'gh',
      'USA': 'us',
      'United States': 'us',
      'UK': 'gb',
      'United Kingdom': 'gb',
      'Canada': 'ca',
      'India': 'in',
      'Australia': 'au',
      'Germany': 'de',
      'France': 'fr',
      'Japan': 'jp',
      'China': 'cn',
      'Brazil': 'br',
      'Mexico': 'mx',
      'South Africa': 'za',
      'Kenya': 'ke',
      'Egypt': 'eg',
      'Uganda': 'ug',
      'Tanzania': 'tz',
      'Ethiopia': 'et',
    };
    return countryMap[country] || 'us';
  }
}

module.exports = new NewsService();
