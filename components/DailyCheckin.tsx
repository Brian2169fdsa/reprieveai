'use client';

import { useMemo, useState } from 'react';
import {
  CHECKIN_SYSTEM_PROMPT,
  Goal,
  buildUserPrompt,
  createDailyCheckinEntry,
} from '@/lib/goals';

type DailyCheckinProps = {
  uid: string;
  goals: Goal[];
};

type CheckinResponse = {
  summary: string;
  perGoal: Array<{ goalTitle: string; checkinQuestion: string; microStep: string }>;
  closing: string;
};

export default function DailyCheckin({ uid, goals }: DailyCheckinProps) {
  const [notes, setNotes] = useState('');
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<CheckinResponse | null>(null);
  const [error, setError] = useState<string | null>(null);

  const activeGoals = useMemo(() => goals.filter((goal) => goal.active), [goals]);

  const onGenerate = async () => {
    setLoading(true);
    setError(null);

    try {
      const today = new Date().toISOString().slice(0, 10);
      const userPrompt = buildUserPrompt({
        today,
        notes,
        activeGoals,
      });

      const response = await fetch('/api/ai/checkin', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          systemPrompt: CHECKIN_SYSTEM_PROMPT,
          userPrompt,
        }),
      });

      const json = (await response.json()) as { result?: CheckinResponse; error?: string };

      if (!response.ok) {
        throw new Error(json.error || 'Failed to generate check-in.');
      }

      if (json.result) {
        setResult(json.result);
        await createDailyCheckinEntry(uid, notes);
      }
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Unknown error');
    } finally {
      setLoading(false);
    }
  };

  return (
    <section style={{ display: 'grid', gap: 12 }}>
      <h2 style={{ margin: 0, fontSize: 22 }}>Daily Check-in</h2>
      <textarea
        value={notes}
        onChange={(event) => setNotes(event.target.value)}
        rows={5}
        placeholder="How are you feeling today?"
        style={{
          width: '100%',
          padding: 12,
          borderRadius: 10,
          border: '1px solid #d1d5db',
          resize: 'vertical',
          background: '#fff',
        }}
      />
      <button
        type="button"
        onClick={onGenerate}
        disabled={loading}
        style={{
          width: 'fit-content',
          border: 0,
          borderRadius: 10,
          background: '#111827',
          color: '#fff',
          padding: '10px 14px',
          fontWeight: 600,
          cursor: 'pointer',
        }}
      >
        {loading ? 'Generating...' : 'Generate today\'s check-in'}
      </button>

      {error ? <p style={{ margin: 0, color: '#b91c1c' }}>{error}</p> : null}

      {result ? (
        <pre
          style={{
            margin: 0,
            borderRadius: 10,
            border: '1px solid #e5e7eb',
            background: '#fff',
            padding: 12,
            overflowX: 'auto',
            whiteSpace: 'pre-wrap',
            wordBreak: 'break-word',
          }}
        >
          {JSON.stringify(result, null, 2)}
        </pre>
      ) : null}
    </section>
  );
}
