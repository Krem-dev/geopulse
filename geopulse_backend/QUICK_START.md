# GeoPulse Backend - Quick Start

## ✅ Database Configured

Your Aiven MySQL database is already configured in `.env`:
- **Host**: krem-kremlin-0821.g.aivencloud.com
- **Port**: 27945
- **Database**: defaultdb
- **User**: avnadmin

## Step 1: Install Dependencies

```bash
cd c:/github/geopulse/geopulse_backend
npm install
```

## Step 2: Test Database Connection

```bash
node test-connection.js
```

You should see:
```
🔌 Testing MySQL connection...

✅ Connected successfully!

MySQL Version: 8.0.x
Existing tables: 0

✅ Connection test completed!
```

## Step 3: Create Database Tables

```bash
# Run schema to create tables
mysql -h krem-kremlin-0821.g.aivencloud.com -P 27945 -u avnadmin -p defaultdb < database/schema.sql
```

Or use MySQL Workbench:
1. Create new connection with above credentials
2. Open SQL editor
3. Run `database/schema.sql`

## Step 4: Add NewsAPI Key

Get your free API key from https://newsapi.org

Edit `.env`:
```env
NEWS_API_KEY=your_newsapi_key_here
```

## Step 5: Start Backend

```bash
npm run dev
```

You should see:
```
🚀 GeoPulse backend running on port 3000
📍 API Base URL: http://localhost:3000
🏥 Health Check: http://localhost:3000/health

🔄 Starting real-time news aggregation service...
📰 [2025-12-07T14:54:00.000Z] Aggregating news...
✅ Saved 45 articles for Lagos
✅ Saved 38 articles for New York
✅ Saved 42 articles for London
✅ Saved 40 articles for Toronto
✅ Scraped 25 articles from local sources
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

## Real-Time Updates

The backend automatically:
- ✅ Fetches news every 60 seconds
- ✅ Searches by city keywords
- ✅ Scrapes BBC, CNN, Reuters
- ✅ Stores in MySQL database
- ✅ Deduplicates articles

## Next: Connect Flutter App

Update your Flutter app to use the backend:

```dart
const String API_BASE_URL = 'http://localhost:3000';

// Or for production:
const String API_BASE_URL = 'https://your-deployed-backend.com';
```

## Troubleshooting

### Connection Error
```
Error: connect ECONNREFUSED
```
- Verify .env has correct credentials
- Check internet connection
- Test with `node test-connection.js`

### SSL Error
```
Error: SSL connection error
```
- Already configured with `ssl: 'Amazon'`
- Aiven requires SSL for all connections

### NewsAPI Error
```
Error: 401 Unauthorized
```
- Get free key from https://newsapi.org
- Add to .env: `NEWS_API_KEY=your_key`
- Free tier: 100 requests/day

## Environment Variables

```env
PORT=3000                    # Server port
NODE_ENV=development         # development or production

NEWS_API_KEY=               # From https://newsapi.org
DB_HOST=                    # MySQL host
DB_PORT=                    # MySQL port
DB_NAME=                    # Database name
DB_USER=                    # MySQL username
DB_PASSWORD=                # MySQL password

SCRAPE_INTERVAL=300000      # Scraping interval (ms)
NEWS_FETCH_INTERVAL=60000   # News fetch interval (ms)
```

## API Response Example

```json
{
  "success": true,
  "count": 10,
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
      "city": "Lagos",
      "country": "Nigeria",
      "latitude": 6.5244,
      "longitude": 3.3792,
      "created_at": "2025-12-07T14:50:00Z"
    }
  ]
}
```

## Ready to Go! 🚀

Your backend is now configured and ready to fetch real-time news from multiple sources!

**Next steps:**
1. ✅ Install dependencies: `npm install`
2. ✅ Test connection: `node test-connection.js`
3. ✅ Create tables: Run `database/schema.sql`
4. ✅ Add NewsAPI key to `.env`
5. ✅ Start server: `npm run dev`
6. ✅ Connect Flutter app

Let me know when you're ready to integrate with the mobile app! 📱
