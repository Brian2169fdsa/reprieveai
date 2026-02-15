'use client';

import { useEffect, useMemo, useState } from 'react';
import type { CSSProperties } from 'react';
import { onAuthStateChanged } from 'firebase/auth';
import DailyCheckin from '@/components/DailyCheckin';
import GoalEditor from '@/components/GoalEditor';
import GoalList from '@/components/GoalList';
import { auth } from '@/lib/firebase';
import { Goal, ensureAnonymousAuth, ensureStarterGoals, ensureUserDoc, subscribeGoals } from '@/lib/goals';

export default function GoalsPage() {
  const [uid, setUid] = useState<string | null>(null);
  const [goals, setGoals] = useState<Goal[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let unsubscribeGoals: (() => void) | null = null;

    const unsubscribeAuth = onAuthStateChanged(auth, async (user) => {
      if (!user) {
        await ensureAnonymousAuth();
        return;
      }

      setUid(user.uid);
      await ensureUserDoc(user.uid);
      await ensureStarterGoals(user.uid);

      unsubscribeGoals = subscribeGoals(user.uid, setGoals);
      setLoading(false);
    });

    return () => {
      unsubscribeAuth();
      unsubscribeGoals?.();
    };
  }, []);

  const activeCount = useMemo(() => goals.filter((goal) => goal.active).length, [goals]);

  if (loading || !uid) {
    return (
      <main style={{ maxWidth: 1100, margin: '0 auto', padding: 20 }}>
        <p>Loading goals...</p>
      </main>
    );
  }

  return (
    <main style={{ maxWidth: 1100, margin: '0 auto', padding: 20 }}>
      <header style={{ marginBottom: 20 }}>
        <h1 style={{ margin: 0, fontSize: 32 }}>Goals</h1>
        <p style={{ marginTop: 8, color: '#6b7280' }}>{activeCount} active goals</p>
      </header>

      <div
        style={{
          display: 'grid',
          gridTemplateColumns: '1fr',
          gap: 16,
        }}
      >
        <section style={panelStyle}>
          <GoalEditor uid={uid} />
        </section>

        <section style={panelStyle}>
          <GoalList uid={uid} goals={goals} />
        </section>

        <section style={panelStyle}>
          <DailyCheckin uid={uid} goals={goals} />
        </section>
      </div>

      <style jsx>{`
        @media (min-width: 768px) {
          main > div {
            grid-template-columns: repeat(2, minmax(0, 1fr));
          }

          main > div > section:last-child {
            grid-column: span 2;
          }
        }
      `}</style>
    </main>
  );
}

const panelStyle: CSSProperties = {
  background: '#fff',
  borderRadius: 16,
  border: '1px solid #e5e7eb',
  boxShadow: '0 4px 10px rgba(0,0,0,0.04)',
  padding: 16,
};
