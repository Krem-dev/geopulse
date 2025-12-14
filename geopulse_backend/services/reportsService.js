const db = require('../config/database');

class ReportsService {
  async createReport(reportData) {
    const connection = await db.getConnection();
    try {
      const {
        userId,
        reportType,
        title,
        description,
        latitude,
        longitude,
        locationName,
        city,
        country,
        severity,
        imageUrl,
        videoUrl,
      } = reportData;

      const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000);

      const query = `
        INSERT INTO user_reports 
        (user_id, report_type, title, description, latitude, longitude, 
         location_name, city, country, severity, image_url, video_url, expires_at, created_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())
      `;

      const [result] = await connection.execute(query, [
        userId,
        reportType,
        title,
        description || '',
        latitude,
        longitude,
        locationName || '',
        city || '',
        country || '',
        severity || 'medium',
        imageUrl || null,
        videoUrl || null,
        expiresAt,
      ]);

      console.log(`✅ Created report #${result.insertId}: ${title} at ${city}`);
      return result.insertId;
    } catch (error) {
      console.error('❌ Error creating report:', error.message);
      throw error;
    } finally {
      connection.release();
    }
  }

  async getReportsNearLocation(lat, lng, radius = 10, limit = 50) {
    const connection = await db.getConnection();
    try {
      const limitNum = parseInt(limit, 10);
      const query = `
        SELECT *, 
          (6371 * acos(
            cos(radians(${lat})) * cos(radians(latitude)) *
            cos(radians(longitude) - radians(${lng})) +
            sin(radians(${lat})) * sin(radians(latitude))
          )) AS distance_km
        FROM user_reports
        WHERE status = 'active'
          AND expires_at > NOW()
        HAVING distance_km <= ${radius}
        ORDER BY created_at DESC
        LIMIT ${limitNum}
      `;

      const [rows] = await connection.execute(query);
      console.log(`📍 Found ${rows.length} reports within ${radius}km`);
      return rows;
    } catch (error) {
      console.error('❌ Error getting nearby reports:', error.message);
      return [];
    } finally {
      connection.release();
    }
  }

  async verifyReport(reportId, userId, verificationType, comment = null) {
    const connection = await db.getConnection();
    try {
      const verifyQuery = `
        INSERT INTO report_verifications 
        (report_id, user_id, verification_type, comment, created_at)
        VALUES (?, ?, ?, ?, NOW())
        ON DUPLICATE KEY UPDATE 
          verification_type = VALUES(verification_type),
          comment = VALUES(comment)
      `;

      await connection.execute(verifyQuery, [
        reportId,
        userId,
        verificationType,
        comment,
      ]);

      const countQuery = `
        SELECT COUNT(*) as count
        FROM report_verifications
        WHERE report_id = ? AND verification_type = 'confirm'
      `;

      const [countResult] = await connection.execute(countQuery, [reportId]);
      const verificationCount = countResult[0].count;

      const updateQuery = `
        UPDATE user_reports
        SET verification_count = ?,
            verified = ?
        WHERE id = ?
      `;

      await connection.execute(updateQuery, [
        verificationCount,
        verificationCount >= 3,
        reportId,
      ]);

      console.log(`✅ Report #${reportId} verified by user ${userId}`);
      return true;
    } catch (error) {
      console.error('❌ Error verifying report:', error.message);
      return false;
    } finally {
      connection.release();
    }
  }

  async upvoteReport(reportId, userId) {
    const connection = await db.getConnection();
    try {
      const query = `
        UPDATE user_reports
        SET upvotes = upvotes + 1
        WHERE id = ?
      `;

      await connection.execute(query, [reportId]);
      console.log(`👍 Report #${reportId} upvoted`);
      return true;
    } catch (error) {
      console.error('❌ Error upvoting report:', error.message);
      return false;
    } finally {
      connection.release();
    }
  }

  async getReportsByCity(city, limit = 50) {
    const connection = await db.getConnection();
    try {
      const limitNum = parseInt(limit, 10);
      const query = `
        SELECT *
        FROM user_reports
        WHERE LOWER(city) = LOWER(?)
          AND status = 'active'
          AND expires_at > NOW()
        ORDER BY created_at DESC
        LIMIT ${limitNum}
      `;

      const [rows] = await connection.execute(query, [city]);
      return rows;
    } catch (error) {
      console.error('❌ Error getting city reports:', error.message);
      return [];
    } finally {
      connection.release();
    }
  }

  async getTrendingReports(limit = 20) {
    const connection = await db.getConnection();
    try {
      const limitNum = parseInt(limit, 10);
      const query = `
        SELECT *
        FROM user_reports
        WHERE status = 'active'
          AND expires_at > NOW()
        ORDER BY (upvotes + verification_count * 2) DESC, created_at DESC
        LIMIT ${limitNum}
      `;

      const [rows] = await connection.execute(query);
      return rows;
    } catch (error) {
      console.error('❌ Error getting trending reports:', error.message);
      return [];
    } finally {
      connection.release();
    }
  }
}

module.exports = new ReportsService();
