import { Pool } from 'pg';

const isProduction = process.env.NODE_ENV === 'production';

export const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '5432', 10),
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD || 'postgres123',
  database: process.env.DB_NAME || 'devops_db',
  ssl: process.env.DB_SSL === 'true' ? { rejectUnauthorized: false } : false,
  max: 10,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 5000,
});

export async function initializeDatabase(): Promise<boolean> {
  // If in test or if DB host is explicitly set to memory/none, skip DB init
  if (process.env.NODE_ENV === 'test' || process.env.SKIP_DB_INIT === 'true') {
    console.log('[DB] Skipping DB init in test or offline mode.');
    return true;
  }

  try {
    const client = await pool.connect();
    console.log('[DB] Connected to PostgreSQL successfully.');
    
    // Create schema if it doesn't exist
    await client.query(`
      CREATE TABLE IF NOT EXISTS items (
        id SERIAL PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        description TEXT,
        status VARCHAR(50) DEFAULT 'ACTIVE',
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
      );
    `);
    
    // Insert sample item if empty
    const res = await client.query('SELECT COUNT(*) FROM items');
    if (parseInt(res.rows[0].count, 10) === 0) {
      await client.query(
        'INSERT INTO items (title, description) VALUES ($1, $2)',
        ['Azure 3-Tier Demo Task', 'Provisioned via Terraform IaC and GitHub Actions CI/CD']
      );
    }

    client.release();
    return true;
  } catch (err) {
    console.error('[DB Error] Failed to initialize PostgreSQL connection:', err);
    return false;
  }
}
