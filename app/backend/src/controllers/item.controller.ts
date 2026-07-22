import { Request, Response } from 'express';
import { pool } from '../config/database';

interface Item {
  id: number;
  title: string;
  description: string;
  status: string;
  created_at: string;
}

// Fallback in-memory storage for test environment or when DB is offline
const inMemoryItems: Item[] = [
  {
    id: 1,
    title: 'Azure 3-Tier Web Application',
    description: 'Provisioned via Terraform IaC and deployed automatically with GitHub Actions',
    status: 'ACTIVE',
    created_at: new Date().toISOString()
  },
  {
    id: 2,
    title: 'Containerized API & Security Hardening',
    description: 'Multi-stage Dockerfile running non-root user with minimal Alpine Linux footprint',
    status: 'ACTIVE',
    created_at: new Date().toISOString()
  }
];

export const getItems = async (_req: Request, res: Response): Promise<void> => {
  if (process.env.NODE_ENV === 'test' || process.env.SKIP_DB_INIT === 'true') {
    res.json({ success: true, count: inMemoryItems.length, data: inMemoryItems, source: 'memory' });
    return;
  }

  try {
    const result = await pool.query('SELECT * FROM items ORDER BY id ASC');
    res.json({ success: true, count: result.rowCount, data: result.rows, source: 'database' });
  } catch (err: any) {
    console.error('[Controller Error] getItems:', err.message);
    res.json({ success: true, count: inMemoryItems.length, data: inMemoryItems, source: 'fallback_memory' });
  }
};

export const createItem = async (req: Request, res: Response): Promise<void> => {
  const { title, description } = req.body;

  if (!title || title.trim() === '') {
    res.status(400).json({ success: false, error: 'Title is required' });
    return;
  }

  if (process.env.NODE_ENV === 'test' || process.env.SKIP_DB_INIT === 'true') {
    const newItem: Item = {
      id: inMemoryItems.length + 1,
      title,
      description: description || '',
      status: 'ACTIVE',
      created_at: new Date().toISOString()
    };
    inMemoryItems.push(newItem);
    res.status(201).json({ success: true, data: newItem });
    return;
  }

  try {
    const result = await pool.query(
      'INSERT INTO items (title, description) VALUES ($1, $2) RETURNING *',
      [title, description || '']
    );
    res.status(201).json({ success: true, data: result.rows[0] });
  } catch (err: any) {
    console.error('[Controller Error] createItem:', err.message);
    const newItem: Item = {
      id: inMemoryItems.length + 1,
      title,
      description: description || '',
      status: 'ACTIVE',
      created_at: new Date().toISOString()
    };
    inMemoryItems.push(newItem);
    res.status(201).json({ success: true, data: newItem, source: 'fallback_memory' });
  }
};

export const deleteItem = async (req: Request, res: Response): Promise<void> => {
  const id = parseInt(req.params.id, 10);
  if (isNaN(id)) {
    res.status(400).json({ success: false, error: 'Invalid ID format' });
    return;
  }

  if (process.env.NODE_ENV === 'test' || process.env.SKIP_DB_INIT === 'true') {
    const index = inMemoryItems.findIndex(i => i.id === id);
    if (index !== -1) {
      inMemoryItems.splice(index, 1);
      res.json({ success: true, message: `Item ${id} deleted` });
    } else {
      res.status(404).json({ success: false, error: 'Item not found' });
    }
    return;
  }

  try {
    const result = await pool.query('DELETE FROM items WHERE id = $1 RETURNING *', [id]);
    if (result.rowCount === 0) {
      res.status(404).json({ success: false, error: 'Item not found' });
      return;
    }
    res.json({ success: true, message: `Item ${id} deleted` });
  } catch (err: any) {
    console.error('[Controller Error] deleteItem:', err.message);
    res.status(500).json({ success: false, error: err.message });
  }
};
