export default function ProBadge({ className = '' }) {
  return (
    <span
      className={`inline-flex items-center px-1.5 py-0.5 rounded text-[10px] font-bold tracking-wider
        bg-gradient-to-r from-amber-400 to-yellow-300 text-amber-900 ${className}`}
    >
      PRO
    </span>
  );
}
