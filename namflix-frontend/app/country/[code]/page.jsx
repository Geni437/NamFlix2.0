import CountryPageClient from './CountryPageClient';

export function generateStaticParams() {
  return [{ code: 'placeholder' }];
}

export default function CountryPage() {
  return <CountryPageClient />;
}
