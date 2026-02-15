'use client';

import { useState } from 'react';
import {
  TrainingVideo,
  getYouTubeEmbedUrl,
  getYouTubeThumbnailUrl,
  getYouTubeWatchUrl,
} from '@/lib/youtube';

type VideoCardProps = {
  video: TrainingVideo;
};

export default function VideoCard({ video }: VideoCardProps) {
  const [isPlaying, setIsPlaying] = useState(false);
  const watchUrl = getYouTubeWatchUrl(video.videoId);

  return (
    <article
      style={{
        background: '#fff',
        borderRadius: 12,
        border: '1px solid #e5e7eb',
        boxShadow: '0 2px 8px rgba(0,0,0,0.06)',
        overflow: 'hidden',
        display: 'flex',
        flexDirection: 'column',
      }}
    >
      {/* Video thumbnail/embed */}
      <div style={{ position: 'relative', width: '100%', paddingBottom: '56.25%', background: '#000' }}>
        {isPlaying ? (
          <iframe
            title={video.title}
            src={`${getYouTubeEmbedUrl(video.videoId)}?autoplay=1`}
            style={{
              position: 'absolute',
              top: 0,
              left: 0,
              width: '100%',
              height: '100%',
              border: 0,
            }}
            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
            allowFullScreen
          />
        ) : (
          <div
            onClick={() => setIsPlaying(true)}
            style={{
              position: 'absolute',
              top: 0,
              left: 0,
              width: '100%',
              height: '100%',
              cursor: 'pointer',
              background: `url(${getYouTubeThumbnailUrl(video.videoId)}) center/cover no-repeat`,
            }}
          >
            <div
              style={{
                position: 'absolute',
                inset: 0,
                background: 'rgba(0,0,0,0.3)',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                transition: 'background 0.2s',
              }}
              onMouseEnter={(e) => {
                e.currentTarget.style.background = 'rgba(0,0,0,0.5)';
              }}
              onMouseLeave={(e) => {
                e.currentTarget.style.background = 'rgba(0,0,0,0.3)';
              }}
            >
              <div
                style={{
                  width: 68,
                  height: 48,
                  background: 'rgba(255,0,0,0.9)',
                  borderRadius: 12,
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                }}
              >
                <div
                  style={{
                    width: 0,
                    height: 0,
                    borderTop: '10px solid transparent',
                    borderBottom: '10px solid transparent',
                    borderLeft: '16px solid white',
                    marginLeft: 4,
                  }}
                />
              </div>
            </div>
          </div>
        )}
      </div>

      {/* Content */}
      <div style={{ padding: 16, flex: 1 }}>
        <p style={{ margin: 0, fontSize: 12, color: '#6b7280', fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.5px' }}>
          {video.stepLabel}
        </p>
        <h3 style={{ margin: '8px 0', fontSize: 18, fontWeight: 700, lineHeight: 1.3 }}>
          {video.title}
        </h3>
        <p style={{ margin: 0, color: '#6b7280', fontSize: 14, lineHeight: 1.5 }}>
          {video.description}
        </p>
      </div>

      {/* Mobile-only external link */}
      {!isPlaying && (
        <div style={{ padding: '0 16px 16px', display: 'none' }} className="mobile-link-container">
          <a
            href={watchUrl}
            target="_blank"
            rel="noopener noreferrer"
            style={{
              display: 'block',
              textAlign: 'center',
              padding: '10px 16px',
              background: '#f3f4f6',
              color: '#374151',
              borderRadius: 8,
              textDecoration: 'none',
              fontSize: 14,
              fontWeight: 600,
            }}
          >
            Open in YouTube App
          </a>
        </div>
      )}

      <style jsx>{`
        @media (max-width: 767px) {
          .mobile-link-container {
            display: block !important;
          }
        }
      `}</style>
    </article>
  );
}
