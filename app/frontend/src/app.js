// API endpoint prefix (proxied by Nginx or direct localhost during dev)
const API_BASE = window.location.origin.includes('5000') 
  ? 'http://localhost:5000' 
  : '/api/v1';

document.addEventListener('DOMContentLoaded', () => {
  checkBackendHealth();
  fetchItems();

  document.getElementById('btn-refresh').addEventListener('click', () => {
    checkBackendHealth();
    fetchItems();
  });

  document.getElementById('item-form').addEventListener('submit', handleAddItem);
});

async function checkBackendHealth() {
  const backendBadge = document.getElementById('backend-status-badge');
  const backendStatusText = document.getElementById('backend-status');
  const dbBadge = document.getElementById('db-status-badge');
  const dbStatusText = document.getElementById('db-status');

  try {
    const healthUrl = window.location.origin.includes('5000') ? 'http://localhost:5000/health' : '/health';
    const response = await fetch(healthUrl);
    const data = await response.json();

    if (response.ok && data.status === 'UP') {
      backendBadge.className = 'status-indicator healthy';
      backendStatusText.textContent = 'HEALTHY';

      if (data.checks && (data.checks.database === 'healthy' || data.checks.database === 'mocked')) {
        dbBadge.className = 'status-indicator healthy';
        dbStatusText.textContent = data.checks.database.toUpperCase();
      } else {
        dbBadge.className = 'status-indicator degraded';
        dbStatusText.textContent = 'DEGRADED';
      }
    } else {
      backendBadge.className = 'status-indicator degraded';
      backendStatusText.textContent = 'DEGRADED';
      dbBadge.className = 'status-indicator offline';
      dbStatusText.textContent = 'OFFLINE';
    }
  } catch (err) {
    console.error('Failed to connect to backend API:', err);
    backendBadge.className = 'status-indicator offline';
    backendStatusText.textContent = 'UNREACHABLE';
    dbBadge.className = 'status-indicator offline';
    dbStatusText.textContent = 'UNKNOWN';
  }
}

async function fetchItems() {
  const container = document.getElementById('items-list');
  try {
    const itemsUrl = window.location.origin.includes('5000') ? 'http://localhost:5000/api/v1/items' : '/api/v1/items';
    const response = await fetch(itemsUrl);
    const result = await response.json();

    if (result.success && Array.isArray(result.data)) {
      if (result.data.length === 0) {
        container.innerHTML = `<div class="card-desc" style="text-align: center; padding: 2rem;">No items found. Create your first infrastructure item above.</div>`;
        return;
      }

      container.innerHTML = result.data.map(item => `
        <div class="item-row">
          <div class="item-details">
            <h4>${escapeHtml(item.title)}</h4>
            <p>${escapeHtml(item.description || 'No description')} • <small>${new Date(item.created_at).toLocaleTimeString()}</small></p>
          </div>
          <button class="btn btn-danger" onclick="deleteItem(${item.id})">Delete</button>
        </div>
      `).join('');
    }
  } catch (err) {
    container.innerHTML = `<div style="color: var(--accent-red); text-align: center; padding: 1rem;">Failed to fetch items from API backend.</div>`;
  }
}

async function handleAddItem(e) {
  e.preventDefault();
  const titleInput = document.getElementById('item-title');
  const descInput = document.getElementById('item-desc');

  const title = titleInput.value.trim();
  const description = descInput.value.trim();

  if (!title) return;

  try {
    const itemsUrl = window.location.origin.includes('5000') ? 'http://localhost:5000/api/v1/items' : '/api/v1/items';
    const response = await fetch(itemsUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ title, description })
    });

    if (response.ok) {
      titleInput.value = '';
      descInput.value = '';
      fetchItems();
    }
  } catch (err) {
    alert('Error creating item: ' + err.message);
  }
}

async function deleteItem(id) {
  try {
    const deleteUrl = window.location.origin.includes('5000') ? `http://localhost:5000/api/v1/items/${id}` : `/api/v1/items/${id}`;
    const response = await fetch(deleteUrl, { method: 'DELETE' });
    if (response.ok) {
      fetchItems();
    }
  } catch (err) {
    alert('Error deleting item: ' + err.message);
  }
}

function escapeHtml(str) {
  return str.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");
}
