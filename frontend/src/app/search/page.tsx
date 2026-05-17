'use client'

import { useState } from 'react'
import { searchInstruments } from '@/lib/api'

export default function SearchPage() {
  const [query, setQuery] = useState('')
  const [results, setResults] = useState<any[]>([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')

  const handleSearch = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    setError('')
    try {
      const data = await searchInstruments(query)
      setResults(data || [])
    } catch (err) {
      setError('Search failed. Please try again.')
      setResults([])
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen bg-gray-50 p-8">
      <h1 className="text-4xl font-bold mb-8">Recherche d'instruments</h1>

      <form onSubmit={handleSearch} className="mb-8">
        <div className="flex gap-2">
          <input
            type="text"
            placeholder="Entrez un ticker (ex: ASML) ou un nom..."
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            className="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <button
            type="submit"
            disabled={loading}
            className="px-6 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 disabled:bg-gray-400"
          >
            {loading ? 'Recherche...' : 'Rechercher'}
          </button>
        </div>
      </form>

      {error && <p className="text-red-600 mb-4">{error}</p>}

      {results.length > 0 ? (
        <div className="grid gap-4">
          {results.map((inst) => (
            <div key={inst.id} className="p-4 bg-white border border-gray-200 rounded-lg shadow-sm hover:shadow-md transition">
              <h3 className="text-lg font-semibold">{inst.name}</h3>
              <p className="text-sm text-gray-600">Ticker: {inst.ticker}</p>
              {inst.isin && <p className="text-sm text-gray-600">ISIN: {inst.isin}</p>}
              {inst.exchange && <p className="text-sm text-gray-600">Bourse: {inst.exchange.name}</p>}
            </div>
          ))}
        </div>
      ) : (
        !loading && query && <p className="text-gray-600">Aucun résultat trouvé.</p>
      )}
    </div>
  )
}
