import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'National Parks Voting App',
  description: 'Vote and rank the best national parks using ELO rating system',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className="antialiased">
        {children}
      </body>
    </html>
  )
}