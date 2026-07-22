import request from 'supertest';
import app from '../src/app';

describe('Health & Readiness Endpoints', () => {
  it('GET /health should return 200 and UP status', async () => {
    const res = await request(app).get('/health');
    expect(res.status).toBe(200);
    expect(res.body).toHaveProperty('status', 'UP');
    expect(res.body).toHaveProperty('service', 'backend-api');
    expect(res.body.checks).toHaveProperty('database');
  });

  it('GET /ready should return 200 and READY status', async () => {
    const res = await request(app).get('/ready');
    expect(res.status).toBe(200);
    expect(res.body).toHaveProperty('status', 'READY');
  });

  it('GET / should return service info', async () => {
    const res = await request(app).get('/');
    expect(res.status).toBe(200);
    expect(res.body.name).toContain('DevOps Assessment API');
  });
});
