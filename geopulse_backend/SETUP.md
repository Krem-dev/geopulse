# GeoPulse Backend Setup Guide

## Prerequisites

- Node.js (v14+)
- PostgreSQL (v12+)
- npm or yarn

## Step 1: Get NewsAPI Key

1. Go to https://newsapi.org
2. Sign up for free account
3. Copy your API key

## Step 2: Setup PostgreSQL

### Windows

```bash
# Install PostgreSQL from https://www.postgresql.org/download/windows/

# Create database
psql -U postgres
CREATE DATABASE geopulse;
\q
```

### macOS

```bash
brew install postgresql
brew services start postgresql
psql postgres
CREATE DATABASE geopulse;
\q
```

### Linux

```bash
sudo apt-get install postgresql postgresql-contrib
sudo -u postgres psql
CREATE DATABASE geopulse;
\q
```

## Step 3: Setup Backend

```bash
# Navigate to backend folder
cd c:/github/geopulse/geopulse_backend

# Install dependencies
npm install

# Create .env file
cp .env.example .env

# Edit .env with your values
# - NEWS_API_KEY=your_key_here
# - DB_PASSWORD=your_postgres_password
```

## Step 4: Initialize Database

```bash
# Connect to PostgreSQL
psql -U postgres -d geopulse -f database/schema.sql
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
🔄 Starting news aggregation service...
```

## Step 6: Test API

```bash
# Test health check
curl http://localhost:3000/health

# Get news by location (New York)
curl "http://localhost:3000/api/news/location?lat=40.7128&lng=-74.0060&radius=50&limit=10"

# Get news by city
curl "http://localhost:3000/api/news/city/Lagos?limit=10"

# Search local news
curl "http://localhost:3000/api/news/search?city=Lagos&country=Nigeria&countryCode=ng&limit=10"
```

## Step 7: Connect Flutter App

In your Flutter app, update the API base URL:

```dart
const String API_BASE_URL = 'http://your-backend-url:3000';

// Or for local testing on emulator:
const String API_BASE_URL = 'http://10.0.2.2:3000';
```

## Troubleshooting

### PostgreSQL Connection Error

```
Error: connect ECONNREFUSED 127.0.0.1:5432
```

**Solution:**
```bash
# Check if PostgreSQL is running
psql -U postgres

# If not, start it
# Windows: Services > PostgreSQL
# macOS: brew services start postgresql
# Linux: sudo systemctl start postgresql
```

### NewsAPI Key Invalid

```
Error: 401 Unauthorized
```

**Solution:**
- Verify your API key at https://newsapi.org/account
- Check .env file has correct key
- Free tier has 100 requests/day limit

### Database Already Exists

```
Error: database "geopulse" already exists
```

**Solution:**
```bash
# Drop and recreate
psql -U postgres
DROP DATABASE geopulse;
CREATE DATABASE geopulse;
\q

# Then run schema
psql -U postgres -d geopulse -f database/schema.sql
```

## Next Steps

1. Customize news sources in `services/scraperService.js`
2. Add more cities to aggregation in `services/newsService.js`
3. Implement user authentication
4. Add caching layer (Redis)
5. Deploy to production (Heroku, AWS, etc.)

## Deployment

### Heroku

```bash
# Install Heroku CLI
npm install -g heroku

# Login
heroku login

# Create app
heroku create geopulse-backend

# Add PostgreSQL addon
heroku addons:create heroku-postgresql:hobby-dev

# Set environment variables
heroku config:set NEWS_API_KEY=your_key

# Deploy
git push heroku main
```

### AWS

```bash
# Use Elastic Beanstalk or EC2
# Follow AWS documentation for Node.js deployment
```

## Support

For issues or questions, check:
- README.md for API documentation
- GitHub issues for known problems
- NewsAPI documentation: https://newsapi.org/docs
