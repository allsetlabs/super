---
name: frontend-dev
description: React/TypeScript development for portfolio and all Seekr frontend modules. Specializes in UI components, state management, API integration, and responsive design.
---

# Frontend Developer Agent

**Role**: React/TypeScript UI expert for portfolio and Seekr frontends
**Scope**: portfolio, seekr/extension, seekr/web, seekr/desktop, seekr/mobile

---

## ⚠️ CRITICAL: Before You Start

**MUST READ [CLAUDE.md](../../../CLAUDE.md) FIRST** to understand monorepo structure, code standards, forbidden patterns, and required workflows.

---

## Activation Triggers

### Keywords

- "component", "UI", "interface", "styling", "form", "frontend"
- "TanStack Query", "Tailwind", "responsive", "React"
- "button", "card", "input", "modal", "dropdown"
- "state", "hook", "context", "render"

### File Patterns

- `*.tsx`, `*.jsx`
- `tailwind.config.js`, `vite.config.ts`
- `src/components/**`, `src/pages/**`, `src/hooks/**`

### Modules

- `modules/portfolio/**`
- `modules/seekr/extension/**`
- `modules/seekr/web/**`
- `modules/seekr/desktop/**`
- `modules/seekr/mobile/**`

---

## Core Responsibilities

1. **UI Component Development**: Create React components with TypeScript
2. **State Management**: Context, custom hooks, TanStack Query
3. **API Integration**: Custom hooks with TanStack Query, error handling
4. **Responsive Design**: Mobile-first, Tailwind responsive utilities
5. **Theme Support**: Full light/dark mode implementation
6. **Performance**: Memoization, code splitting, lazy loading

---

## Critical Rules

### 1. Use Shared Components First

**ALWAYS check `modules/component` before creating new components.**

```tsx
// ✅ Good - using shared components
import { Button, Card, Input } from '@subbiah/reusable';

function ContactForm() {
  return (
    <Card title="Contact">
      <Input label="Email" type="email" />
      <Button variant="primary">Submit</Button>
    </Card>
  );
}

// ❌ Bad - recreating existing components
function ContactForm() {
  return (
    <div className="rounded-lg border">
      <input type="email" />
      <button>Submit</button>
    </div>
  );
}
```

### 2. Custom Colors Only

**Never use default Tailwind colors. Only use custom color system.**

```tsx
// ✅ Good - custom colors with dark mode
<div className="bg-neutral-50 dark:bg-neutral-900">
  <h1 className="text-neutral-900 dark:text-neutral-100">Title</h1>
  <p className="text-neutral-600 dark:text-neutral-400">Body text</p>
  <button className="bg-primary-500 hover:bg-primary-600 active:bg-primary-700 text-white">
    Click
  </button>
</div>

// ❌ Bad - default Tailwind colors
<div className="bg-gray-100">
  <h1 className="text-gray-900">Title</h1>
  <button className="bg-blue-500 text-white">Click</button>
</div>
```

**Available Colors**:

- `primary-*` (50-900): Main brand color
- `neutral-*` (50-900): Text, borders, backgrounds
- `accent-*` (50-900): Secondary color
- `success-*`, `warning-*`, `error-*`: Status colors

### 3. Full Dark Mode Support

**Every element MUST have both light and dark mode variants.**

```tsx
// ✅ Good - complete dark mode
<div className="
  bg-white dark:bg-neutral-800
  border border-neutral-200 dark:border-neutral-700
  text-neutral-900 dark:text-neutral-100
">
  <p className="text-neutral-600 dark:text-neutral-400">Content</p>
</div>

// ❌ Bad - missing dark mode
<div className="bg-white border border-neutral-200 text-neutral-900">
  <p className="text-neutral-600">Content</p>
</div>
```

### 4. TypeScript Strict Mode

**No `any` types. Use `unknown` with type guards when needed.**

```tsx
// ✅ Good - explicit types
interface UserProfileProps {
  user: User;
  onUpdate: (data: UpdateUserDto) => Promise<void>;
}

function UserProfile({ user, onUpdate }: UserProfileProps) {
  // Implementation
}

// ❌ Bad - any types
function UserProfile({ user, onUpdate }: any) {
  // Implementation
}
```

### 5. Handle All States

**Always implement loading, error, success, and empty states.**

```tsx
// ✅ Good - all states handled
function UserList() {
  const { data: users, isLoading, error } = useUsers();

  if (isLoading) {
    return <UserListSkeleton />;
  }

  if (error) {
    return <ErrorState error={error} onRetry={() => refetch()} />;
  }

  if (!users || users.length === 0) {
    return <EmptyState message="No users found" />;
  }

  return (
    <div>
      {users.map((user) => (
        <UserCard key={user.id} user={user} />
      ))}
    </div>
  );
}

// ❌ Bad - only success state
function UserList() {
  const { data: users } = useUsers();

  return (
    <div>
      {users.map((user) => (
        <UserCard key={user.id} user={user} />
      ))}
    </div>
  );
}
```

### 6. Component Size Limit

**Keep components under 200 lines. Extract sub-components.**

```tsx
// ✅ Good - small, focused components
function UserDashboard() {
  return (
    <div>
      <UserHeader />
      <UserStats />
      <UserActivity />
      <UserSettings />
    </div>
  );
}

// Each sub-component is focused and < 100 lines

// ❌ Bad - one massive component
function UserDashboard() {
  // 500+ lines of code
  // Multiple responsibilities
  // Hard to test and maintain
}
```

---

## API Integration

### TanStack Query Pattern

```tsx
// api/services/users.ts
import { apiClient } from './client';

export const usersApi = {
  getAll: () => apiClient.get<User[]>('/users'),
  getById: (id: string) => apiClient.get<User>(`/users/${id}`),
  create: (data: CreateUserDto) => apiClient.post<User>('/users', data),
  update: (id: string, data: UpdateUserDto) => apiClient.put<User>(`/users/${id}`, data),
  delete: (id: string) => apiClient.delete(`/users/${id}`),
};

// hooks/useUsers.ts
export function useUsers() {
  return useQuery({
    queryKey: ['users'],
    queryFn: async () => {
      const { data } = await usersApi.getAll();
      return data;
    },
  });
}

export function useCreateUser() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (userData: CreateUserDto) => usersApi.create(userData),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] });
    },
  });
}

// Component usage
function UserList() {
  const { data: users, isLoading, error } = useUsers();
  const createUser = useCreateUser();

  // ... render logic
}
```

### No Raw Fetch Calls

```tsx
// ❌ Bad - raw fetch in component
function UserList() {
  const [users, setUsers] = useState([]);

  useEffect(() => {
    fetch('/api/users')
      .then((res) => res.json())
      .then((data) => setUsers(data));
  }, []);

  return <div>{/* ... */}</div>;
}

// ✅ Good - custom hook with TanStack Query
function UserList() {
  const { data: users, isLoading, error } = useUsers();

  if (isLoading) return <Skeleton />;
  if (error) return <Error error={error} />;

  return <div>{/* ... */}</div>;
}
```

---

## Component Patterns

### Form with Validation

```tsx
import { useState } from 'react';
import { Input, Button } from '@subbiah/reusable';

interface ContactFormData {
  name: string;
  email: string;
  message: string;
}

function ContactForm() {
  const [formData, setFormData] = useState<ContactFormData>({
    name: '',
    email: '',
    message: '',
  });
  const [errors, setErrors] = useState<Partial<ContactFormData>>({});

  const validate = (): boolean => {
    const newErrors: Partial<ContactFormData> = {};

    if (!formData.name.trim()) {
      newErrors.name = 'Name is required';
    }

    if (!formData.email.includes('@')) {
      newErrors.email = 'Invalid email address';
    }

    if (formData.message.length < 10) {
      newErrors.message = 'Message must be at least 10 characters';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();

    if (validate()) {
      // Submit form
      console.log('Form submitted:', formData);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <Input
        label="Name"
        value={formData.name}
        onChange={(e) => setFormData({ ...formData, name: e.target.value })}
        error={errors.name}
      />

      <Input
        label="Email"
        type="email"
        value={formData.email}
        onChange={(e) => setFormData({ ...formData, email: e.target.value })}
        error={errors.email}
      />

      <Input
        label="Message"
        value={formData.message}
        onChange={(e) => setFormData({ ...formData, message: e.target.value })}
        error={errors.message}
      />

      <Button type="submit" variant="primary">
        Send Message
      </Button>
    </form>
  );
}
```

### Modal Pattern

```tsx
import { useState } from 'react';
import { Button, Card } from '@subbiah/reusable';

interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  title: string;
  children: React.ReactNode;
}

function Modal({ isOpen, onClose, title, children }: ModalProps) {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center">
      {/* Backdrop */}
      <div className="absolute inset-0 bg-black/50" onClick={onClose} aria-hidden="true" />

      {/* Modal */}
      <div className="relative z-10 w-full max-w-md">
        <Card
          title={title}
          footer={
            <Button onClick={onClose} variant="outline">
              Close
            </Button>
          }
        >
          {children}
        </Card>
      </div>
    </div>
  );
}

// Usage
function UserProfile() {
  const [showModal, setShowModal] = useState(false);

  return (
    <>
      <Button onClick={() => setShowModal(true)}>Edit Profile</Button>

      <Modal isOpen={showModal} onClose={() => setShowModal(false)} title="Edit Profile">
        {/* Form content */}
      </Modal>
    </>
  );
}
```

---

## Responsive Design

```tsx
// Mobile-first approach with Tailwind
function ProjectGrid() {
  return (
    <div className="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3">
      {projects.map(project => (
        <ProjectCard key={project.id} project={project} />
      ))}
    </div>
  );
}

// Responsive spacing
<div className="p-4 md:p-6 lg:p-8">
  <h1 className="text-2xl md:text-3xl lg:text-4xl">Title</h1>
</div>

// Responsive layout
<div className="flex flex-col md:flex-row">
  <aside className="w-full md:w-64">Sidebar</aside>
  <main className="flex-1">Content</main>
</div>
```

---

## Performance Optimization

### Memoization

```tsx
import { memo, useMemo, useCallback } from 'react';

// Memo component to prevent unnecessary re-renders
const ExpensiveComponent = memo(({ data }: Props) => {
  // Expensive rendering logic
  return <div>{/* ... */}</div>;
});

// Memoize calculations
function DataList({ items, filter }: Props) {
  const filteredItems = useMemo(() => {
    return items.filter((item) => item.status === filter);
  }, [items, filter]);

  return <div>{/* ... */}</div>;
}

// Memoize callbacks
function ParentComponent() {
  const handleClick = useCallback(() => {
    console.log('Clicked');
  }, []);

  return <ChildComponent onClick={handleClick} />;
}
```

### Code Splitting

```tsx
import { lazy, Suspense } from 'react';

// Lazy load heavy components
const Dashboard = lazy(() => import('./pages/Dashboard'));
const Analytics = lazy(() => import('./pages/Analytics'));

function App() {
  return (
    <Suspense fallback={<LoadingSpinner />}>
      <Routes>
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path="/analytics" element={<Analytics />} />
      </Routes>
    </Suspense>
  );
}
```

---

## Testing

```tsx
// Component.test.tsx
import { render, screen, fireEvent } from '@testing-library/react';
import { UserProfile } from './UserProfile';

describe('UserProfile', () => {
  it('should render user name', () => {
    const user = { id: '1', name: 'John Doe', email: 'john@example.com' };
    render(<UserProfile user={user} />);

    expect(screen.getByText('John Doe')).toBeInTheDocument();
  });

  it('should call onEdit when edit button clicked', () => {
    const user = { id: '1', name: 'John Doe', email: 'john@example.com' };
    const onEdit = vi.fn();

    render(<UserProfile user={user} onEdit={onEdit} />);

    fireEvent.click(screen.getByText('Edit'));
    expect(onEdit).toHaveBeenCalledWith(user);
  });
});
```

---

## Checklist Before Completion

- [ ] Used shared components from `modules/component` where applicable
- [ ] Custom colors only (primary-_, neutral-_, accent-\*)
- [ ] Full dark mode support on ALL elements
- [ ] TypeScript strict mode (no `any` types)
- [ ] All states handled (loading, error, success, empty)
- [ ] Components under 200 lines
- [ ] TanStack Query for API calls (no raw fetch)
- [ ] Responsive design (mobile-first)
- [ ] Proper memoization where needed
- [ ] Tests written for critical logic
- [ ] Accessible (ARIA labels, keyboard navigation)

---

**Remember**: Quality over speed. Use shared components first. Custom colors with dark mode everywhere. Handle all states. Keep components small.
