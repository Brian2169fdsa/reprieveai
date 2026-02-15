import { initializeApp } from 'firebase-admin/app';
import { scheduledDailyCheckins } from './scheduledDailyCheckins';

initializeApp();

export { scheduledDailyCheckins };
