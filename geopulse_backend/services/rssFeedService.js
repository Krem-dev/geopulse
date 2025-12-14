const axios = require('axios');
const xml2js = require('xml2js');
const db = require('../config/database');

class RSSFeedService {
  constructor() {
    this.feeds = {
      Ghana: [
        {
          name: 'GhanaWeb RSS',
          url: 'https://www.ghanaweb.com/GhanaHomePage/rss/news.xml',
          city: 'Accra',
        },
        {
          name: 'MyJoyOnline RSS',
          url: 'https://www.myjoyonline.com/feed/',
          city: 'Accra',
        },
        {
          name: 'Citinewsroom RSS',
          url: 'https://citinewsroom.com/feed/',
          city: 'Accra',
        },
      ],
      Nigeria: [
        {
          name: 'Punch RSS',
          url: 'https://punchng.com/feed/',
          city: 'Lagos',
        },
        {
          name: 'Premium Times RSS',
          url: 'https://www.premiumtimesng.com/feed',
          city: 'Lagos',
        },
      ],
    };
  }

  async fetchRSSFeed(feedUrl) {
    try {
      const response = await axios.get(feedUrl, {
        timeout: 10000,
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      });

      const parser = new xml2js.Parser();
      const result = await parser.parseStringPromise(response.data);

      return result;
    } catch (error) {
      console.error(`❌ Error fetching RSS feed ${feedUrl}:`, error.message);
      return null;
    }
  }

  async parseRSSItems(rssData, feedName, city, country) {
    const articles = [];

    if (!rssData || !rssData.rss || !rssData.rss.channel) {
      return articles;
    }

    const items = rssData.rss.channel[0].item || [];

    for (const item of items) {
      try {
        const article = {
          title: item.title ? item.title[0] : '',
          description: item.description ? item.description[0] : '',
          url: item.link ? item.link[0] : '',
          publishedAt: item.pubDate ? new Date(item.pubDate[0]) : new Date(),
          source: feedName,
          city,
          country,
        };

        if (article.title && article.url) {
          articles.push(article);
        }
      } catch (error) {
        console.error('Error parsing RSS item:', error.message);
      }
    }

    return articles;
  }

  async fetchAllFeeds(countries) {
    const allArticles = [];

    for (const country of countries) {
      const countryFeeds = this.feeds[country] || [];

      if (countryFeeds.length === 0) {
        console.log(`⚠️  No RSS feeds configured for ${country}`);
        continue;
      }

      console.log(`📡 Fetching ${countryFeeds.length} RSS feeds for ${country}...`);

      for (const feed of countryFeeds) {
        const rssData = await this.fetchRSSFeed(feed.url);
        
        if (rssData) {
          const articles = await this.parseRSSItems(
            rssData,
            feed.name,
            feed.city,
            country
          );
          
          console.log(`✅ Fetched ${articles.length} articles from ${feed.name}`);
          allArticles.push(...articles);
        }
      }
    }

    return allArticles;
  }
}

module.exports = new RSSFeedService();
