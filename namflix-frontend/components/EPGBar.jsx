'use client';

import { useEffect, useRef, useState } from 'react';
import { apiFetch } from '@/lib/api';

function formatLocalTime(isoStr, tz) {
  if (!isoStr) return '';
  return new Intl.DateTimeFormat(undefined, {
    hour: '2-digit',
    minute: '2-digit',
    timeZone: tz,
  }).format(new Date(isoStr));
}

export default function EPGBar({ channelId }) {
  const [current, setCurrent] = useState(null);
  const [next, setNext] = useState(null);
  const [progress, setProgress] = useState(0);
  const tzRef = useRef(Intl.DateTimeFormat().resolvedOptions().timeZone);
  const intervalRef = useRef(null);

  const updateProgress = (program) => {
    if (!program) return;
    const start   = new Date(program.start_time).getTime();
    const end     = new Date(program.end_time).getTime();
    const elapsed = Date.now() - start;
    const total   = end - start;
    setProgress(Math.min(100, Math.max(0, (elapsed / total) * 100)));
  };

  useEffect(() => {
    if (!channelId) return;

    const tz = tzRef.current;
    apiFetch(`/epg/${channelId}?timezone=${encodeURIComponent(tz)}`).then((res) => {
      const data = res?.data;
      if (!data) return;
      setCurrent(data.current_program ?? null);
      setNext(data.next_program ?? null);
      if (data.current_program) {
        updateProgress(data.current_program);
      }
    }).catch(() => {});
  }, [channelId]);

  useEffect(() => {
    if (!current) return;
    updateProgress(current);
    intervalRef.current = setInterval(() => updateProgress(current), 60_000);
    return () => clearInterval(intervalRef.current);
  }, [current]);

  if (!current) return null;

  const tz = tzRef.current;

  return (
    <div
      style={{ background: 'var(--surface)', border: '1px solid var(--border)' }}
      className="rounded-lg p-4"
    >
      {/* NOW badge + title */}
      <div className="flex items-center gap-2 mb-2">
        <span
          style={{ background: 'var(--accent-red)', fontSize: '9px', letterSpacing: '0.05em' }}
          className="text-white font-bold px-1.5 py-0.5 rounded"
        >
          NOW
        </span>
        <span className="text-white font-semibold text-sm truncate flex-1">
          {current.title}
        </span>
      </div>

      {/* Progress bar */}
      <div
        style={{ background: 'rgba(255,255,255,0.08)', height: '4px' }}
        className="rounded-full overflow-hidden mb-2"
      >
        <div
          style={{
            width: `${progress}%`,
            background: 'var(--accent-blue)',
            height: '100%',
            transition: 'width 1s linear',
          }}
          className="rounded-full"
        />
      </div>

      {/* Footer row */}
      <div className="flex items-center justify-between">
        <span style={{ color: 'var(--text-muted)', fontSize: '11px' }}>
          Ends {formatLocalTime(current.end_time, tz)}
        </span>
        {next && (
          <span style={{ color: 'var(--text-muted)', fontSize: '11px' }} className="truncate max-w-[55%] text-right">
            Up Next:{' '}
            <span style={{ color: 'var(--text-secondary)' }}>{next.title}</span>
          </span>
        )}
      </div>
    </div>
  );
}
