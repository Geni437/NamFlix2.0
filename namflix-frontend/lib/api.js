const BASE_URL = process.env.NEXT_PUBLIC_API_URL || '';

let _session = null;

export function setSession(session) {
  _session = session;
}

export function getSession() {
  return _session;
}

export async function apiFetch(path, options = {}) {
  const headers = {
    'Content-Type': 'application/json',
    ...options.headers,
  };

  if (_session?.access_token) {
    headers['Authorization'] = `Bearer ${_session.access_token}`;
  }

  try {
    const url = path.startsWith('http') ? path : `${BASE_URL}${path}`;
    const res = await fetch(url, { ...options, headers });

    if (!res.ok) {
      let errorMsg = `HTTP ${res.status}`;
      try {
        const body = await res.json();
        errorMsg = body.message || body.error || errorMsg;
      } catch (_) {}
      return { data: null, error: errorMsg };
    }

    const data = await res.json();
    return { data, error: null };
  } catch (err) {
    return { data: null, error: err.message || 'Network error' };
  }
}

export function buildUrl(path, params = {}) {
  const filtered = Object.fromEntries(
    Object.entries(params).filter(([, v]) => v !== '' && v !== null && v !== undefined)
  );
  const qs = new URLSearchParams(filtered).toString();
  return qs ? `${path}?${qs}` : path;
}
