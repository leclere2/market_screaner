'use client'

import { useState } from 'react'

export default function WatchlistPage() {
  const [watchlist, setWatchlist] = useState<any[]>([])

  return (
    <div className="min-h-screen bg-gray-50 p-8">
      <h1 className="text-4xl font-bold mb-8">Ma Watchlist</h1>

      {watchlist.length === 0 ? (
        <div className="p-8 bg-white border border-gray-200 rounded-lg text-center">
          <p className="text-gray-600">Votre watchlist est vide.</p>
          <p className="text-sm text-gray-500 mt-2">Utilisez la page de recherche pour ajouter des instruments.</p>
        </div>
      ) : (
        <div className="grid gap-4">
          {watchlist.map((item) => (
            <div key={item.id} className="p-4 bg-white border border-gray-200 rounded-lg shadow-sm">
              <h3 className="text-lg font-semibold">{item.name}</h3>
              <p className="text-sm text-gray-600">Ticker: {item.ticker}</p>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
