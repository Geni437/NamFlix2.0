'use client';

import { useEffect, useRef, useState, useCallback } from 'react';

export default function StreamPlayer({ streams = [], channelName, channelLogo, onReport }) {
  const videoRef = useRef(null);
  const hlsRef = useRef(null);
  const [activeIndex, setActiveIndex] = useState(0);
  const [status, setStatus] = useState('loading'); // loading | playing | error
  const [playing, setPlaying] = useState(false);
  const [muted, setMuted] = useState(true);
  const [volume, setVolume] = useState(0.8);
  const [fullscreen, setFullscreen] = useState(false);
  const [showControls, setShowControls] = useState(true);
  const controlsTimer = useRef(null);
  const containerRef = useRef(null);

  const liveStreams = streams.filter(s => s.is_live !== false);
  const activeStream = liveStreams[activeIndex] || streams[activeIndex] || streams[0];

  const destroyHls = useCallback(() => {
    if (hlsRef.current) {
      hlsRef.current.destroy();
      hlsRef.current = null;
    }
  }, []);

  const initPlayer = useCallback(async (stream) => {
    if (!stream?.url || !videoRef.current) return;
    destroyHls();
    setStatus('loading');

    const video = videoRef.current;
    const url = stream.url;

    const Hls = (await import('hls.js')).default;

    // Treat any URL as potentially HLS — many iptv-org URLs have no .m3u8 extension
    if (Hls.isSupported()) {
      const hls = new Hls({
        enableWorker: true,
        lowLatencyMode: true,
        // User-Agent is a browser-forbidden header; cannot be set via XHR
      });

      hls.loadSource(url);
      hls.attachMedia(video);

      hls.on(Hls.Events.MANIFEST_PARSED, () => {
        setStatus('playing');
        video.play().catch(() => {});
      });

      hls.on(Hls.Events.ERROR, (_e, data) => {
        if (data.fatal) {
          setStatus('error');
        }
      });

      hlsRef.current = hls;
    } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
      // Safari native HLS
      video.src = url;
      video.load();
      video.play().then(() => setStatus('playing')).catch(() => setStatus('error'));
    } else {
      // Try as direct stream
      video.src = url;
      video.load();
      video.play().then(() => setStatus('playing')).catch(() => setStatus('error'));
    }
  }, [destroyHls]);

  useEffect(() => {
    const stream = liveStreams[activeIndex] || streams[activeIndex] || streams[0];
    if (stream) initPlayer(stream);
    return () => { destroyHls(); };
  }, [activeIndex, streams.length]);

  useEffect(() => {
    const video = videoRef.current;
    if (!video) return;
    video.muted = muted;
    video.volume = muted ? 0 : volume;
  }, [muted, volume]);

  useEffect(() => {
    const onFsChange = () => {
      setFullscreen(!!document.fullscreenElement);
    };
    document.addEventListener('fullscreenchange', onFsChange);
    return () => document.removeEventListener('fullscreenchange', onFsChange);
  }, []);

  const togglePlay = () => {
    const video = videoRef.current;
    if (!video) return;
    if (video.paused) { video.play(); setPlaying(true); }
    else { video.pause(); setPlaying(false); }
  };

  const toggleMute = () => setMuted(m => !m);

  const toggleFullscreen = () => {
    const el = containerRef.current;
    if (!el) return;
    if (!document.fullscreenElement) {
      el.requestFullscreen?.();
    } else {
      document.exitFullscreen?.();
    }
  };

  const tryNextStream = () => {
    const total = liveStreams.length || streams.length;
    if (total > 1) {
      setActiveIndex(i => (i + 1) % total);
    }
  };

  const showCtrl = () => {
    setShowControls(true);
    clearTimeout(controlsTimer.current);
    controlsTimer.current = setTimeout(() => {
      if (playing) setShowControls(false);
    }, 3000);
  };

  const allStreams = liveStreams.length > 0 ? liveStreams : streams;

  return (
    <div
      ref={containerRef}
      className="relative bg-black rounded-xl overflow-hidden"
      style={{ aspectRatio: '16/9' }}
      onMouseMove={showCtrl}
      onMouseLeave={() => playing && setShowControls(false)}
      onTouchStart={showCtrl}
    >
      {/* Video element */}
      <video
        ref={videoRef}
        className="w-full h-full object-contain"
        muted={muted}
        playsInline
        autoPlay
        onPlay={() => setPlaying(true)}
        onPause={() => setPlaying(false)}
        onError={() => setStatus('error')}
        aria-label={`${channelName} live stream`}
      />

      {/* LIVE badge overlay */}
      {status === 'playing' && (
        <div className="absolute top-4 left-4 z-10">
          <span className="badge-live">
            <span className="w-1.5 h-1.5 rounded-full bg-white live-dot" />
            LIVE
          </span>
        </div>
      )}

      {/* Loading state */}
      {status === 'loading' && (
        <div className="absolute inset-0 flex items-center justify-center z-10">
          <div className="flex flex-col items-center gap-4">
            <div className="spinner w-10 h-10" style={{ borderWidth: 3 }} />
            <p className="text-text-secondary text-sm">Loading stream…</p>
          </div>
        </div>
      )}

      {/* Error state */}
      {status === 'error' && (
        <div className="absolute inset-0 flex flex-col items-center justify-center z-10 bg-bg/80 gap-4 p-6 text-center">
          {channelLogo && (
            <img src={channelLogo} alt={channelName} className="w-20 h-20 object-contain mb-2 opacity-50" />
          )}
          <p className="text-white font-semibold text-lg">Stream Unavailable</p>
          <p className="text-text-secondary text-sm">This stream couldn't be loaded.</p>
          <div className="flex gap-3 flex-wrap justify-center">
            {allStreams.length > 1 && (
              <button onClick={tryNextStream} className="btn-primary text-sm">
                Try Another Quality
              </button>
            )}
            {onReport && (
              <button onClick={onReport} className="btn-ghost text-sm">
                Report Stream
              </button>
            )}
          </div>
        </div>
      )}

      {/* Controls overlay */}
      <div
        className={`absolute inset-0 flex flex-col justify-end transition-opacity duration-200 ${
          showControls || status !== 'playing' ? 'opacity-100' : 'opacity-0 pointer-events-none'
        }`}
      >
        <div className="player-gradient px-4 pb-4 pt-16">
          {/* Progress area (decorative for live TV) */}
          <div className="flex items-center gap-3 mb-2">
            <div className="flex-1 h-1 bg-white/20 rounded-full">
              <div className="h-full w-full bg-accent-red rounded-full" />
            </div>
          </div>

          {/* Button row */}
          <div className="flex items-center gap-2">
            {/* Play/Pause */}
            <button
              onClick={togglePlay}
              className="p-2 text-white hover:text-accent-red transition-colors focus-visible:outline-2 rounded"
              aria-label={playing ? 'Pause' : 'Play'}
              style={{ minHeight: 44, minWidth: 44 }}
            >
              {playing
                ? <svg className="w-6 h-6" fill="currentColor" viewBox="0 0 24 24"><path fillRule="evenodd" d="M6.75 5.25a.75.75 0 0 1 .75-.75H9a.75.75 0 0 1 .75.75v13.5a.75.75 0 0 1-.75.75H7.5a.75.75 0 0 1-.75-.75V5.25Zm7.5 0A.75.75 0 0 1 15 4.5h1.5a.75.75 0 0 1 .75.75v13.5a.75.75 0 0 1-.75.75H15a.75.75 0 0 1-.75-.75V5.25Z" clipRule="evenodd" /></svg>
                : <svg className="w-6 h-6" fill="currentColor" viewBox="0 0 24 24"><path fillRule="evenodd" d="M4.5 5.653c0-1.427 1.529-2.33 2.779-1.643l11.54 6.347c1.295.712 1.295 2.573 0 3.286L7.28 19.99c-1.25.687-2.779-.217-2.779-1.643V5.653Z" clipRule="evenodd" /></svg>
              }
            </button>

            {/* Mute + Volume */}
            <button
              onClick={toggleMute}
              className="p-2 text-white hover:text-accent-red transition-colors focus-visible:outline-2 rounded"
              aria-label={muted ? 'Unmute' : 'Mute'}
              style={{ minHeight: 44, minWidth: 44 }}
            >
              {muted
                ? <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" d="M17.25 9.75 19.5 12m0 0 2.25 2.25M19.5 12l2.25-2.25M19.5 12l-2.25 2.25m-10.5-6 4.72-4.72a.75.75 0 0 1 1.28.53v15.88a.75.75 0 0 1-1.28.53l-4.72-4.72H4.51c-.88 0-1.704-.507-1.938-1.354A9.009 9.009 0 0 1 2.25 12c0-.83.112-1.633.322-2.396C2.806 8.756 3.63 8.25 4.51 8.25H6.75Z" /></svg>
                : <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" d="M19.114 5.636a9 9 0 0 1 0 12.728M16.463 8.288a5.25 5.25 0 0 1 0 7.424M6.75 8.25l4.72-4.72a.75.75 0 0 1 1.28.53v15.88a.75.75 0 0 1-1.28.53l-4.72-4.72H4.51c-.88 0-1.704-.507-1.938-1.354A9.01 9.01 0 0 1 2.25 12c0-.83.112-1.633.322-2.396C2.806 8.756 3.63 8.25 4.51 8.25H6.75Z" /></svg>
              }
            </button>

            <input
              type="range"
              min={0}
              max={1}
              step={0.05}
              value={muted ? 0 : volume}
              onChange={e => { setVolume(+e.target.value); setMuted(+e.target.value === 0); }}
              className="w-20 accent-accent-red cursor-pointer hidden sm:block"
              aria-label="Volume"
            />

            <div className="flex-1" />

            {/* Quality selector */}
            {allStreams.length > 1 && (
              <select
                value={activeIndex}
                onChange={e => setActiveIndex(+e.target.value)}
                className="bg-black/60 border border-white/20 text-white text-xs rounded px-2 py-1 focus-visible:outline-2 cursor-pointer"
                aria-label="Select quality"
                style={{ minHeight: 44 }}
              >
                {allStreams.map((s, i) => (
                  <option key={i} value={i}>
                    {s.quality || `Stream ${i + 1}`}
                  </option>
                ))}
              </select>
            )}

            {/* Fullscreen */}
            <button
              onClick={toggleFullscreen}
              className="p-2 text-white hover:text-accent-red transition-colors focus-visible:outline-2 rounded"
              aria-label={fullscreen ? 'Exit fullscreen' : 'Enter fullscreen'}
              style={{ minHeight: 44, minWidth: 44 }}
            >
              {fullscreen
                ? <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" d="M9 9V4.5M9 9H4.5M9 9 3.75 3.75M9 15v4.5M9 15H4.5M9 15l-5.25 5.25M15 9h4.5M15 9V4.5M15 9l5.25-5.25M15 15h4.5M15 15v4.5m0-4.5 5.25 5.25" /></svg>
                : <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" d="M3.75 3.75v4.5m0-4.5h4.5m-4.5 0L9 9M3.75 20.25v-4.5m0 4.5h4.5m-4.5 0L9 15M20.25 3.75h-4.5m4.5 0v4.5m0-4.5L15 9m5.25 11.25h-4.5m4.5 0v-4.5m0 4.5L15 15" /></svg>
              }
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
