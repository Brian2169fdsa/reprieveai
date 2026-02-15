import Link from 'next/link';

export default function HomePage() {
  return (
    <main style={{ maxWidth: 720, margin: '0 auto', padding: 20 }}>
      <h1 style={{ marginBottom: 16 }}>NewFreedom</h1>
      <p style={{ marginBottom: 20, color: '#6b7280' }}>Choose a page:</p>
      <ul style={{ display: 'grid', gap: 12, padding: 0, listStyle: 'none' }}>
        <li>
          <Link href="/training">Training</Link>
        </li>
        <li>
          <Link href="/goals">Goals</Link>
        </li>
      </ul>
    </main>
  );
}
