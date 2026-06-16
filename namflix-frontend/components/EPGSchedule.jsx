'use client';

import { useEffect, useRef, useState } from 'react';
import { apiFetch } from '@/lib/api';

function formatTime(isoStr, tz) {
  if (!isoStr) return '';
  return new Intl.DateTimeFormat(undefined, {
    hour: '2-digit',
    minute: '2-digit',
    timeZone: tz,
  }).format(new Date(isoStr));
}

function durationMins(start, end) {
  const diff = (new Date(end).getTime() - new Date(start).getTime()) / 60000;
  const h = Math.floor(diff / 60);
  const m = Math.round(diff % 60);
  return h > 0 ? `${h}h ${m}m` : `${m}m`;
}

export default function EPGSchedule({ channelId, date }) {
  const [programs, setPrograms]   = useState([]);
  const [loading, setLoading]     = useState(true);
  const [collapsed, setCollapsed] = useState(false);
  const tzRef = useRef(Intl.DateTimeFormat().resolvedOptions().timeZone);
  const currentRef = useRef(null);

  useEffect(() => {
    if (!channelId) return;
    setLoading(true);

    const tz      = tzRef.current;
    const dateStr = date ?? new Date().toISOString().slice(0, 10);

    apiFetch(
      `/epg/${channelId}?date=${dateStr}&timezone=${encodeURIComponent(tz)}`
    ).then((res) => {
      setPrograms(res?.data?.programs ?? []);
    }).catch(() => {
      setPrograms([]);
    }).finally(() => {
      setLoading(false);
    });
  }, [channelId, date]);

  // Scroll to current program after render
  useEffect(() => {
    if (!loading && currentRef.current) {
      currentRef.current.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }
  }, [loading]);

  if (loading) {
    return (
      <div style={{ background: 'var(--surface)', borderRadius: '8px', padding: '16px' }}>
        <div style={{ color: 'var(--text-muted)', fontSize: '13px' }}>Loading schedule…</div>
      </div>
    );
  }

  const tz = tzRef.current;

  return (
    <div style={{ background: 'var(--surface)', borderRadius: '8px', border: '1px solid var(--border)' }}>
      {/* Header */}
      <button
        onClick={() => setCollapsed((c) => !c)}
        style={{
          width: '100%',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          padding: '14px 16px',
          background: 'transparent',
          border: 'none',
          cursor: 'pointer',
          borderBottom: collapsed ? 'none' : '1px solid var(--border)',
        }}
      >
        <span style={{ color: 'var(--text-primary)', fontSize: '14px', fontWeight: 700 }}>
          Today&apos;s Schedule
        </span>
        <span style={{ color: 'var(--text-muted)', fontSize: '18px', lineHeight: 1 }}>
          {collapsed ? '›' : '‹'}
        </span>
      </button>

      {!collapsed && (
        <div style={{ maxHeight: '400px', overflowY: 'auto' }}>
          {programs.length === 0 ? (
            <div
              style={{ padding: '32px 16px', textAlign: 'center', color: 'var(--text-muted)', fontSize: '13px' }}
            >
              Program guide not available
            </div>
          ) : (
            programs.map((program) => {
              const isPast    = !program.is_current && new Date(program.end_time) < new Date();
              const isCurrent = program.is_current;

              return (
                <div
                  key={program.id}
                  ref={isCurrent ? currentRef : null}
                  style={{
                    display: 'flex',
                    alignItems: 'flex-start',
                    gap: '12px',
                    padding: '10px 16px',
                    borderBottom: '1px solid var(--border)',
                    opacity: isPast ? 0.5 : 1,
                    background: isCurrent ? 'rgba(0,194,255,0.06)' : 'transparent',
                    borderLeft: isCurrent ? '3px solid var(--accent-blue)' : '3px solid transparent',
                    position: 'relative',
                  }}
                >
                  {/* Time column */}
                  <span
                    style={{
                      color: isCurrent ? 'var(--accent-blue)' : 'var(--text-muted)',
                      fontSize: '11px',
                      fontWeight: 600,
                      minWidth: '40px',
                      paddingTop: '2px',
                    }}
                  >
                    {formatTime(program.start_time, tz)}
                  </span>

                  {/* Title + category */}
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div
                      style={{
                        color: 'var(--text-primary)',
                        fontSize: '13px',
                        fontWeight: isCurrent ? 600 : 400,
                        overflow: 'hidden',
                        textOverflow: 'ellipsis',
                        whiteSpace: 'nowrap',
                      }}
                    >
                      {program.title}
                    </div>
                    {program.category && (
                      <span
                        style={{
                          display: 'inline-block',
                          marginTop: '3px',
                          padding: '1px 6px',
                          background: 'var(--surface-2)',
                          borderRadius: '3px',
                          fontSize: '10px',
                          color: 'var(--text-muted)',
                        }}
                      >
                        {program.category}
                      </span>
                    )}
                    {isCurrent && (
                      <div
                        style={{
                          marginTop: '6px',
                          height: '3px',
                          background: 'var(--surface-2)',
                          borderRadius: '2px',
                          overflow: 'hidden',
                        }}
                      >
                        <div
                          style={{
                            width: `${program.progress_percent}%`,
                            height: '100%',
                            background: 'var(--accent-blue)',
                            transition: 'width 1s linear',
                          }}
                        />
                      </div>
                    )}
                  </div>

                  {/* Duration */}
                  <span
                    style={{
                      color: 'var(--text-muted)',
                      fontSize: '11px',
                      whiteSpace: 'nowrap',
                      paddingTop: '2px',
                    }}
                  >
                    {durationMins(program.start_time, program.end_time)}
                  </span>
                </div>
              );
            })
          )}
        </div>
      )}
    </div>
  );
}
