'use client';

export default function LiveBadge({ size = 'sm' }) {
  const textSize = size === 'lg' ? 'text-sm px-3 py-1' : 'text-xs px-2 py-0.5';
  const dotSize = size === 'lg' ? 'w-2.5 h-2.5' : 'w-1.5 h-1.5';

  return (
    <span
      className={`inline-flex items-center gap-1.5 rounded font-bold uppercase tracking-wider bg-accent-red text-white ${textSize}`}
      aria-label="Live"
    >
      <span className={`${dotSize} rounded-full bg-white live-dot flex-shrink-0`} />
      LIVE
    </span>
  );
}
