'use client';

import { useEffect, useRef, useState } from 'react';
import { apiFetch } from '@/lib/api';

const SORT_OPTIONS = [
  { value: 'name_asc', label: 'Name A–Z' },
  { value: 'popular', label: 'Most Popular' },
  { value: 'country', label: 'By Country' },
];

export default function FilterPanel({ filters, onChange }) {
  const [countries, setCountries] = useState([]);
  const [languages, setLanguages] = useState([]);
  const [categories, setCategories] = useState([]);
  const [mobileOpen, setMobileOpen] = useState(false);
  const searchTimer = useRef(null);

  useEffect(() => {
    apiFetch('/countries').then(({ data }) => setCountries(data?.data || []));
    apiFetch('/languages').then(({ data }) => setLanguages(data?.data || []));
    apiFetch('/categories').then(({ data }) => setCategories(data?.data || []));
  }, []);

  const handleSearch = (val) => {
    clearTimeout(searchTimer.current);
    searchTimer.current = setTimeout(() => onChange({ search: val, page: 1 }), 400);
  };

  const toggleCategory = (id) => {
    const current = filters.categories || [];
    const next = current.includes(id)
      ? current.filter(c => c !== id)
      : [...current, id];
    onChange({ categories: next, page: 1 });
  };

  const reset = () => {
    onChange({ search: '', country: '', language: '', categories: [], live_only: false, quality: '', sort: 'name_asc', page: 1 });
  };

  const hasFilters = filters.search || filters.country || filters.language ||
    (filters.categories?.length) || filters.live_only || filters.quality;

  const panel = (
    <div className="flex flex-col gap-5 h-full">
      {/* Search */}
      <div>
        <label className="block text-xs text-text-secondary font-semibold uppercase tracking-wide mb-2">Search</label>
        <div className="relative">
          <input
            type="text"
            defaultValue={filters.search || ''}
            onChange={e => handleSearch(e.target.value)}
            placeholder="Channel name..."
            className="input w-full pl-9"
            aria-label="Search channels"
          />
          <svg className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-text-muted" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z" />
          </svg>
        </div>
      </div>

      {/* Country */}
      <div>
        <label className="block text-xs text-text-secondary font-semibold uppercase tracking-wide mb-2">Country</label>
        <select
          value={filters.country || ''}
          onChange={e => onChange({ country: e.target.value, page: 1 })}
          className="input w-full"
          aria-label="Filter by country"
        >
          <option value="">All Countries</option>
          {countries.map(c => (
            <option key={c.code} value={c.code}>{c.name}</option>
          ))}
        </select>
      </div>

      {/* Language */}
      <div>
        <label className="block text-xs text-text-secondary font-semibold uppercase tracking-wide mb-2">Language</label>
        <select
          value={filters.language || ''}
          onChange={e => onChange({ language: e.target.value, page: 1 })}
          className="input w-full"
          aria-label="Filter by language"
        >
          <option value="">All Languages</option>
          {languages.map(l => (
            <option key={l.code} value={l.code}>{l.name}</option>
          ))}
        </select>
      </div>

      {/* Categories */}
      <div>
        <label className="block text-xs text-text-secondary font-semibold uppercase tracking-wide mb-2">Categories</label>
        <div className="flex flex-wrap gap-2">
          {categories.slice(0, 16).map(cat => {
            const active = (filters.categories || []).includes(cat.id);
            return (
              <button
                key={cat.id}
                onClick={() => toggleCategory(cat.id)}
                className={`px-3 py-1.5 rounded text-xs font-semibold border transition-all focus-visible:outline-2 ${
                  active
                    ? 'bg-accent-red border-accent-red text-white'
                    : 'bg-surface-2 border-border text-text-secondary hover:border-text-secondary hover:text-white'
                }`}
                style={{ minHeight: 36 }}
                aria-pressed={active}
              >
                {cat.name}
              </button>
            );
          })}
        </div>
      </div>

      {/* Quality */}
      <div>
        <label className="block text-xs text-text-secondary font-semibold uppercase tracking-wide mb-2">Quality</label>
        <select
          value={filters.quality || ''}
          onChange={e => onChange({ quality: e.target.value, page: 1 })}
          className="input w-full"
          aria-label="Filter by quality"
        >
          <option value="">All Quality</option>
          <option value="HD">HD</option>
          <option value="SD">SD</option>
        </select>
      </div>

      {/* Sort */}
      <div>
        <label className="block text-xs text-text-secondary font-semibold uppercase tracking-wide mb-2">Sort By</label>
        <select
          value={filters.sort || 'name_asc'}
          onChange={e => onChange({ sort: e.target.value, page: 1 })}
          className="input w-full"
          aria-label="Sort channels"
        >
          {SORT_OPTIONS.map(o => (
            <option key={o.value} value={o.value}>{o.label}</option>
          ))}
        </select>
      </div>

      {/* Live only toggle */}
      <label className="flex items-center gap-3 cursor-pointer" style={{ minHeight: 44 }}>
        <div
          className={`relative w-11 h-6 rounded-full transition-colors ${filters.live_only ? 'bg-accent-red' : 'bg-border'}`}
          onClick={() => onChange({ live_only: !filters.live_only, page: 1 })}
          role="switch"
          aria-checked={!!filters.live_only}
          tabIndex={0}
          onKeyDown={e => e.key === 'Enter' && onChange({ live_only: !filters.live_only, page: 1 })}
        >
          <span className={`absolute top-0.5 left-0.5 w-5 h-5 rounded-full bg-white shadow transition-transform ${filters.live_only ? 'translate-x-5' : ''}`} />
        </div>
        <span className="text-sm text-text-secondary font-medium">Live Only</span>
      </label>

      {/* Reset */}
      {hasFilters && (
        <button
          onClick={reset}
          className="btn-ghost w-full text-sm mt-auto"
        >
          Reset Filters
        </button>
      )}
    </div>
  );

  return (
    <>
      {/* Desktop sidebar */}
      <aside className="hidden lg:flex flex-col w-64 flex-shrink-0 sticky top-20 self-start max-h-[calc(100vh-5rem)] overflow-y-auto scrollbar-hide pb-8">
        <div className="bg-surface border border-border rounded-xl p-5">
          {panel}
        </div>
      </aside>

      {/* Mobile: filter button + bottom sheet */}
      <div className="lg:hidden">
        <button
          onClick={() => setMobileOpen(true)}
          className="btn-secondary flex items-center gap-2 text-sm"
          aria-label="Open filters"
        >
          <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" d="M10.5 6h9.75M10.5 6a1.5 1.5 0 1 1-3 0m3 0a1.5 1.5 0 1 0-3 0M3.75 6H7.5m3 12h9.75m-9.75 0a1.5 1.5 0 0 1-3 0m3 0a1.5 1.5 0 0 0-3 0m-3.75 0H7.5m9-6h3.75m-3.75 0a1.5 1.5 0 0 1-3 0m3 0a1.5 1.5 0 0 0-3 0m-9.75 0h9.75" />
          </svg>
          Filters
          {hasFilters && <span className="w-2 h-2 rounded-full bg-accent-red" />}
        </button>

        {mobileOpen && (
          <>
            <div
              className="fixed inset-0 z-40 bg-black/70"
              onClick={() => setMobileOpen(false)}
              aria-hidden="true"
            />
            <div className="fixed bottom-0 inset-x-0 z-50 bg-surface border-t border-border rounded-t-2xl p-5 animate-slide-up max-h-[85vh] overflow-y-auto">
              <div className="flex items-center justify-between mb-5">
                <h2 className="text-white font-bold text-lg">Filters</h2>
                <button
                  onClick={() => setMobileOpen(false)}
                  className="text-text-secondary hover:text-white p-2"
                  aria-label="Close filters"
                >
                  <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" d="M6 18 18 6M6 6l12 12" />
                  </svg>
                </button>
              </div>
              {panel}
              <button
                onClick={() => setMobileOpen(false)}
                className="btn-primary w-full mt-5"
              >
                Show Results
              </button>
            </div>
          </>
        )}
      </div>
    </>
  );
}
