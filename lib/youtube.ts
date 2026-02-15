export type TrainingVideo = {
  title: string;
  stepLabel: string;
  videoId: string;
  description: string;
};

export const trainingVideos: TrainingVideo[] = [
  {
    title: 'Course 1: Concession',
    stepLabel: 'Step 1',
    videoId: 'T8nHLJ9nqSg',
    description: 'Build your foundation with honest admission and clear direction.',
  },
  {
    title: 'Course 2: Encounter',
    stepLabel: 'Step 2',
    videoId: 'mhAm_BmlWdM',
    description: 'Learn to identify triggers and practice healthy response patterns.',
  },
  {
    title: 'Course 3: Decision',
    stepLabel: 'Step 3',
    videoId: 'IHQAAcv1i1I',
    description: 'Make practical daily decisions that support long-term recovery.',
  },
  {
    title: 'Course 4: Introspection',
    stepLabel: 'Step 4',
    videoId: 'xD4fybJpZuM',
    description: 'Use guided reflection to uncover habits that block your progress.',
  },
  {
    title: 'Course 5: Repentance & Rededication',
    stepLabel: 'Steps 5–7',
    videoId: '4eHsi-5FKBw',
    description: 'Reinforce accountability and reset your commitments with purpose.',
  },
  {
    title: 'Course 6: Spiritual Fitness',
    stepLabel: 'Steps 8–9',
    videoId: 'yZ3bTZCeFdU',
    description: 'Develop sustainable disciplines that keep your mind and spirit aligned.',
  },
  {
    title: 'The Question',
    stepLabel: 'Foundation',
    videoId: 'QrqNO_TIOYk',
    description: 'Clarify what matters most before choosing your next step.',
  },
  {
    title: 'Movement',
    stepLabel: 'Introduction',
    videoId: 'yJs6CCiwKIs',
    description: 'Understand the mission and momentum behind this course path.',
  },
];

export function getYouTubeEmbedUrl(videoId: string): string {
  return `https://www.youtube.com/embed/${videoId}`;
}

export function getYouTubeWatchUrl(videoId: string): string {
  return `https://www.youtube.com/watch?v=${videoId}`;
}

export function getYouTubeThumbnailUrl(videoId: string): string {
  return `https://img.youtube.com/vi/${videoId}/hqdefault.jpg`;
}
