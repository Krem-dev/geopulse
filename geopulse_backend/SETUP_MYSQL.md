# GeoPulse Backend - MySQL Setup Guide

## Prerequisites

- Node.js (v14+)
- MySQL (v5.7+)
- npm or yarn

## Step 1: Setup MySQL Database

### Using MySQL Command Line

```bash
# Login to MySQL
mysql -u root -p

# Create database
CREATE DATABASE geopulse;
USE geopulse;

# Import schema
SOURCE database/schema.sql;

# Verify tables
SHOW TABLES;
```

### Using MySQL Workbench

1. Open MySQL Workbench
2. Create new connection
3. Create new database: `geopulse`
4. Open SQL editor
5. Run `database/schema.sql`

## Step 2: Get NewsAPI Key

1. Go to https://newsapi.org
2. Sign up for free account
3. Copy your API key

## Step 3: Setup Backend

```bash
# Navigate to backend folder
cd c:/github/geopulse/geopulse_backend

# Install dependencies
npm install

# Create .env file
cp .env.example .env
```

## Step 4: Configure .env

Edit `.env` with your MySQL credentials:

```env
PORT=3000
NODE_ENV=development

NEWS_API_KEY=your_newsapi_key_here

DB_HOST=localhost
DB_PORT=3306
DB_NAME=geopulse
DB_USER=root
DB_PASSWORD=your_mysql_password

SCRAPE_INTERVAL=300000
NEWS_FETCH_INTERVAL=60000
```

## Step 5: Start Backend

```bash
# Development mode (with auto-reload)
npm run dev

# Or production mode
npm start
```

You should see:
```
🚀 GeoPulse backend running on port 3000
📍 API Base URL: http://localhost:3000
🏥 Health Check: http://localhost:3000/health

🔄 Starting real-time news aggregation service...
📰 [2025-12-07T14:54:00.000Z] Aggregating news...
```

## Step 6: Test API Endpoints

### Health Check
```bash
curl http://localhost:3000/health
```

### Get Latest News
```bash
curl http://localhost:3000/api/news/latest?limit=10
```

### Get News by City
```bash
curl "http://localhost:3000/api/news/city/Lagos?limit=10"
```

### Get News by Location
```bash
curl "http://localhost:3000/api/news/location?lat=6.5244&lng=3.3792&radius=50&limit=10"
```

### Search Local News
```bash
curl "http://localhost:3000/api/news/search?city=Lagos&country=Nigeria&countryCode=ng&limit=10"
```

## Real-Time News Updates

The backend automatically fetches news every minute:
- **NewsAPI**: Top headlines by country
- **City Search**: Latest news for major cities
- **Web Scraping**: BBC, CNN, Reuters
- **Database**: All articles stored with timestamps

## Troubleshooting

### MySQL Connection Error
```
Error: connect ECONNREFUSED 127.0.0.1:3306
```

**Solution:**
```bash
# Check if MySQL is running
mysql -u root -p

# If not, start MySQL
# Windows: Services > MySQL
# macOS: brew services start mysql
# Linux: sudo systemctl start mysql
```

### NewsAPI Key Invalid
```
Error: 401 Unauthorized
```

**Solution:**
- Verify API key at https://newsapi.org/account
- Check .env file has correct key
- Free tier: 100 requests/day limit

### Database Connection Error
```
Error: Access denied for user 'root'@'localhost'
```

**Solution:**
- Verify MySQL username and password in .env
- Check MySQL is running
- Verify database `geopulse` exists

## Database Schema

### articles table
- `id`: Primary key
- `title`: Article title
- `description`: Full article text
- `image_url`: Thumbnail image
- `source`: News source (BBC, CNN, etc.)
- `url`: Article URL
- `published_at`: Publication timestamp
- `city`: City mentioned in article
- `country`: Country mentioned in article
- `latitude/longitude`: Coordinates for location-based queries
- `created_at`: When article was saved
- `updated_at`: Last update timestamp

### Indexes
- `published_at`: Fast sorting by date
- `city/country`: Fast filtering by location
- `latitude/longitude`: Fast distance calculations
- `url`: Prevent duplicates

## Real-Time Features

✅ **Automatic News Fetching**
- Runs every 60 seconds
- Fetches from NewsAPI
- Scrapes local news sites
- Deduplicates articles

✅ **Location-Based Queries**
- Distance calculation using Haversine formula
- Filter news within X km radius
- Sort by proximity + recency

✅ **City-Based Filtering**
- Get news for specific cities
- Search by city keywords
- Real-time updates

## Next Steps

1. ✅ Setup MySQL database
2. ✅ Configure .env with credentials
3. ✅ Start backend server
4. ✅ Test API endpoints
5. 📱 Connect Flutter app to backend

## API Response Format

```json
{
  "success": true,
  "count": 15,
  "timestamp": "2025-12-07T14:54:00.000Z",
  "news": [
    {
      "id": 1,
      "title": "Breaking news headline",
      "description": "Article description...",
      "image_url": "https://...",
      "source": "BBC News",
      "url": "https://...",
      "published_at": "2025-12-07T14:30:00Z",
      "city": "London",
      "country": "UK",
      "latitude": 51.5074,
      "longitude": -0.1278,
      "created_at": "2025-12-07T14:50:00Z"
    }
  ]
}
```

## Performance Tips

1. **Indexes**: Already optimized in schema
2. **Caching**: Add Redis for frequently accessed data
3. **Pagination**: Use limit parameter
4. **Batch Inserts**: Combine multiple articles
5. **Connection Pooling**: Already configured (10 connections)

Ready to connect your Flutter app! 🚀
