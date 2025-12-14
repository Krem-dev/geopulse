const axios = require('axios');
const db = require('../config/database');

class WeatherService {
  constructor() {
    this.apiKey = process.env.WEATHER_API_KEY || '';
    this.baseUrl = 'https://api.openweathermap.org/data/2.5';
  }

  async getWeatherAlerts(lat, lng, city, country) {
    try {
      const response = await axios.get(`${this.baseUrl}/onecall`, {
        params: {
          lat,
          lon: lng,
          appid: this.apiKey,
          exclude: 'minutely,hourly,daily',
        },
        timeout: 10000,
      });

      const alerts = response.data.alerts || [];
      
      if (alerts.length > 0) {
        console.log(`⚠️  Found ${alerts.length} weather alerts for ${city}`);
        await this.saveWeatherAlerts(alerts, lat, lng, city, country);
      }

      return alerts;
    } catch (error) {
      console.error(`❌ Error fetching weather alerts for ${city}:`, error.message);
      return [];
    }
  }

  async saveWeatherAlerts(alerts, lat, lng, city, country) {
    const connection = await db.getConnection();
    try {
      for (const alert of alerts) {
        const query = `
          INSERT INTO weather_alerts 
          (alert_type, severity, title, description, latitude, longitude, 
           city, country, start_time, end_time, source, created_at)
          VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())
        `;

        const alertType = this.mapAlertType(alert.event);
        const severity = this.mapSeverity(alert.tags);

        await connection.execute(query, [
          alertType,
          severity,
          alert.event,
          alert.description,
          lat,
          lng,
          city,
          country,
          new Date(alert.start * 1000),
          new Date(alert.end * 1000),
          alert.sender_name || 'Weather Service',
        ]);
      }
    } catch (error) {
      console.error('Error saving weather alerts:', error.message);
    } finally {
      connection.release();
    }
  }

  mapAlertType(event) {
    const eventLower = event.toLowerCase();
    if (eventLower.includes('storm') || eventLower.includes('thunder')) return 'storm';
    if (eventLower.includes('flood')) return 'flood';
    if (eventLower.includes('heat')) return 'heat';
    if (eventLower.includes('cold')) return 'cold';
    if (eventLower.includes('wind')) return 'wind';
    if (eventLower.includes('rain')) return 'rain';
    return 'rain';
  }

  mapSeverity(tags) {
    if (!tags || tags.length === 0) return 'moderate';
    if (tags.includes('Extreme')) return 'extreme';
    if (tags.includes('Severe')) return 'severe';
    if (tags.includes('Moderate')) return 'moderate';
    return 'minor';
  }

  async getActiveAlerts(lat, lng, radius = 50) {
    const connection = await db.getConnection();
    try {
      const query = `
        SELECT *
        FROM weather_alerts
        WHERE end_time > NOW()
          AND (6371 * acos(
            cos(radians(${lat})) * cos(radians(latitude)) *
            cos(radians(longitude) - radians(${lng})) +
            sin(radians(${lat})) * sin(radians(latitude))
          )) <= ${radius}
        ORDER BY severity DESC, start_time DESC
      `;

      const [rows] = await connection.execute(query);
      return rows;
    } catch (error) {
      console.error('Error getting active alerts:', error.message);
      return [];
    } finally {
      connection.release();
    }
  }
}

module.exports = new WeatherService();
