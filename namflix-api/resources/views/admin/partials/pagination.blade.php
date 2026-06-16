@if ($paginator->hasPages())
<div style="display:flex;gap:4px;align-items:center;padding-top:16px;flex-wrap:wrap;">
    @if ($paginator->onFirstPage())
        <span style="padding:6px 12px;border-radius:6px;font-size:0.8rem;color:#555570;background:#1a1a24;border:1px solid rgba(255,255,255,0.07);">←</span>
    @else
        <a href="{{ $paginator->previousPageUrl() }}" style="padding:6px 12px;border-radius:6px;font-size:0.8rem;color:#A0A0B0;background:#1a1a24;border:1px solid rgba(255,255,255,0.07);text-decoration:none;">←</a>
    @endif

    @for ($i = max(1, $paginator->currentPage() - 2); $i <= min($paginator->lastPage(), $paginator->currentPage() + 2); $i++)
        @if ($i == $paginator->currentPage())
            <span style="padding:6px 12px;border-radius:6px;font-size:0.8rem;background:#E50914;color:#fff;border:1px solid #E50914;">{{ $i }}</span>
        @else
            <a href="{{ $paginator->url($i) }}" style="padding:6px 12px;border-radius:6px;font-size:0.8rem;color:#A0A0B0;background:#1a1a24;border:1px solid rgba(255,255,255,0.07);text-decoration:none;">{{ $i }}</a>
        @endif
    @endfor

    @if ($paginator->hasMorePages())
        <a href="{{ $paginator->nextPageUrl() }}" style="padding:6px 12px;border-radius:6px;font-size:0.8rem;color:#A0A0B0;background:#1a1a24;border:1px solid rgba(255,255,255,0.07);text-decoration:none;">→</a>
    @else
        <span style="padding:6px 12px;border-radius:6px;font-size:0.8rem;color:#555570;background:#1a1a24;border:1px solid rgba(255,255,255,0.07);">→</span>
    @endif

    <span style="font-size:0.78rem;color:#A0A0B0;margin-left:8px;">
        {{ number_format($paginator->firstItem()) }}–{{ number_format($paginator->lastItem()) }} of {{ number_format($paginator->total()) }}
    </span>
</div>
@endif
