CREATE TABLE IF NOT EXISTS user_reports (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id VARCHAR(100) NOT NULL,
  report_type ENUM('accident', 'traffic', 'weather', 'crime', 'protest', 'fire', 'flood', 'other') NOT NULL,
  title VARCHAR(200) NOT NULL,
  description TEXT,
  latitude DECIMAL(10, 8) NOT NULL,
  longitude DECIMAL(11, 8) NOT NULL,
  location_name VARCHAR(200),
  city VARCHAR(100),
  country VARCHAR(100),
  severity ENUM('low', 'medium', 'high', 'critical') DEFAULT 'medium',
  image_url VARCHAR(500),
  video_url VARCHAR(500),
  verified BOOLEAN DEFAULT FALSE,
  verification_count INT DEFAULT 0,
  upvotes INT DEFAULT 0,
  downvotes INT DEFAULT 0,
  status ENUM('active', 'resolved', 'false_report') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  expires_at TIMESTAMP,
  
  INDEX idx_location (latitude, longitude),
  INDEX idx_city (city),
  INDEX idx_type (report_type),
  INDEX idx_created (created_at DESC),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS report_verifications (
  id INT AUTO_INCREMENT PRIMARY KEY,
  report_id INT NOT NULL,
  user_id VARCHAR(100) NOT NULL,
  verification_type ENUM('confirm', 'deny', 'update') NOT NULL,
  comment TEXT,
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (report_id) REFERENCES user_reports(id) ON DELETE CASCADE,
  UNIQUE KEY unique_user_report (report_id, user_id),
  INDEX idx_report (report_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS social_media_posts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  platform ENUM('twitter', 'reddit', 'facebook', 'instagram') NOT NULL,
  post_id VARCHAR(200) UNIQUE NOT NULL,
  author VARCHAR(200),
  content TEXT,
  hashtags JSON,
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  location_name VARCHAR(200),
  city VARCHAR(100),
  country VARCHAR(100),
  post_url VARCHAR(500),
  image_urls JSON,
  engagement_count INT DEFAULT 0,
  posted_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  INDEX idx_location (latitude, longitude),
  INDEX idx_city (city),
  INDEX idx_posted (posted_at DESC),
  INDEX idx_platform (platform)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS weather_alerts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  alert_type ENUM('storm', 'flood', 'heat', 'cold', 'wind', 'rain') NOT NULL,
  severity ENUM('minor', 'moderate', 'severe', 'extreme') NOT NULL,
  title VARCHAR(200) NOT NULL,
  description TEXT,
  latitude DECIMAL(10, 8) NOT NULL,
  longitude DECIMAL(11, 8) NOT NULL,
  city VARCHAR(100),
  country VARCHAR(100),
  radius_km INT DEFAULT 50,
  start_time TIMESTAMP,
  end_time TIMESTAMP,
  source VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  INDEX idx_location (latitude, longitude),
  INDEX idx_severity (severity),
  INDEX idx_active (start_time, end_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
