const express = require('express');
const newsService = require('../services/newsService');
const userLocationService = require('../services/userLocationService');

const router = express.Router();

router.get('/location', async (req, res) => {
  try {
    const { lat, lng, radius = 50, limit = 20 } = req.query;

    if (!lat || !lng) {
      return res.status(400).json({
        error: 'Latitude and longitude are required',
      });
    }

    const news = await newsService.getNewsForLocation(
      parseFloat(lat),
      parseFloat(lng),
      parseInt(radius),
      parseInt(limit)
    );

    res.json({
      success: true,
      count: news.length,
      timestamp: new Date().toISOString(),
      news,
    });
  } catch (error) {
    console.error('Error in /location endpoint:', error);
    res.status(500).json({ error: 'Failed to fetch news' });
  }
});

router.get('/city/:city', async (req, res) => {
  try {
    const { city } = req.params;
    const { limit = 20 } = req.query;

    const news = await newsService.getNewsByCity(city, parseInt(limit));

    res.json({
      success: true,
      city,
      count: news.length,
      timestamp: new Date().toISOString(),
      news,
    });
  } catch (error) {
    console.error('Error in /city endpoint:', error);
    res.status(500).json({ error: 'Failed to fetch news' });
  }
});

router.get('/search', async (req, res) => {
  try {
    const { city, country, countryCode, limit = 20 } = req.query;

    if (!city || !country || !countryCode) {
      return res.status(400).json({
        error: 'city, country, and countryCode are required',
      });
    }

    const news = await newsService.getLocalNews(city, country, countryCode);

    res.json({
      success: true,
      location: `${city}, ${country}`,
      count: news.length,
      timestamp: new Date().toISOString(),
      news: news.slice(0, parseInt(limit)),
    });
  } catch (error) {
    console.error('Error in /search endpoint:', error);
    res.status(500).json({ error: 'Failed to fetch news' });
  }
});

router.get('/latest', async (req, res) => {
  try {
    const { limit = 50 } = req.query;

    const news = await newsService.getLatestNews(parseInt(limit));

    res.json({
      success: true,
      count: news.length,
      timestamp: new Date().toISOString(),
      news,
    });
  } catch (error) {
    console.error('Error in /latest endpoint:', error);
    res.status(500).json({ error: 'Failed to fetch news' });
  }
});

router.post('/user-location', async (req, res) => {
  try {
    const { userId, latitude, longitude, city, country } = req.body;

    if (!userId || latitude === undefined || longitude === undefined) {
      return res.status(400).json({
        error: 'userId, latitude, and longitude are required',
      });
    }

    await userLocationService.saveUserLocation(
      userId,
      latitude,
      longitude,
      city || 'Unknown',
      country || 'Unknown'
    );

    res.json({
      success: true,
      message: 'Location saved successfully',
      userId,
      latitude,
      longitude,
      city,
      country,
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    console.error('Error in /user-location endpoint:', error);
    res.status(500).json({ error: 'Failed to save location' });
  }
});

router.get('/user-location/:userId', async (req, res) => {
  try {
    const { userId } = req.params;

    const location = await userLocationService.getUserLocation(userId);

    if (!location) {
      return res.status(404).json({
        error: 'Location not found for this user',
      });
    }

    res.json({
      success: true,
      location,
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    console.error('Error in /user-location/:userId endpoint:', error);
    res.status(500).json({ error: 'Failed to fetch location' });
  }
});

router.delete('/user-location/:userId', async (req, res) => {
  try {
    const { userId } = req.params;

    await userLocationService.deleteUserLocation(userId);

    res.json({
      success: true,
      message: 'Location deleted successfully',
      userId,
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    console.error('Error in DELETE /user-location/:userId endpoint:', error);
    res.status(500).json({ error: 'Failed to delete location' });
  }
});

module.exports = router;
