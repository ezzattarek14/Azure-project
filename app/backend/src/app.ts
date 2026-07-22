import express, { Express, Request, Response, NextFunction } from 'express';
import cors from 'cors';
import healthRouter from './routes/health.router';
import itemRouter from './routes/item.router';

const app: Express = express();

app.use(cors());
app.use(express.json());

// Log incoming requests
app.use((req: Request, _res: Response, next: NextFunction) => {
  if (process.env.NODE_ENV !== 'test') {
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.path}`);
  }
  next();
});

// Root welcome route
app.get('/', (_req: Request, res: Response) => {
  res.json({
    name: 'Azure 3-Tier DevOps Assessment API',
    version: '1.0.0',
    documentation: '/health',
    endpoints: ['/health', '/ready', '/api/v1/items']
  });
});

// Mount routes
app.use('/', healthRouter);
app.use('/api/v1', itemRouter);

// Global 404 handler
app.use((_req: Request, res: Response) => {
  res.status(404).json({ error: 'Endpoint Not Found' });
});

// Global error handler
app.use((err: Error, _req: Request, res: Response, _next: NextFunction) => {
  console.error('[Unhandled Error]:', err.stack || err.message);
  res.status(500).json({ error: 'Internal Server Error', message: err.message });
});

export default app;
