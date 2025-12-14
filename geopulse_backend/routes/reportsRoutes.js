const express = require('express');
const reportsService = require('../services/reportsService');

const router = express.Router();

router.post('/create', async (req, res) => {
  try {
    const reportData = req.body;

    if (!reportData.userId || !reportData.latitude || !reportData.longitude || !reportData.title) {
      return res.status(400).json({
        error: 'userId, latitude, longitude, and title are required',
      });
    }

    const reportId = await reportsService.createReport(reportData);

    res.json({
      success: true,
      message: 'Report created successfully',
      reportId,
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    console.error('Error in /create endpoint:', error);
    res.status(500).json({ error: 'Failed to create report' });
  }
});

router.get('/nearby', async (req, res) => {
  try {
    const { lat, lng, radius = 10, limit = 50 } = req.query;

    if (!lat || !lng) {
      return res.status(400).json({
        error: 'Latitude and longitude are required',
      });
    }

    const reports = await reportsService.getReportsNearLocation(
      parseFloat(lat),
      parseFloat(lng),
      parseInt(radius),
      parseInt(limit)
    );

    res.json({
      success: true,
      count: reports.length,
      radius: `${radius}km`,
      reports,
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    console.error('Error in /nearby endpoint:', error);
    res.status(500).json({ error: 'Failed to fetch nearby reports' });
  }
});

router.get('/city/:city', async (req, res) => {
  try {
    const { city } = req.params;
    const { limit = 50 } = req.query;

    const reports = await reportsService.getReportsByCity(city, parseInt(limit));

    res.json({
      success: true,
      city,
      count: reports.length,
      reports,
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    console.error('Error in /city endpoint:', error);
    res.status(500).json({ error: 'Failed to fetch city reports' });
  }
});

router.get('/trending', async (req, res) => {
  try {
    const { limit = 20 } = req.query;

    const reports = await reportsService.getTrendingReports(parseInt(limit));

    res.json({
      success: true,
      count: reports.length,
      reports,
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    console.error('Error in /trending endpoint:', error);
    res.status(500).json({ error: 'Failed to fetch trending reports' });
  }
});

router.post('/verify/:reportId', async (req, res) => {
  try {
    const { reportId } = req.params;
    const { userId, verificationType, comment } = req.body;

    if (!userId || !verificationType) {
      return res.status(400).json({
        error: 'userId and verificationType are required',
      });
    }

    const success = await reportsService.verifyReport(
      parseInt(reportId),
      userId,
      verificationType,
      comment
    );

    res.json({
      success,
      message: success ? 'Report verified' : 'Verification failed',
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    console.error('Error in /verify endpoint:', error);
    res.status(500).json({ error: 'Failed to verify report' });
  }
});

router.post('/upvote/:reportId', async (req, res) => {
  try {
    const { reportId } = req.params;
    const { userId } = req.body;

    if (!userId) {
      return res.status(400).json({
        error: 'userId is required',
      });
    }

    const success = await reportsService.upvoteReport(parseInt(reportId), userId);

    res.json({
      success,
      message: success ? 'Report upvoted' : 'Upvote failed',
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    console.error('Error in /upvote endpoint:', error);
    res.status(500).json({ error: 'Failed to upvote report' });
  }
});

module.exports = router;
