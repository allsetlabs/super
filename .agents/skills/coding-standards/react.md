# Clean Code Examples for React

Practical examples of clean code principles applied to React development.

## Table of Contents

1. [Component Examples](#component-examples)
2. [Hooks Examples](#hooks-examples)
3. [API Integration Examples](#api-integration-examples)
4. [State Management Examples](#state-management-examples)
5. [Common Anti-Patterns to Avoid](#common-anti-patterns-to-avoid)
   - [Prop Drilling](#anti-pattern-1-prop-drilling)
   - [Massive Components](#anti-pattern-2-massive-components)
   - [Ignoring Loading and Error States](#anti-pattern-3-ignoring-loading-and-error-states)
   - [Using window.history.pushState for URL Updates](#anti-pattern-4-using-windowhistorypushstate-for-url-updates)
   - [Using Default Tailwind Colors](#anti-pattern-5-using-default-tailwind-colors)
   - [Inconsistent Theme Implementation](#anti-pattern-6-inconsistent-theme-implementation)
   - [Dialogs Inside Loops](#anti-pattern-7-dialogs-inside-loops)

---

## Component Examples

### Example 1: Extracting Complex Logic

**Bad:**

```tsx
export const UserProfile = ({ userId }: { userId: string }) => {
  const { data: user, isLoading, error } = useUser(userId);

  // All logic mixed in one component
  if (isLoading) {
    return (
      <div className="animate-pulse bg-neutral-50 p-4 dark:bg-neutral-900">
        <div className="mb-2 h-6 w-1/3 rounded bg-neutral-200 dark:bg-neutral-800" />
        <div className="h-4 w-1/2 rounded bg-neutral-200 dark:bg-neutral-800" />
      </div>
    );
  }

  if (error) {
    return (
      <div className="rounded-lg border border-red-300 bg-red-50 p-4 dark:border-red-700 dark:bg-red-900/20">
        <p className="text-red-800 dark:text-red-200">Error: {error.message}</p>
      </div>
    );
  }

  if (!user) return <div>No user found</div>;

  return (
    <div className="bg-neutral-50 p-4 dark:bg-neutral-900">
      <h2 className="text-xl font-bold text-neutral-900 dark:text-neutral-100">{user.name}</h2>
      <p className="text-neutral-600 dark:text-neutral-400">{user.email}</p>
    </div>
  );
};
```

**Good:**

```tsx
// Custom hook for data fetching
function useUser(userId: string) {
  return useQuery({
    queryKey: ['users', userId],
    queryFn: async () => {
      const response = await fetch(`/api/users/${userId}`);
      if (!response.ok) {
        throw new Error('Failed to fetch user');
      }
      return response.json();
    },
  });
}

// Separate loading component
const UserProfileSkeleton = () => (
  <div className="animate-pulse bg-neutral-50 p-4 dark:bg-neutral-900">
    <div className="mb-2 h-6 w-1/3 rounded bg-neutral-200 dark:bg-neutral-800" />
    <div className="h-4 w-1/2 rounded bg-neutral-200 dark:bg-neutral-800" />
  </div>
);

// Separate error component
const UserProfileError = ({ error }: { error: Error }) => (
  <div className="rounded-lg border border-red-300 bg-red-50 p-4 dark:border-red-700 dark:bg-red-900/20">
    <p className="text-red-800 dark:text-red-200">Error: {error.message}</p>
  </div>
);

// Main component - clean and focused
export const UserProfile = ({ userId }: { userId: string }) => {
  const { data: user, isLoading, error } = useUser(userId);

  if (isLoading) return <UserProfileSkeleton />;
  if (error) return <UserProfileError error={error} />;
  if (!user) return null;

  return (
    <div className="rounded-lg border border-neutral-300 bg-neutral-50 p-4 dark:border-neutral-700 dark:bg-neutral-900">
      <h2 className="mb-2 text-xl font-bold text-neutral-900 dark:text-neutral-100">{user.name}</h2>
      <p className="text-neutral-600 dark:text-neutral-400">{user.email}</p>
    </div>
  );
};
```

### Example 2: Component Composition

**Bad:**

```tsx
export const Dashboard = () => {
  const [users, setUsers] = useState<User[]>([]);
  const [posts, setPosts] = useState<Post[]>([]);
  const [comments, setComments] = useState<Comment[]>([]);

  return (
    <div className="p-6">
      <div className="mb-6">
        <h2 className="mb-4 text-2xl font-bold">Users</h2>
        {users.map((user) => (
          <div key={user.id} className="mb-2 bg-neutral-50 p-4 dark:bg-neutral-900">
            <p>{user.name}</p>
            <p>{user.email}</p>
          </div>
        ))}
      </div>

      <div className="mb-6">
        <h2 className="mb-4 text-2xl font-bold">Posts</h2>
        {posts.map((post) => (
          <div key={post.id} className="mb-2 bg-neutral-50 p-4 dark:bg-neutral-900">
            <h3>{post.title}</h3>
            <p>{post.content}</p>
          </div>
        ))}
      </div>

      <div className="mb-6">
        <h2 className="mb-4 text-2xl font-bold">Comments</h2>
        {comments.map((comment) => (
          <div key={comment.id} className="mb-2 bg-neutral-50 p-4 dark:bg-neutral-900">
            <p>{comment.text}</p>
          </div>
        ))}
      </div>
    </div>
  );
};
```

**Good:**

```tsx
// Separate components with single responsibility
const UserCard = ({ user }: { user: User }) => (
  <div className="mb-2 rounded-lg border border-neutral-300 bg-neutral-50 p-4 dark:border-neutral-700 dark:bg-neutral-900">
    <p className="font-semibold text-neutral-900 dark:text-neutral-100">{user.name}</p>
    <p className="text-neutral-600 dark:text-neutral-400">{user.email}</p>
  </div>
);

const PostCard = ({ post }: { post: Post }) => (
  <div className="mb-2 rounded-lg border border-neutral-300 bg-neutral-50 p-4 dark:border-neutral-700 dark:bg-neutral-900">
    <h3 className="mb-2 font-bold text-neutral-900 dark:text-neutral-100">{post.title}</h3>
    <p className="text-neutral-700 dark:text-neutral-300">{post.content}</p>
  </div>
);

const CommentCard = ({ comment }: { comment: Comment }) => (
  <div className="mb-2 rounded-lg border border-neutral-300 bg-neutral-50 p-4 dark:border-neutral-700 dark:bg-neutral-900">
    <p className="text-neutral-700 dark:text-neutral-300">{comment.text}</p>
  </div>
);

// Generic section component
interface SectionProps<T> {
  title: string;
  items: T[];
  renderItem: (item: T) => React.ReactNode;
}

const Section = <T extends { id: string }>({ title, items, renderItem }: SectionProps<T>) => (
  <div className="mb-6">
    <h2 className="mb-4 text-2xl font-bold text-neutral-900 dark:text-neutral-100">{title}</h2>
    {items.map((item) => (
      <React.Fragment key={item.id}>{renderItem(item)}</React.Fragment>
    ))}
  </div>
);

// Clean dashboard component
export const Dashboard = () => {
  const { data: users = [] } = useUsers();
  const { data: posts = [] } = usePosts();
  const { data: comments = [] } = useComments();

  return (
    <div className="p-6">
      <Section title="Users" items={users} renderItem={(user) => <UserCard user={user} />} />
      <Section title="Posts" items={posts} renderItem={(post) => <PostCard post={post} />} />
      <Section
        title="Comments"
        items={comments}
        renderItem={(comment) => <CommentCard comment={comment} />}
      />
    </div>
  );
};
```

---

## Hooks Examples

### Example 1: Custom Hook with Single Responsibility

**Bad:**

```tsx
// Hook doing too many things - violates single responsibility
function useUserData(userId: string) {
  const { data: user } = useUser(userId);
  const { data: posts } = useUserPosts(userId);
  const [theme, setTheme] = useState<'light' | 'dark'>('light');

  const toggleTheme = () => {
    setTheme((prev) => (prev === 'light' ? 'dark' : 'light'));
  };

  // Mixing data fetching with UI state management
  return { user, posts, theme, toggleTheme };
}
```

**Good:**

```tsx
// Separate hooks with single responsibility
function useUser(userId: string) {
  return useQuery({
    queryKey: ['users', userId],
    queryFn: () => fetchUser(userId),
  });
}

function useUserPosts(userId: string) {
  return useQuery({
    queryKey: ['users', userId, 'posts'],
    queryFn: () => fetchUserPosts(userId),
  });
}

function useTheme() {
  const [theme, setTheme] = useLocalStorage<'light' | 'dark'>('theme', 'light');

  const toggleTheme = useCallback(() => {
    setTheme((prev) => (prev === 'light' ? 'dark' : 'light'));
  }, [setTheme]);

  return { theme, toggleTheme };
}

// Usage in component
const UserProfile = ({ userId }: { userId: string }) => {
  const { data: user, isLoading: userLoading } = useUser(userId);
  const { data: posts, isLoading: postsLoading } = useUserPosts(userId);
  const { theme, toggleTheme } = useTheme();

  // Clean separation of concerns
};
```

### Example 2: Avoiding Unnecessary Re-renders

**Bad:**

```tsx
const ParentComponent = () => {
  const [count, setCount] = useState(0);

  return (
    <div>
      <button onClick={() => setCount(count + 1)}>Increment</button>
      <ExpensiveChild data={someData} onUpdate={(val) => console.log(val)} />
    </div>
  );
};
```

**Good:**

```tsx
const ParentComponent = () => {
  const [count, setCount] = useState(0);

  // Memoize callback to prevent re-renders
  const handleUpdate = useCallback((val: string) => {
    console.log(val);
  }, []);

  // Memoize expensive child
  const memoizedChild = useMemo(
    () => <ExpensiveChild data={someData} onUpdate={handleUpdate} />,
    [someData, handleUpdate]
  );

  return (
    <div>
      <button
        onClick={() => setCount(count + 1)}
        className="bg-primary-500 hover:bg-primary-600 rounded-md px-4 py-2 text-white"
      >
        Increment: {count}
      </button>
      {memoizedChild}
    </div>
  );
};

// Or use React.memo
const ExpensiveChild = React.memo(({ data, onUpdate }: Props) => {
  // Component only re-renders when props change
  return <div>{/* ... */}</div>;
});
```

---

## API Integration Examples

### Example 1: Organized API Layer

**Bad:**

```tsx
// Direct API calls in components without abstraction
const UserList = () => {
  const { data: users = [], isLoading } = useQuery({
    queryKey: ['users'],
    queryFn: async () => {
      const response = await fetch('/api/users');
      return response.json();
    },
  });

  const deleteUser = useMutation({
    mutationFn: async (id: string) => {
      await fetch(`/api/users/${id}`, { method: 'DELETE' });
    },
  });

  // API logic scattered in component - hard to reuse
  // ...
};
```

**Good:**

```tsx
// api/client.ts
export const apiClient = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// api/services/users.ts
export const usersApi = {
  getAll: () => apiClient.get<User[]>('/users'),
  getById: (id: string) => apiClient.get<User>(`/users/${id}`),
  create: (data: CreateUserDto) => apiClient.post<User>('/users', data),
  update: (id: string, data: UpdateUserDto) => apiClient.put<User>(`/users/${id}`, data),
  delete: (id: string) => apiClient.delete(`/users/${id}`),
};

// api/hooks/useUsers.ts
export function useUsers() {
  return useQuery({
    queryKey: ['users'],
    queryFn: async () => {
      const { data } = await usersApi.getAll();
      return data;
    },
  });
}

export function useDeleteUser() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (id: string) => usersApi.delete(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] });
    },
  });
}

// Component - clean and simple
const UserList = () => {
  const { data: users = [], isLoading } = useUsers();
  const deleteUser = useDeleteUser();

  if (isLoading) return <Skeleton />;

  return (
    <div>
      {users.map((user) => (
        <UserCard key={user.id} user={user} onDelete={() => deleteUser.mutate(user.id)} />
      ))}
    </div>
  );
};
```

---

## State Management Examples

### Example 1: Local vs Global State

**Bad:**

```tsx
// Using global state for everything
const globalStore = create((set) => ({
  users: [],
  selectedUser: null,
  modalOpen: false,
  searchQuery: '',
  // Everything in global state
}));
```

**Good:**

```tsx
// Global state only for truly global data
const useAuthStore = create<AuthState>((set) => ({
  user: null,
  isAuthenticated: false,
  login: (user) => set({ user, isAuthenticated: true }),
  logout: () => set({ user: null, isAuthenticated: false }),
}));

// Component-level state for local UI concerns
const UserSearch = () => {
  const [searchQuery, setSearchQuery] = useState('');
  const [modalOpen, setModalOpen] = useState(false);
  const { data: users } = useUsers();

  const filteredUsers = useMemo(
    () => users?.filter((u) => u.name.includes(searchQuery)) ?? [],
    [users, searchQuery]
  );

  return (
    <>
      <input
        value={searchQuery}
        onChange={(e) => setSearchQuery(e.target.value)}
        className="rounded-md border border-neutral-300 px-4 py-2 dark:border-neutral-700"
      />
      <UserList users={filteredUsers} onUserClick={() => setModalOpen(true)} />
      {modalOpen && <UserModal onClose={() => setModalOpen(false)} />}
    </>
  );
};
```

---

## Common Anti-Patterns to Avoid

### Anti-Pattern 1: Prop Drilling

**Bad:**

```tsx
const App = () => {
  const [user, setUser] = useState<User | null>(null);

  return <Dashboard user={user} setUser={setUser} />;
};

const Dashboard = ({ user, setUser }) => {
  return <Sidebar user={user} setUser={setUser} />;
};

const Sidebar = ({ user, setUser }) => {
  return <UserProfile user={user} setUser={setUser} />;
};

const UserProfile = ({ user, setUser }) => {
  // Finally used here
};
```

**Good:**

```tsx
// Use context for deeply nested props
const UserContext = createContext<UserContextType | null>(null);

const App = () => {
  const [user, setUser] = useState<User | null>(null);

  return (
    <UserContext.Provider value={{ user, setUser }}>
      <Dashboard />
    </UserContext.Provider>
  );
};

const useUser = () => {
  const context = useContext(UserContext);
  if (!context) {
    throw new Error('useUser must be used within UserProvider');
  }
  return context;
};

const UserProfile = () => {
  const { user, setUser } = useUser();
  // Direct access without prop drilling
};
```

### Anti-Pattern 2: Massive Components

**Bad:**

```tsx
const UserDashboard = () => {
  // 500+ lines of code
  // Multiple responsibilities
  // Complex logic
  // Hard to test
  // Impossible to maintain
};
```

**Good:**

```tsx
// Break into smaller, focused components
const UserDashboard = () => {
  return (
    <div className="p-6">
      <UserHeader />
      <UserStats />
      <UserActivityFeed />
      <UserSettings />
    </div>
  );
};

// Each component has single responsibility
const UserHeader = () => {
  /* ... */
};
const UserStats = () => {
  /* ... */
};
const UserActivityFeed = () => {
  /* ... */
};
const UserSettings = () => {
  /* ... */
};
```

### Anti-Pattern 3: Ignoring Loading and Error States

**Bad:**

```tsx
const UserList = () => {
  const { data: users } = useUsers();

  return (
    <div>
      {users.map((user) => (
        <UserCard key={user.id} user={user} />
      ))}
    </div>
  );
};
```

**Good:**

```tsx
const UserList = () => {
  const { data: users, isLoading, error } = useUsers();

  if (isLoading) {
    return <UserListSkeleton />;
  }

  if (error) {
    return (
      <ErrorState
        message="Failed to load users"
        onRetry={() => queryClient.invalidateQueries(['users'])}
      />
    );
  }

  if (!users || users.length === 0) {
    return <EmptyState message="No users found" />;
  }

  return (
    <div className="space-y-2">
      {users.map((user) => (
        <UserCard key={user.id} user={user} />
      ))}
    </div>
  );
};
```

### Anti-Pattern 4: Using window.history.pushState for URL Updates

**Bad:**

```tsx
// Directly manipulating browser history - bypasses React Router
const handleSubmit = () => {
  const url = new URL(window.location.href);
  url.searchParams.set('selectedResume', resumeId.toString());
  window.history.pushState({}, '', url.toString());
};

const handleClear = () => {
  const url = new URL(window.location.href);
  url.searchParams.delete('selectedResume');
  window.history.pushState({}, '', url.toString());
};
```

**Good:**

```tsx
import { useSearchParams } from 'react-router';

const MyComponent = () => {
  const [searchParams, setSearchParams] = useSearchParams();

  // Setting a URL parameter
  const handleSubmit = () => {
    setSearchParams({ selectedResume: resumeId.toString() });
  };

  // Removing all URL parameters
  const handleClear = () => {
    setSearchParams({});
  };

  // Reading a URL parameter
  const selectedResume = searchParams.get('selectedResume');

  return <div>...</div>;
};
```

**Why:**

- `useSearchParams` integrates with React Router's navigation system
- Properly triggers route change events and history tracking
- Enables proper back/forward button behavior
- Works with React Router's navigation guards and listeners
- Type-safe API with proper React integration

---

### Anti-Pattern 5: Using Default Tailwind Colors

**Bad:**

```tsx
const Button = () => <button className="border-gray-300 bg-blue-500 text-white">Click me</button>;
```

**Good:**

```tsx
const Button = () => (
  <button className="bg-primary-500 hover:bg-primary-600 active:bg-primary-700 rounded-md border border-neutral-300 text-white transition-colors dark:border-neutral-700">
    Click me
  </button>
);
```

### Anti-Pattern 6: Inconsistent Theme Implementation

**Bad:**

```tsx
// Mixing dark: variants inconsistently across components
const Header = () => (
  <header className="bg-white dark:bg-neutral-900">
    <h1 className="text-neutral-100">Title</h1> {/* No light mode color */}
    <p className="text-neutral-600 dark:text-neutral-400">Description</p>
  </header>
);

const Footer = () => (
  <footer className="bg-neutral-900">
    {' '}
    {/* No light mode */}
    <p className="text-neutral-400">Footer text</p>
  </footer>
);
```

**Good:**

```tsx
// Consistent theme implementation across all components
const Header = () => (
  <header className="border-b border-neutral-200 bg-white dark:border-neutral-700 dark:bg-neutral-900">
    <h1 className="text-neutral-900 dark:text-neutral-100">Title</h1>
    <p className="text-neutral-700 dark:text-neutral-400">Description</p>
  </header>
);

const Footer = () => (
  <footer className="border-t border-neutral-200 bg-neutral-50 dark:border-neutral-700 dark:bg-neutral-900">
    <p className="text-neutral-600 dark:text-neutral-400">Footer text</p>
  </footer>
);
```

### Theme Color Guidelines

**Color Hierarchy:**

```tsx
// Always use both light and dark variants
const Component = () => (
  <div>
    {/* Primary text - highest contrast */}
    <h1 className="text-neutral-900 dark:text-neutral-100">Heading</h1>

    {/* Body text - good readability */}
    <p className="text-neutral-700 dark:text-neutral-300">Body content</p>

    {/* Secondary text - de-emphasized */}
    <span className="text-neutral-600 dark:text-neutral-400">Metadata</span>

    {/* Muted text - minimal emphasis */}
    <small className="text-neutral-500 dark:text-neutral-500">Hint text</small>

    {/* Interactive elements */}
    <button className="text-primary-700 hover:text-primary-800 dark:text-primary-300 dark:hover:text-primary-200">
      Action
    </button>
  </div>
);
```

**Background Hierarchy:**

```tsx
const Component = () => (
  <>
    {/* Page/section backgrounds */}
    <div className="bg-neutral-50 dark:bg-neutral-900">
      {/* Card/container backgrounds */}
      <div className="border border-neutral-200 bg-white dark:border-neutral-700 dark:bg-neutral-800">
        {/* Nested emphasis */}
        <div className="bg-neutral-50 dark:bg-neutral-700/50">Content</div>
      </div>
    </div>
  </>
);
```

**Required Pattern:**

- ✅ Every text color MUST have both light and dark variants
- ✅ Every background MUST have both light and dark variants
- ✅ Every border MUST have both light and dark variants
- ✅ Use custom colors only (primary-\*, neutral-\*, accent-\*, etc.)
- ❌ Never use default Tailwind colors (blue-500, gray-300, etc.)
- ❌ Never omit dark: or light mode colors

**Consistency Checklist:**

- [ ] All text elements have proper contrast in both modes
- [ ] All backgrounds adapt to theme
- [ ] All borders are visible in both modes
- [ ] Interactive states (hover, focus) work in both modes
- [ ] Components look cohesive across the application

### Anti-Pattern 7: Dialogs Inside Loops

**Bad:**

```tsx
// Dialog rendered inside each card - creates N dialog instances
const CardList = () => {
  const { data: items = [] } = useItems();

  return (
    <div className="grid grid-cols-3 gap-4">
      {items.map((item) => (
        <Card key={item.id} item={item} />
      ))}
    </div>
  );
};

const Card = ({ item }: { item: Item }) => {
  const [isEditOpen, setIsEditOpen] = useState(false);

  return (
    <div className="rounded-lg border p-4">
      <h3>{item.name}</h3>
      <Button onClick={() => setIsEditOpen(true)}>Edit</Button>

      {/* Dialog inside each card - BAD! */}
      <Dialog open={isEditOpen} onOpenChange={setIsEditOpen}>
        <DialogContent>
          <DialogTitle>Edit {item.name}</DialogTitle>
          {/* Edit form */}
        </DialogContent>
      </Dialog>
    </div>
  );
};
```

**Good:**

```tsx
// Single dialog at parent level, controlled by state
const CardList = () => {
  const { data: items = [] } = useItems();
  const [editingItemId, setEditingItemId] = useState<string | null>(null);

  const editingItem = items.find((item) => item.id === editingItemId);

  return (
    <>
      <div className="grid grid-cols-3 gap-4">
        {items.map((item) => (
          <Card
            key={item.id}
            item={item}
            isEditing={item.id === editingItemId}
            onEdit={setEditingItemId}
          />
        ))}
      </div>

      {/* Single dialog outside the loop */}
      <Dialog
        open={editingItemId !== null}
        onOpenChange={(open) => !open && setEditingItemId(null)}
      >
        <DialogContent>
          <DialogTitle>Edit {editingItem?.name}</DialogTitle>
          {/* Edit form using editingItem */}
        </DialogContent>
      </Dialog>
    </>
  );
};

const Card = ({
  item,
  isEditing,
  onEdit,
}: {
  item: Item;
  isEditing: boolean;
  onEdit: (id: string) => void;
}) => {
  return (
    <div className={cn('rounded-lg border p-4', isEditing && 'ring-primary-500 ring-2')}>
      <h3>{item.name}</h3>
      <Button onClick={() => onEdit(item.id)}>Edit</Button>
    </div>
  );
};
```

**Why:**

- Only one Dialog instance instead of N (better performance)
- No event propagation issues (dialog is outside the interactive cards)
- Cleaner state management at parent level
- The `isEditing` prop allows visual feedback on which item is being edited
- Easier to manage dialog open/close logic in one place

---

## Summary

### Key Takeaways

1. **Single Responsibility**: Each component, hook, and function should do one thing well
2. **Composition**: Build complex UIs from simple, reusable components
3. **Type Safety**: Leverage TypeScript's type system fully
4. **Clean Separation**: Separate concerns (UI, logic, data fetching, state)
5. **Meaningful Names**: Use descriptive, pronounceable, searchable names
6. **Error Handling**: Always handle loading, error, and empty states
7. **Performance**: Use memoization and lazy loading appropriately
8. **Consistency**: Follow project conventions (custom colors, naming, structure)

### Before Committing Code

- [ ] Components are small and focused (< 200 lines)
- [ ] Hooks have single responsibility
- [ ] All states (loading, error, success) are handled
- [ ] TypeScript types are specific (no `any`)
- [ ] Custom colors used (primary-\*, neutral-\*, accent-\*)
- [ ] Both light AND dark mode variants included on ALL elements
- [ ] No default Tailwind colors (no blue-500, gray-300, etc.)
- [ ] Text has proper contrast in both light and dark modes
- [ ] Names are meaningful and consistent
- [ ] No duplicate code
- [ ] API calls use TanStack Query
- [ ] Tests cover main functionality
