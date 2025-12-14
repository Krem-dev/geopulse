# GeoPulse Backend

Location-based news aggregation backend for GeoPulse mobile app.

## Features

- **NewsAPI Integration**: Fetch top headlines by country
- **City-based Search**: Search news by city name
- **Web Scraping**: Scrape local news from BBC, CNN, Reuters
- **Location-based Queries**: Get news within X km radius
- **Automatic Aggregation**: Periodic news updates

## Setup

### 1. Install Dependencies

```bash
npm install
```

### 2. Configure Environment

Copy `.env.example` to `.env` and fill in your values:

```bash
cp .env.example .env
```

Required environment variables:
- `NEWS_API_KEY`: Get from https://newsapi.org
- `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`: PostgreSQL credentials

### 3. Setup Database

```bash
psql -U postgres -d geopulse -f database/schema.sql
```

### 4. Start Server

```bash
npm start
```

For development with auto-reload:

```bash
npm run dev
```

## API Endpoints

### Get News by Location

```
GET /api/news/location?lat=40.7128&lng=-74.0060&radius=50&limit=20
```

**Parameters:**
- `lat` (required): Latitude
- `lng` (required): Longitude
- `radius` (optional): Search radius in km (default: 50)
- `limit` (optional): Number of results (default: 20)

**Response:**
```json
{
  "success": true,
  "count": 15,
  "news": [
    {
      "id": 1,
      "title": "Breaking news headline",
      "description": "Article description",
      "image_url": "https://...",
      "source": "BBC News",
      "url": "https://...",
      "published_at": "2025-12-07T14:30:00Z",
      "city": "New York",
      "country": "USA"
    }
  ]
}
```

### Get News by City

```
GET /api/news/city/Lagos?limit=20
```

**Parameters:**
- `city` (required): City name
- `limit` (optional): Number of results (default: 20)

### Search Local News

```
GET /api/news/search?city=Lagos&country=Nigeria&countryCode=ng&limit=20
```

**Parameters:**
- `city` (required): City name
- `country` (required): Country name
- `countryCode` (required): ISO country code
- `limit` (optional): Number of results (default: 20)

## Architecture

```
NewsAPI / Local News Sites
    ↓
Backend (Node.js + Express)
    ↓
Database (PostgreSQL + PostGIS)
    ↓
Mobile App (Flutter)
```

## News Sources

### APIs
- NewsAPI (38,000+ sources)
- GNews (Real-time)

### Scraped Sources
- BBC News
- CNN
- Reuters

## Database Schema

### articles table
- `id`: Primary key
- `title`: Article title
- `description`: Article description
- `image_url`: Thumbnail image
- `source`: News source
- `url`: Article URL
- `published_at`: Publication timestamp
- `city`: City mentioned in article
- `country`: Country mentioned in article
- `location`: Geographic point (PostGIS)

## Performance

- **Caching**: Articles cached in database
- **Indexing**: Optimized queries with indexes
- **Geospatial**: PostGIS for efficient location queries
- **Scraping**: Periodic updates every 5 minutes

## Future Enhancements

- [ ] Real-time WebSocket updates
- [ ] User preferences/subscriptions
- [ ] Article sentiment analysis
- [ ] Trending topics detection
- [ ] Multi-language support
- [ ] Push notifications

## License

MIT
