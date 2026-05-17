'use client'

import { useState, useEffect } from 'react'
import { getHealth } from '@/lib/api'

export default function Home() {
  const [apiHealthy, setApiHealthy] = useState(false)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const checkHealth = async () => {
      const healthy = await getHealth()
      setApiHealthy(healthy)
      setLoading(false)
    }
    checkHealth()
  }, [])

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-blue-100 p-8">
      <div className="max-w-6xl mx-auto">
        <h1 className="text-5xl font-bold mb-4 text-blue-900">Investment Market Analyzer</h1>
        <p className="text-xl text-blue-700 mb-8">Analyse locale de marchés et aide à la décision d'investissement</p>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          <div className="p-6 bg-white rounded-lg shadow-md">
            <h2 className="text-2xl font-semibold mb-2">🔍 Recherche</h2>
            <p className="text-gray-600">Trouvez et analysez n'importe quel instrument financier</p>
            <a href="/search" className="mt-4 inline-block px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600">
              Commencer
            </a>
          </div>

          <div className="p-6 bg-white rounded-lg shadow-md">
            <h2 className="text-2xl font-semibold mb-2">⭐ Watchlist</h2>
            <p className="text-gray-600">Suivez vos instruments préférés</p>
            <a href="/watchlist" className="mt-4 inline-block px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600">
              Voir
            </a>
          </div>

          <div className="p-6 bg-white rounded-lg shadow-md">
            <h2 className="text-2xl font-semibold mb-2">📊 Analyse</h2>
            <p className="text-gray-600">Indicateurs techniques et fondamentaux</p>
            <button className="mt-4 px-4 py-2 bg-gray-400 text-white rounded cursor-not-allowed" disabled>
              Bientôt
            </button>
          </div>
        </div>

        <div className="p-6 bg-white rounded-lg shadow-md">
          <h3 className="text-lg font-semibold mb-2">État de l'API</h3>
          {loading ? (
            <p className="text-gray-600">Vérification...</p>
          ) : apiHealthy ? (
            <p className="text-green-600 font-semibold">✓ API est en ligne (http://localhost:8000)</p>
          ) : (
            <p className="text-red-600 font-semibold">✗ API indisponible. Assurez-vous que le backend tourne.</p>
          )}
        </div>
      </div>
    </div>
  )
}
