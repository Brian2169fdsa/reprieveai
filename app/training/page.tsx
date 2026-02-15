import VideoGrid from '@/components/VideoGrid';

export default function TrainingPage() {
  return (
    <main
      style={{
        maxWidth: 1200,
        margin: '0 auto',
        padding: '20px',
        minHeight: '100vh',
      }}
    >
      <header style={{ marginBottom: 32 }}>
        <h1 style={{ margin: 0, fontSize: 32, fontWeight: 800 }}>Interactive Step Experience</h1>
        <p style={{ marginTop: 8, color: '#6b7280', fontSize: 16 }}>
          Position of Neutrality training videos
        </p>
      </header>
      <VideoGrid />
    </main>
  );
}
