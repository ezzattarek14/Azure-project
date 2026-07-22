import { Request, Response } from 'express';
import { pool } from '../config/database';

export const getHealth = async (_req: Request, res: Response): Promise<void> => {
  let dbStatus = 'disconnected';
  
  if (process.env.NODE_ENV === 'test' || process.env.SKIP_DB_INIT === 'true') {
    dbStatus = 'mocked';
  } else {
    try {
      const dbRes = await pool.query('SELECT 1');
      if (dbRes) {
        dbStatus = 'healthy';
      }
    } catch (err) {
      dbStatus = 'degraded';
    }
  }

  const healthInfo = {
    status: dbStatus === 'degraded' ? 'DEGRADED' : 'UP',
    timestamp: new Date().toISOString(),
    service: 'backend-api',
    environment: process.env.NODE_ENV || 'development',
    version: '1.0.0',
    checks: {
      database: dbStatus,
      uptime: process.uptime()
    }
  };

  const statusCode = dbStatus === 'degraded' ? 503 : 200;
  res.status(statusCode).json(healthInfo);
};

export const getReadiness = async (_req: Request, res: Response): Promise<void> => {
  res.status(200).json({ status: 'READY', timestamp: new Date().toISOString() });
};
