import { Inter } from 'next/font/google';
import './globals.css';
import { AuthProvider } from '@/context/AuthContext';
import { LocaleProvider } from '@/context/LocaleContext';
import AuthModal from '@/components/AuthModal';

const inter = Inter({
  subsets: ['latin'],
  variable: '--font-inter',
  display: 'swap',
});

export const metadata = {
  title: {
    default: 'NamFlix — Live TV Streaming',
    template: '%s | NamFlix',
  },
  description: 'Watch thousands of live TV channels from around the world for free.',
  keywords: ['live tv', 'iptv', 'streaming', 'free tv', 'global channels'],
  openGraph: {
    title: 'NamFlix — Live TV Streaming',
    description: 'Watch thousands of live TV channels from around the world.',
    type: 'website',
  },
};

export default function RootLayout({ children }) {
  return (
    <html lang="en" className={inter.variable}>
      <head>
        <meta name="theme-color" content="#08080F" />
        <link rel="icon" href="/favicon.ico" />
      </head>
      <body className="bg-bg text-white antialiased">
        <LocaleProvider>
          <AuthProvider>
            {children}
            <AuthModal />
          </AuthProvider>
        </LocaleProvider>
      </body>
    </html>
  );
}
