import CategoryPageClient from './CategoryPageClient';

export function generateStaticParams() {
  return [{ id: 'placeholder' }];
}

export default function CategoryPage() {
  return <CategoryPageClient />;
}
