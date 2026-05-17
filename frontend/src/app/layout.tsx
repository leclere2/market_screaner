import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'Investment Market Analyzer',
  description: 'Local investment analysis and decision support tool',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>
        <nav className="bg-blue-600 text-white p-4">
          <div className="max-w-6xl mx-auto flex gap-6">
            <a href="/" className="text-lg font-semibold hover:text-blue-200">
              Home
            </a>
            <a href="/search" className="hover:text-blue-200">
              Search
            </a>
            <a href="/watchlist" className="hover:text-blue-200">
              Watchlist
            </a>
          </div>
        </nav>
        <main>{children}</main>
      </body>
    </html>
  )
}
