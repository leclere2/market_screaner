const API_BASE = typeof window !== 'undefined' ? process.env.NEXT_PUBLIC_API_URL : ''

export async function searchInstruments(q: string) {
  if (!q || q.trim().length === 0) {
    return []
  }
  try {
    const url = `${API_BASE}/api/v1/instruments/search?q=${encodeURIComponent(q)}`
    const res = await fetch(url, { method: 'GET' })
    if (!res.ok) {
      console.error('Search failed:', res.status)
      return []
    }
    return await res.json()
  } catch (err) {
    console.error('API error:', err)
    return []
  }
}

export async function getInstrument(id: number) {
  try {
    const url = `${API_BASE}/api/v1/instruments/${id}`
    const res = await fetch(url)
    if (!res.ok) return null
    return await res.json()
  } catch (err) {
    console.error('Fetch instrument error:', err)
    return null
  }
}

export async function getHealth() {
  try {
    const url = `${API_BASE}/api/v1/health`
    const res = await fetch(url)
    return res.ok
  } catch {
    return false
  }
}
