export async function searchInstruments(q: string) {
  const res = await fetch(`/api/v1/instruments/search?q=${encodeURIComponent(q)}`)
  return res.json()
}
