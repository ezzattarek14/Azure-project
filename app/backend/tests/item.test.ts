import request from 'supertest';
import app from '../src/app';

describe('Items API Endpoints', () => {
  it('GET /api/v1/items should return array of items', async () => {
    const res = await request(app).get('/api/v1/items');
    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
    expect(Array.isArray(res.body.data)).toBe(true);
  });

  it('POST /api/v1/items should create a new item', async () => {
    const payload = { title: 'Test DevOps Item', description: 'Testing CI/CD Pipeline' };
    const res = await request(app).post('/api/v1/items').send(payload);
    expect(res.status).toBe(201);
    expect(res.body.success).toBe(true);
    expect(res.body.data.title).toBe('Test DevOps Item');
  });

  it('POST /api/v1/items should reject missing title', async () => {
    const res = await request(app).post('/api/v1/items').send({ description: 'No title' });
    expect(res.status).toBe(400);
    expect(res.body.success).toBe(false);
  });

  it('DELETE /api/v1/items/:id should delete item or return 404', async () => {
    const res = await request(app).delete('/api/v1/items/1');
    expect([200, 404]).toContain(res.status);
  });
});
