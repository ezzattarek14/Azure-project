import app from './app';
import { initializeDatabase } from './config/database';

const PORT = process.env.PORT || 5000;

async function startServer() {
  await initializeDatabase();
  
  app.listen(PORT, () => {
    console.log(`==================================================`);
    console.log(` 🚀 Backend API running on port ${PORT}`);
    console.log(` 🏥 Health Check: http://localhost:${PORT}/health`);
    console.log(` 📦 API Endpoint: http://localhost:${PORT}/api/v1/items`);
    console.log(`==================================================`);
  });
}

startServer().catch(err => {
  console.error('Fatal server boot failure:', err);
  process.exit(1);
});
