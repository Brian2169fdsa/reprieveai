'use client';

import { FormEvent, useState } from 'react';
import type { CSSProperties } from 'react';
import { GoalFrequency, createGoal } from '@/lib/goals';

type GoalEditorProps = {
  uid: string;
};

export default function GoalEditor({ uid }: GoalEditorProps) {
  const [title, setTitle] = useState('');
  const [why, setWhy] = useState('');
  const [frequency, setFrequency] = useState<GoalFrequency>('daily');
  const [saving, setSaving] = useState(false);

  const onSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    if (!title.trim()) return;

    setSaving(true);
    try {
      await createGoal(uid, { title, why, frequency });
      setTitle('');
      setWhy('');
      setFrequency('daily');
    } finally {
      setSaving(false);
    }
  };

  return (
    <form onSubmit={onSubmit} style={{ display: 'grid', gap: 10 }}>
      <h2 style={{ margin: 0, fontSize: 22 }}>Add Goal</h2>
      <input
        value={title}
        onChange={(e) => setTitle(e.target.value)}
        placeholder="Goal title"
        required
        style={inputStyle}
      />
      <input
        value={why}
        onChange={(e) => setWhy(e.target.value)}
        placeholder="Why (optional)"
        style={inputStyle}
      />
      <select
        value={frequency}
        onChange={(e) => setFrequency(e.target.value as GoalFrequency)}
        style={inputStyle}
      >
        <option value="daily">Daily</option>
        <option value="weekly">Weekly</option>
      </select>
      <button type="submit" disabled={saving} style={buttonStyle}>
        {saving ? 'Saving...' : 'Save goal'}
      </button>
    </form>
  );
}

const inputStyle: CSSProperties = {
  padding: '10px 12px',
  borderRadius: 10,
  border: '1px solid #d1d5db',
  fontSize: 14,
  background: '#fff',
};

const buttonStyle: CSSProperties = {
  padding: '10px 14px',
  borderRadius: 10,
  border: 0,
  background: '#111827',
  color: '#fff',
  fontWeight: 600,
  cursor: 'pointer',
};
