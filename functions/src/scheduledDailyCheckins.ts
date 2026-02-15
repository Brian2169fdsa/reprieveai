import { onSchedule } from 'firebase-functions/v2/scheduler';
import { getFirestore } from 'firebase-admin/firestore';

type GoalDoc = {
  title: string;
  why?: string;
  frequency: 'daily' | 'weekly';
  active: boolean;
  createdAt: number;
};

export const scheduledDailyCheckins = onSchedule(
  {
    schedule: '0 6 * * *',
    timeZone: 'Etc/UTC',
  },
  async () => {
    const db = getFirestore();
    const usersSnapshot = await db.collection('users').get();
    const dateKey = new Date().toISOString().slice(0, 10);

    for (const userDoc of usersSnapshot.docs) {
      const uid = userDoc.id;
      const goalsSnapshot = await db
        .collection('users')
        .doc(uid)
        .collection('goals')
        .where('active', '==', true)
        .get();

      for (const goalDoc of goalsSnapshot.docs) {
        const goalData = goalDoc.data() as GoalDoc;
        if (!goalData.active) continue;

        const checkinId = `${dateKey}_${goalDoc.id}`;
        const checkinRef = db
          .collection('users')
          .doc(uid)
          .collection('checkins')
          .doc(checkinId);

        const existing = await checkinRef.get();
        if (existing.exists) continue;

        await checkinRef.set({
          goalId: goalDoc.id,
          dateKey,
          status: 'pending',
          createdAt: Date.now(),
        });
      }
    }
  },
);
