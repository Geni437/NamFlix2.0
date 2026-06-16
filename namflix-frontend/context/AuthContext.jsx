'use client';

import { createContext, useContext, useEffect, useState, useCallback } from 'react';
import { supabase } from '@/lib/supabase';
import { setSession } from '@/lib/api';

const AuthContext = createContext({
  user: null,
  session: null,
  loading: true,
  signOut: async () => {},
  openAuthModal: () => {},
  closeAuthModal: () => {},
  authModalOpen: false,
});

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [session, setSessionState] = useState(null);
  const [loading, setLoading] = useState(true);
  const [authModalOpen, setAuthModalOpen] = useState(false);

  useEffect(() => {
    supabase.auth.getSession().then(({ data: { session } }) => {
      setSessionState(session);
      setUser(session?.user ?? null);
      setSession(session);
      setLoading(false);
    });

    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      setSessionState(session);
      setUser(session?.user ?? null);
      setSession(session);
      if (session) setAuthModalOpen(false);
    });

    return () => subscription.unsubscribe();
  }, []);

  const signOut = useCallback(async () => {
    await supabase.auth.signOut();
  }, []);

  const openAuthModal = useCallback(() => setAuthModalOpen(true), []);
  const closeAuthModal = useCallback(() => setAuthModalOpen(false), []);

  return (
    <AuthContext.Provider value={{ user, session, loading, signOut, openAuthModal, closeAuthModal, authModalOpen }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  return useContext(AuthContext);
}
