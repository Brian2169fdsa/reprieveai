'use client';

import { Goal, setGoalActive } from '@/lib/goals';

type GoalListProps = {
  uid: string;
  goals: Goal[];
};

export default function GoalList({ uid, goals }: GoalListProps) {
  return (
    <section>
      <h2 style={{ margin: '0 0 12px', fontSize: 22 }}>Your Goals</h2>
      <div style={{ display: 'grid', gap: 10 }}>
        {goals.map((goal) => (
          <article
            key={goal.id}
            style={{
              padding: 14,
              border: '1px solid #e5e7eb',
              borderRadius: 12,
              background: '#fff',
            }}
          >
            <div style={{ display: 'flex', justifyContent: 'space-between', gap: 10 }}>
              <div>
                <p style={{ margin: 0, fontWeight: 700 }}>{goal.title}</p>
                <p style={{ margin: '4px 0 0', color: '#6b7280', fontSize: 13 }}>
                  {goal.frequency} • {goal.active ? 'active' : 'paused'}
                </p>
                {goal.why ? (
                  <p style={{ margin: '8px 0 0', color: '#374151', fontSize: 14 }}>{goal.why}</p>
                ) : null}
              </div>
              <button
                type="button"
                onClick={() => setGoalActive(uid, goal.id, !goal.active)}
                style={{
                  alignSelf: 'start',
                  border: '1px solid #d1d5db',
                  borderRadius: 10,
                  background: '#fff',
                  padding: '8px 10px',
                  fontWeight: 600,
                  cursor: 'pointer',
                }}
              >
                {goal.active ? 'Pause' : 'Activate'}
              </button>
            </div>
          </article>
        ))}
      </div>
    </section>
  );
}
