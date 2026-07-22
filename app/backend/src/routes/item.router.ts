import { Router } from 'express';
import { getItems, createItem, deleteItem } from '../controllers/item.controller';

const router = Router();

router.get('/items', getItems);
router.post('/items', createItem);
router.delete('/items/:id', deleteItem);

export default router;
