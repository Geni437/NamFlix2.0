'use client';

import { useEffect, useRef, useState } from 'react';
import GlobalNav from '@/components/GlobalNav';
import ChannelCard from '@/components/ChannelCard';
import { apiFetch } from '@/lib/api';

const STORAGE_KEY = 'namflix_recent_searches';

function getRecent() {
  if (typeof localStorage === 'undefined') return [];
  try { return JSON.parse(localStorage.getItem(STORAGE_KEY) || '[]'); }
  catch { return []; }
}

function saveRecent(term) {
  if (!term.trim() || typeof localStorage === 'undefined') return;
  const prev = getRecent().filter(t => t !== term);
  localStorage.setItem(STORAGE_KEY, JSON.stringify([term, ...prev].slice(0, 5)));
}

function clearRecent() {
  if (typeof localStorage !== 'undefined') localStorage.removeItem(STORAGE_KEY);
}

export default function SearchPage() {
  const [query, setQuery] = useState('');
  const [results, setResults] = useState([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const [recent, setRecent] = useState([]);
  const inputRef = useRef(null);
  const timer = useRef(null);

  useEffect(() => {
    setRecent(getRecent());
    inputRef.current?.focus();
  }, []);

  const doSearch = (term) => {
    if (!term.trim()) {
      setResults([]);
      setSearched(false);
      return;
    }
    setLoading(true);
    setSearched(true);
    apiFetch(`/search?q=${encodeURIComponent(term)}`).then(({ data }) => {
      setResults(data?.channels || data || []);
      setLoading(false);
      saveRecent(term);
      setRecent(getRecent());
    });
  };

  const handleChange = (e) => {
    const val = e.target.value;
    setQuery(val);
    clearTimeout(timer.current);
    timer.current = setTimeout(() => doSearch(val), 400);
  };

  const handleRecentClick = (term) => {
    setQuery(term);
    doSearch(term);
  };

  const handleClearRecent = () => {
    clearRecent();
    setRecent([]);
  };

  return (
    <>
      <GlobalNav />
      <main className="max-w-screen-xl mx-auto px-4 sm:px-6 py-8 pb-16">
        <h1 className="text-2xl font-bold text-white mb-6">Search</h1>

        {/* Search input */}
        <div className="relative max-w-2xl mb-8">
          <input
            ref={inputRef}
            type="search"
            value={query}
            onChange={handleChange}
            placeholder="Search channels, countries, categories…"
            className="input w-full pl-12 text-base"
            style={{ height: 52, fontSize: 16 }}
            aria-label="Search channels"
            autoComplete="off"
          />
          <svg className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-text-muted" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z" />
          </svg>
          {query && (
            <button
              onClick={() => { setQuery(''); setResults([]); setSearched(false); inputRef.current?.focus(); }}
              className="absolute right-3 top-1/2 -translate-y-1/2 text-text-muted hover:text-white p-1"
              aria-label="Clear search"
            >
              <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" d="M6 18 18 6M6 6l12 12" />
              </svg>
            </button>
          )}
        </div>

        {/* Recent searches */}
        {!searched && recent.length > 0 && (
          <div className="mb-8">
            <div className="flex items-center justify-between mb-3">
              <h2 className="text-sm font-semibold text-text-secondary uppercase tracking-wide">Recent Searches</h2>
              <button onClick={handleClearRecent} className="text-xs text-text-muted hover:text-white transition-colors">
                Clear
              </button>
            </div>
            <div className="flex flex-wrap gap-2">
              {recent.map(term => (
                <button
                  key={term}
                  onClick={() => handleRecentClick(term)}
                  className="flex items-center gap-2 px-3 py-2 bg-surface-2 border border-border rounded-lg text-sm text-text-secondary hover:text-white hover:border-border transition-all focus-visible:outline-2"
                  style={{ minHeight: 44 }}
                >
                  <svg className="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" d="M12 6v6h4.5m4.5 0a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" />
                  </svg>
                  {term}
                </button>
              ))}
            </div>
          </div>
        )}

        {/* Loading */}
        {loading && (
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4">
            {Array.from({ length: 12 }, (_, i) => (
              <div key={i} className="rounded-lg overflow-hidden border border-border">
                <div className="skeleton aspect-video" />
                <div className="p-3 bg-surface space-y-2">
                  <div className="skeleton h-3 w-4/5 rounded" />
                  <div className="skeleton h-3 w-1/2 rounded" />
                </div>
              </div>
            ))}
          </div>
        )}

        {/* Results */}
        {!loading && searched && (
          <>
            <div className="flex items-center justify-between mb-5">
              <p className="text-text-secondary text-sm">
                {results.length === 0
                  ? `No results for "${query}"`
                  : `${results.length} results for "${query}"`
                }
              </p>
            </div>

            {results.length === 0 ? (
              <div className="text-center py-20">
                <div className="text-6xl mb-6">📺</div>
                <p className="text-white text-xl font-semibold mb-2">No channels found</p>
                <p className="text-text-secondary">Try a different search term or browse by country</p>
              </div>
            ) : (
              <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4">
                {results.map(channel => (
                  <ChannelCard key={channel.id} channel={channel} />
                ))}
              </div>
            )}
          </>
        )}

        {/* Empty state */}
        {!searched && (
          <div className="text-center py-16">
            <div className="text-6xl mb-6">🔍</div>
            <p className="text-text-secondary text-lg">Search for channels worldwide</p>
          </div>
        )}
      </main>
    </>
  );
}
