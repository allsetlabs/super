# Pagination & Filtering Standards

All list views **must** use pagination. Rendering an unbounded list is forbidden.
Filters applied to a list **must** be reflected in URL query parameters so that the page state survives a browser refresh.

---

## Rules

### 1. Always paginate lists

Never fetch or render an entire collection at once. Choose one strategy:

| Strategy            | When to use                                                            |
| ------------------- | ---------------------------------------------------------------------- |
| **Infinite scroll** | Mobile-first or feed-style lists where the user scrolls naturally      |
| **Page numbers**    | Desktop tables or admin views where jumping to a specific page matters |

Default to **infinite scroll** for mobile (DevBot mobile, Seekr mobile).
Default to **page numbers** for desktop/web tables.

### 2. Persist filters in URL query params

Any filter, sort, or search state must live in `?key=value` query parameters — not in component `useState`. This ensures:

- Refresh keeps the user on the same filtered view
- Share/copy URL includes the current state
- Browser back/forward works correctly

Use `useSearchParams` (React Router) or `useRouter` / `usePathname` + `searchParams` (Next.js).

### 3. Filters must never be disabled based on current results

Filter buttons must always be clickable. A filter showing zero results is valid feedback — disabling buttons traps users when a non-default filter returns empty data.

---

## Infinite Scroll Pattern (React + IntersectionObserver)

```tsx
const PAGE_SIZE = 30;

// ── Derive filter from URL ──────────────────────────────────────────────────
const [searchParams, setSearchParams] = useSearchParams();
const rawFilter = searchParams.get('filter');
const filter: FilterType =
  rawFilter && VALID_FILTERS.includes(rawFilter as FilterType) ? (rawFilter as FilterType) : 'all';

const setFilter = (f: FilterType) =>
  setSearchParams(f === 'all' ? {} : { filter: f }, { replace: true });

// ── State ───────────────────────────────────────────────────────────────────
const [items, setItems] = useState<Item[]>([]);
const [loading, setLoading] = useState(true);
const [loadingMore, setLoadingMore] = useState(false);
const [hasMore, setHasMore] = useState(true);
const [offset, setOffset] = useState(0);
const sentinelRef = useRef<HTMLDivElement | null>(null);

// ── Fetch page ──────────────────────────────────────────────────────────────
const fetchPage = useCallback(
  async (pageOffset: number, replace: boolean) => {
    try {
      if (replace) setLoading(true);
      else setLoadingMore(true);
      const data = await api.listItems(
        filter === 'all' ? undefined : filter,
        PAGE_SIZE,
        pageOffset
      );
      setItems((prev) => (replace ? data : [...prev, ...data]));
      setHasMore(data.length === PAGE_SIZE);
      setOffset(pageOffset + data.length);
    } finally {
      if (replace) setLoading(false);
      else setLoadingMore(false);
    }
  },
  [filter]
);

// ── Reset on filter change ──────────────────────────────────────────────────
useEffect(() => {
  setItems([]);
  setOffset(0);
  setHasMore(true);
  fetchPage(0, true);
}, [filter]); // fetchPage intentionally excluded to avoid double-fetch on mount

// ── IntersectionObserver triggers next page ─────────────────────────────────
useEffect(() => {
  const sentinel = sentinelRef.current;
  if (!sentinel) return;
  const observer = new IntersectionObserver(
    (entries) => {
      if (entries[0].isIntersecting && hasMore && !loading && !loadingMore) {
        fetchPage(offset, false);
      }
    },
    { threshold: 0.1 }
  );
  observer.observe(sentinel);
  return () => observer.disconnect();
}, [hasMore, loading, loadingMore, offset, fetchPage]);
```

### Rendering

```tsx
<main className="flex-1 overflow-y-auto">
  {loading && <LoadingSpinner />}
  {!loading && items.length === 0 && <EmptyState />}
  {items.map((item) => (
    <ItemCard key={item.id} item={item} />
  ))}

  {/* Sentinel — always rendered after items */}
  <div ref={sentinelRef} className="h-4" />
  {loadingMore && <span className="text-muted-foreground text-sm">Loading more…</span>}
</main>
```

### Filter bar

```tsx
{
  /* Filters are NEVER disabled */
}
<div className="flex gap-2">
  {VALID_FILTERS.map((f) => (
    <Button
      key={f}
      size="sm"
      variant={filter === f ? 'default' : 'outline'}
      onClick={() => setFilter(f)}
    >
      {f}
    </Button>
  ))}
</div>;
```

---

## Backend API Convention

List endpoints must accept `limit`, `offset`, and any filter params:

```
GET /api/resource?limit=30&offset=0&type=feeding
```

Sub-type filters on a shared `type` column (e.g., `wet`/`poop` both map to `log_type = 'diaper'`) must be resolved in the backend — never via client-side array filtering:

```ts
if (type === 'wet') {
  query = query.eq('log_type', 'diaper').not('diaper_wet_pct', 'is', null);
} else if (type === 'poop') {
  query = query.eq('log_type', 'diaper').not('diaper_poop', 'is', null);
}
```

---

## Anti-patterns (Forbidden)

```tsx
// ❌ Fetch everything, filter on client
const data = await api.listItems(undefined, 9999);
const filtered = data.filter((item) => item.type === filter);

// ❌ Filter state in useState (not in URL)
const [filter, setFilter] = useState('all');

// ❌ Disabled filter buttons
<Button disabled={items.length === 0}>Feeding</Button>;

// ❌ No pagination — rendering raw array
{
  items.map((item) => <Row key={item.id} item={item} />);
}
// (only ok if items is already a paginated page slice)
```
