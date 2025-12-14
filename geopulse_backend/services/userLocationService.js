const db = require('../config/database');

class UserLocationService {
  async saveUserLocation(userId, latitude, longitude, city, country) {
    const connection = await db.getConnection();
    try {
      const query = `
        INSERT INTO user_locations 
        (user_id, latitude, longitude, city, country, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, NOW(), NOW())
        ON DUPLICATE KEY UPDATE 
          latitude = VALUES(latitude),
          longitude = VALUES(longitude),
          city = VALUES(city),
          country = VALUES(country),
          updated_at = NOW()
      `;

      await connection.execute(query, [
        userId,
        latitude,
        longitude,
        city,
        country,
      ]);

      console.log(`✅ Saved location for user ${userId}: ${city}, ${country}`);
    } catch (error) {
      console.error('Error saving user location:', error.message);
    } finally {
      connection.release();
    }
  }

  async getUserLocation(userId) {
    const connection = await db.getConnection();
    try {
      const query = `
        SELECT * FROM user_locations
        WHERE user_id = ?
        LIMIT 1
      `;

      const [rows] = await connection.execute(query, [userId]);
      return rows[0] || null;
    } catch (error) {
      console.error('Error getting user location:', error.message);
      return null;
    } finally {
      connection.release();
    }
  }

  async getAllUserLocations() {
    const connection = await db.getConnection();
    try {
      const query = `
        SELECT DISTINCT city, country FROM user_locations
        WHERE city IS NOT NULL AND country IS NOT NULL
      `;

      const [rows] = await connection.execute(query);
      return rows;
    } catch (error) {
      console.error('Error getting all user locations:', error.message);
      return [];
    } finally {
      connection.release();
    }
  }

  async deleteUserLocation(userId) {
    const connection = await db.getConnection();
    try {
      const query = `
        DELETE FROM user_locations
        WHERE user_id = ?
      `;

      await connection.execute(query, [userId]);
      console.log(`✅ Deleted location for user ${userId}`);
    } catch (error) {
      console.error('Error deleting user location:', error.message);
    } finally {
      connection.release();
    }
  }
}

module.exports = new UserLocationService();
