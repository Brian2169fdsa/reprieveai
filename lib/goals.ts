import { signInAnonymously, UserCredential } from 'firebase/auth';
import {
  addDoc,
  collection,
  doc,
  getDocs,
  onSnapshot,
  query,
  serverTimestamp,
  setDoc,
  updateDoc,
  where,
} from 'firebase/firestore';
import { auth, db } from '@/lib/firebase';

export type GoalFrequency = 'daily' | 'weekly';

export type Goal = {
  id: string;
  title: string;
  why?: string;
  frequency: GoalFrequency;
  active: boolean;
  createdAt: number;
};

export type GoalInput = {
  title: string;
  why?: string;
  frequency: GoalFrequency;
};

const STARTER_GOALS: Omit<Goal, 'id'>[] = [
  {
    title: 'Drink 80oz water',
    frequency: 'daily',
    active: true,
    createdAt: Date.now(),
  },
  {
    title: '10-minute walk',
    frequency: 'daily',
    active: true,
    createdAt: Date.now() + 1,
  },
  {
    title: 'Protein at breakfast',
    frequency: 'daily',
    active: true,
    createdAt: Date.now() + 2,
  },
];

export const CHECKIN_SYSTEM_PROMPT = `You are a high-accountability goals coach.
Rules:
- Daily check-ins.
- No goal limits.
- Do NOT auto-adjust goals.
Return JSON:
{
  summary: "",
  perGoal: [{goalTitle:"", checkinQuestion:"", microStep:""}],
  closing:""
}`;

export async function ensureAnonymousAuth(): Promise<UserCredential | null> {
  if (auth.currentUser) return null;
  return signInAnonymously(auth);
}

export async function ensureUserDoc(uid: string): Promise<void> {
  await setDoc(
    doc(db, 'users', uid),
    {
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
    },
    { merge: true },
  );
}

export async function ensureStarterGoals(uid: string): Promise<void> {
  const goalsRef = collection(db, 'users', uid, 'goals');
  const existing = await getDocs(query(goalsRef));
  if (!existing.empty) return;

  await Promise.all(
    STARTER_GOALS.map((goal) =>
      addDoc(goalsRef, {
        ...goal,
      }),
    ),
  );
}

export function subscribeGoals(uid: string, onData: (goals: Goal[]) => void): () => void {
  const goalsRef = collection(db, 'users', uid, 'goals');
  const goalsQuery = query(goalsRef);

  return onSnapshot(goalsQuery, (snapshot) => {
    const goals = snapshot.docs
      .map((docSnapshot) => ({
        id: docSnapshot.id,
        ...(docSnapshot.data() as Omit<Goal, 'id'>),
      }))
      .sort((a, b) => b.createdAt - a.createdAt);

    onData(goals);
  });
}

export async function createGoal(uid: string, input: GoalInput): Promise<void> {
  const goalsRef = collection(db, 'users', uid, 'goals');
  await addDoc(goalsRef, {
    title: input.title.trim(),
    why: input.why?.trim() || '',
    frequency: input.frequency,
    active: true,
    createdAt: Date.now(),
  });
}

export async function setGoalActive(uid: string, goalId: string, active: boolean): Promise<void> {
  await updateDoc(doc(db, 'users', uid, 'goals', goalId), { active });
}

export async function createDailyCheckinEntry(uid: string, notes: string): Promise<void> {
  await addDoc(collection(db, 'users', uid, 'checkins'), {
    notes,
    dateKey: new Date().toISOString().slice(0, 10),
    status: 'generated',
    createdAt: Date.now(),
  });
}

export function buildUserPrompt(input: {
  today: string;
  notes: string;
  activeGoals: Goal[];
}): string {
  const goalsText = input.activeGoals
    .map((goal, index) => `${index + 1}. ${goal.title} (${goal.frequency})`)
    .join('\n');

  return [
    `Today's date: ${input.today}`,
    `User notes: ${input.notes || 'No notes provided.'}`,
    'Active goals:',
    goalsText || 'No active goals.',
  ].join('\n');
}

export async function pendingCheckinExists(
  uid: string,
  dateKey: string,
  goalId: string,
): Promise<boolean> {
  const checkinsRef = collection(db, 'users', uid, 'checkins');
  const checkins = await getDocs(
    query(checkinsRef, where('dateKey', '==', dateKey), where('goalId', '==', goalId)),
  );
  return !checkins.empty;
}
