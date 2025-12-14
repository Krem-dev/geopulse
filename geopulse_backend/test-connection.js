const mysql = require('mysql2/promise');
require('dotenv').config();

async function testConnection() {
  try {
    console.log('🔌 Testing MySQL connection...\n');

    const connection = await mysql.createConnection({
      host: process.env.DB_HOST,
      port: process.env.DB_PORT,
      database: process.env.DB_NAME,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      ssl: {
        rejectUnauthorized: false,
      },
    });

    console.log('✅ Connected successfully!\n');

    const [rows] = await connection.execute('SELECT VERSION()');
    console.log('MySQL Version:', rows[0]['VERSION()']);

    const [tables] = await connection.execute('SHOW TABLES');
    console.log('\nExisting tables:', tables.length);
    if (tables.length > 0) {
      tables.forEach((table) => {
        console.log('  -', Object.values(table)[0]);
      });
    } else {
      console.log('  (No tables yet - run database/schema.sql to create them)');
    }

    await connection.end();
    console.log('\n✅ Connection test completed!');
  } catch (error) {
    console.error('❌ Connection failed:', error.message);
    process.exit(1);
  }
}

testConnection();
