import { trainingVideos } from '@/lib/youtube';
import VideoCard from './VideoCard';

export default function VideoGrid() {
  return (
    <div
      style={{
        display: 'grid',
        gridTemplateColumns: 'repeat(auto-fill, minmax(280px, 1fr))',
        gap: 20,
        width: '100%',
      }}
    >
      {trainingVideos.map((video) => (
        <VideoCard key={video.videoId} video={video} />
      ))}

      <style jsx>{`
        @media (min-width: 768px) {
          div {
            grid-template-columns: repeat(2, 1fr);
            gap: 24px;
          }
        }

        @media (min-width: 1200px) {
          div {
            gap: 28px;
          }
        }
      `}</style>
    </div>
  );
}
