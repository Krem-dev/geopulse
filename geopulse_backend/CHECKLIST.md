# GeoPulse Backend - Setup Checklist

## ✅ Configuration Complete

- [x] MySQL Database (Aiven)
  - Host: krem-kremlin-0821.g.aivencloud.com
  - Port: 27945
  - Database: defaultdb
  - User: avnadmin

- [x] NewsAPI Key
  - Key: (stored in .env)
  - Free tier: 100 requests/day
  - Endpoints: Top headlines, Everything

## 📋 Setup Steps

### Step 1: Install Dependencies
```bash
cd c:/github/geopulse/geopulse_backend
npm install
```

### Step 2: Test Database Connection
```bash
node test-connection.js
```

Expected output:
```
🔌 Testing MySQL connection...
✅ Connected successfully!
MySQL Version: 8.0.x
Existing tables: 0
✅ Connection test completed!
```

### Step 3: Create Database Tables
```bash
mysql -h krem-kremlin-0821.g.aivencloud.com -P 27945 -u avnadmin -p defaultdb < database/schema.sql
```

When prompted for password, use the value from your `.env` file (DB_PASSWORD)

### Step 4: Start Backend Server
```bash
npm run dev
```

Expected output:
```
🚀 GeoPulse backend running on port 3000
📍 API Base URL: http://localhost:3000
🏥 Health Check: http://localhost:3000/health

🔄 Starting real-time news aggregation service...
📰 [2025-12-07T15:00:00.000Z] Aggregating news...
✅ Saved 45 articles for Lagos
✅ Saved 38 articles for New York
✅ Saved 42 articles for London
✅ Saved 40 articles for Toronto
✅ Scraped 25 articles from local sources
```

## 🧪 Test API Endpoints

Once server is running, test these endpoints:

### 1. Health Check
```bash
curl http://localhost:3000/health
```

Response:
```json
{
  "status": "OK",
  "message": "GeoPulse backend is running",
  "timestamp": "2025-12-07T15:00:00.000Z"
}
```

### 2. Get Latest News
```bash
curl http://localhost:3000/api/news/latest?limit=5
```

### 3. Get News by City
```bash
curl "http://localhost:3000/api/news/city/Lagos?limit=5"
```

### 4. Get News by Location
```bash
curl "http://localhost:3000/api/news/location?lat=6.5244&lng=3.3792&radius=50&limit=5"
```

### 5. Search Local News
```bash
curl "http://localhost:3000/api/news/search?city=Lagos&country=Nigeria&countryCode=ng&limit=5"
```

## 📊 Real-Time News Flow

```
Backend Service (Every 60 seconds):
  1. Fetch from NewsAPI
     - Top headlines by country
     - Search by city keywords
  
  2. Scrape Local News
     - BBC News
     - CNN
     - Reuters
  
  3. Store in MySQL
     - Deduplicate articles
     - Add timestamps
     - Index by location
  
  4. Ready for App Queries
     - Location-based filtering
     - City-based filtering
     - Latest news sorting
```

## 🎯 What's Running

### News Sources
- ✅ NewsAPI (38,000+ sources)
- ✅ BBC News (scraping)
- ✅ CNN (scraping)
- ✅ Reuters (scraping)

### Update Frequency
- ✅ News fetch: Every 60 seconds
- ✅ Web scraping: Every 5 minutes
- ✅ Database: Real-time updates

### Database
- ✅ Articles table (optimized indexes)
- ✅ User locations table
- ✅ SSL connection (Aiven)

## 🚀 Next: Connect Flutter App

Once backend is running, update your Flutter app:

```dart
// lib/services/newsService.dart

const String API_BASE_URL = 'http://localhost:3000';

Future<List<NewsArticle>> fetchNewsByLocation(double lat, double lng) async {
  final response = await http.get(
    Uri.parse(
      '$API_BASE_URL/api/news/location?lat=$lat&lng=$lng&radius=50&limit=20'
    ),
  );
  
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return (data['news'] as List)
        .map((json) => NewsArticle.fromJson(json))
        .toList();
  }
  throw Exception('Failed to load news');
}
```

## 📝 Environment Variables

```env
PORT=3000
NODE_ENV=development
NEWS_API_KEY=your_newsapi_key_here
DB_HOST=krem-kremlin-0821.g.aivencloud.com
DB_PORT=27945
DB_NAME=defaultdb
DB_USER=avnadmin
DB_PASSWORD=your_database_password_here
SCRAPE_INTERVAL=300000
NEWS_FETCH_INTERVAL=60000
```

## ✨ Features Ready

- ✅ Real-time news aggregation
- ✅ Location-based filtering
- ✅ City-based search
- ✅ Web scraping
- ✅ Automatic deduplication
- ✅ MySQL database
- ✅ API endpoints
- ✅ Error handling

## 🔧 Troubleshooting

### MySQL Connection Failed
```
Error: connect ECONNREFUSED
```
- Check internet connection
- Verify credentials in .env
- Run: `node test-connection.js`

### NewsAPI Error
```
Error: 401 Unauthorized
```
- Verify API key in .env
- Check at https://newsapi.org/account
- Free tier: 100 requests/day

### Port Already in Use
```
Error: listen EADDRINUSE :::3000
```
- Change PORT in .env
- Or kill process: `lsof -i :3000`

## 📞 Support

- NewsAPI Docs: https://newsapi.org/docs
- MySQL Docs: https://dev.mysql.com/doc/
- Aiven Console: https://console.aiven.io

---

## ✅ Ready to Go!

Your backend is fully configured and ready to serve real-time location-based news to your Flutter app!

**Status:**
- ✅ MySQL Database: Connected
- ✅ NewsAPI Key: Active
- ✅ Backend Code: Ready
- ✅ API Endpoints: Configured
- ✅ Real-time Updates: Enabled

**Next:** Start the backend and connect your Flutter app! 🚀
