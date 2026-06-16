'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { useAuth } from '@/context/AuthContext';

const navLinks = [
  { href: '/', label: 'Home' },
  { href: '/live/', label: 'Live TV' },
  { href: '/search/', label: 'Search' },
];

function Avatar({ email }) {
  const letter = (email || '?')[0].toUpperCase();
  return (
    <div className="w-8 h-8 rounded-full bg-accent-red flex items-center justify-center text-white text-sm font-bold flex-shrink-0">
      {letter}
    </div>
  );
}

export default function GlobalNav() {
  const { user, loading, signOut, openAuthModal } = useAuth();
  const pathname = usePathname();
  const [scrolled, setScrolled] = useState(false);
  const [mobileOpen, setMobileOpen] = useState(false);
  const [userMenuOpen, setUserMenuOpen] = useState(false);

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 10);
    window.addEventListener('scroll', onScroll, { passive: true });
    return () => window.removeEventListener('scroll', onScroll);
  }, []);

  useEffect(() => {
    setMobileOpen(false);
    setUserMenuOpen(false);
  }, [pathname]);

  const isActive = (href) => {
    if (href === '/') return pathname === '/';
    return pathname.startsWith(href.replace(/\/$/, ''));
  };

  return (
    <>
      <header
        className={`fixed top-0 inset-x-0 z-40 transition-all duration-200 ${
          scrolled || mobileOpen
            ? 'bg-surface/95 backdrop-blur border-b border-border'
            : 'bg-gradient-to-b from-bg/90 to-transparent'
        }`}
      >
        <nav className="max-w-screen-2xl mx-auto px-4 sm:px-6 flex items-center h-16">
          {/* Logo */}
          <Link
            href="/"
            className="text-2xl font-bold text-accent-red tracking-tight mr-8 flex-shrink-0 focus-visible:outline-2"
            aria-label="NamFlix Home"
          >
            NamFlix
          </Link>

          {/* Desktop nav */}
          <div className="hidden md:flex items-center gap-1 flex-1">
            {navLinks.map(({ href, label }) => (
              <Link
                key={href}
                href={href}
                className={`nav-link rounded ${isActive(href) ? 'text-white' : ''}`}
              >
                {label}
              </Link>
            ))}
          </div>

          {/* Right side */}
          <div className="flex items-center gap-3 ml-auto">
            {/* Search icon (mobile) */}
            <Link
              href="/search/"
              className="p-2.5 text-text-secondary hover:text-white transition-colors rounded focus-visible:outline-2"
              aria-label="Search"
              style={{ minHeight: 44, minWidth: 44, display: 'flex', alignItems: 'center', justifyContent: 'center' }}
            >
              <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z" />
              </svg>
            </Link>

            {/* Auth */}
            {!loading && (
              user ? (
                <div className="relative">
                  <button
                    onClick={() => setUserMenuOpen(o => !o)}
                    className="flex items-center gap-2 p-1 rounded-lg hover:bg-surface-2 transition-colors focus-visible:outline-2"
                    aria-label="User menu"
                    aria-expanded={userMenuOpen}
                    style={{ minHeight: 44 }}
                  >
                    <Avatar email={user.email} />
                    <svg className="w-4 h-4 text-text-secondary hidden sm:block" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
                      <path strokeLinecap="round" strokeLinejoin="round" d="m19.5 8.25-7.5 7.5-7.5-7.5" />
                    </svg>
                  </button>

                  {userMenuOpen && (
                    <>
                      <div className="fixed inset-0 z-10" onClick={() => setUserMenuOpen(false)} />
                      <div className="absolute right-0 top-full mt-2 w-52 bg-surface-2 border border-border rounded-xl py-1 shadow-xl z-20 animate-fade-in">
                        <div className="px-4 py-2.5 border-b border-border">
                          <p className="text-white text-sm font-medium truncate">{user.email}</p>
                        </div>
                        <Link href="/favorites/" className="flex items-center gap-2 px-4 py-2.5 text-sm text-text-secondary hover:text-white hover:bg-border transition-colors">
                          <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12Z" /></svg>
                          Favorites
                        </Link>
                        <Link href="/history/" className="flex items-center gap-2 px-4 py-2.5 text-sm text-text-secondary hover:text-white hover:bg-border transition-colors">
                          <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" d="M12 6v6h4.5m4.5 0a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" /></svg>
                          Watch History
                        </Link>
                        <div className="border-t border-border mt-1 pt-1">
                          <button
                            onClick={() => { signOut(); setUserMenuOpen(false); }}
                            className="w-full flex items-center gap-2 px-4 py-2.5 text-sm text-text-secondary hover:text-white hover:bg-border transition-colors text-left"
                          >
                            <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" d="M15.75 9V5.25A2.25 2.25 0 0 0 13.5 3h-6a2.25 2.25 0 0 0-2.25 2.25v13.5A2.25 2.25 0 0 0 7.5 21h6a2.25 2.25 0 0 0 2.25-2.25V15M12 9l-3 3m0 0 3 3m-3-3h12.75" /></svg>
                            Sign Out
                          </button>
                        </div>
                      </div>
                    </>
                  )}
                </div>
              ) : (
                <button
                  onClick={openAuthModal}
                  className="btn-primary text-sm px-4 py-2"
                  style={{ minHeight: 44 }}
                >
                  Sign In
                </button>
              )
            )}

            {/* Mobile hamburger */}
            <button
              onClick={() => setMobileOpen(o => !o)}
              className="md:hidden p-2.5 text-text-secondary hover:text-white transition-colors focus-visible:outline-2"
              aria-label={mobileOpen ? 'Close menu' : 'Open menu'}
              aria-expanded={mobileOpen}
              style={{ minHeight: 44, minWidth: 44, display: 'flex', alignItems: 'center', justifyContent: 'center' }}
            >
              <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
                {mobileOpen
                  ? <path strokeLinecap="round" strokeLinejoin="round" d="M6 18 18 6M6 6l12 12" />
                  : <path strokeLinecap="round" strokeLinejoin="round" d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5" />
                }
              </svg>
            </button>
          </div>
        </nav>

        {/* Mobile drawer */}
        {mobileOpen && (
          <div className="md:hidden border-t border-border bg-surface px-4 py-4 animate-fade-in">
            {navLinks.map(({ href, label }) => (
              <Link
                key={href}
                href={href}
                className={`flex items-center py-3 text-base font-medium border-b border-border last:border-0 ${
                  isActive(href) ? 'text-accent-red' : 'text-text-secondary'
                }`}
                style={{ minHeight: 48 }}
              >
                {label}
              </Link>
            ))}
            {user && (
              <>
                <Link href="/favorites/" className="flex items-center py-3 text-base font-medium text-text-secondary border-b border-border" style={{ minHeight: 48 }}>Favorites</Link>
                <Link href="/history/" className="flex items-center py-3 text-base font-medium text-text-secondary" style={{ minHeight: 48 }}>Watch History</Link>
              </>
            )}
          </div>
        )}
      </header>
      {/* Spacer */}
      <div className="h-16" />
    </>
  );
}
