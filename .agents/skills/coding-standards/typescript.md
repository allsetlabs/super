# Clean Code TypeScript

Clean Code principles adapted for TypeScript development. This guide focuses on producing readable, reusable, and refactorable software.

**Source**: Adapted from [clean-code-typescript](https://github.com/labs42io/clean-code-typescript)

## Table of Contents

1. [Variables](#variables)
2. [Functions](#functions)
3. [Objects and Data Structures](#objects-and-data-structures)
4. [Classes](#classes)
5. [SOLID Principles](#solid-principles)
6. [Testing](#testing)
7. [Error Handling](#error-handling)
8. [Formatting](#formatting)
9. [Comments](#comments)
10. [TypeScript-Specific Best Practices](#typescript-specific-best-practices)

---

## Variables

### Use Meaningful and Pronounceable Variable Names

Variables should clearly communicate their purpose and be easy to discuss with your team.

**Bad:**

```ts
function between<T>(a1: T, a2: T, a3: T): boolean {
  return a2 <= a1 && a1 <= a3;
}

type DtaRcrd102 = {
  genymdhms: Date;
  modymdhms: Date;
  pszqint: number;
};
```

**Good:**

```ts
function between<T>(value: T, left: T, right: T): boolean {
  return left <= value && value <= right;
}

type Customer = {
  generationTimestamp: Date;
  modificationTimestamp: Date;
  recordId: number;
};
```

### Use the Same Vocabulary for the Same Type

Be consistent with naming conventions across your codebase.

**Bad:**

```ts
function getUserInfo(): User;
function getUserDetails(): User;
function getUserData(): User;
```

**Good:**

```ts
function getUser(): User;
```

### Use Searchable Names

Avoid magic numbers and strings. Name constants clearly so they're easy to find and understand.

**Bad:**

```ts
// What is 86400000?
setTimeout(restart, 86400000);
```

**Good:**

```ts
const MILLISECONDS_PER_DAY = 24 * 60 * 60 * 1000; // 86400000
setTimeout(restart, MILLISECONDS_PER_DAY);
```

### Use Explanatory Variables

Destructure and name values to make code more readable.

**Bad:**

```ts
declare const users: Map<string, User>;

for (const keyValue of users) {
  // iterate through users map
}
```

**Good:**

```ts
declare const users: Map<string, User>;

for (const [id, user] of users) {
  // iterate through users map
}
```

### Avoid Mental Mapping

Explicit is better than implicit. Clarity is king.

**Bad:**

```ts
const u = getUser();
const s = getSubscription();
const t = charge(u, s);
```

**Good:**

```ts
const user = getUser();
const subscription = getSubscription();
const transaction = charge(user, subscription);
```

### Don't Add Unneeded Context

If your class/type/object name tells you something, don't repeat it in property names.

**Bad:**

```ts
type Car = {
  carMake: string;
  carModel: string;
  carColor: string;
};

function print(car: Car): void {
  console.log(`${car.carMake} ${car.carModel} (${car.carColor})`);
}
```

**Good:**

```ts
type Car = {
  make: string;
  model: string;
  color: string;
};

function print(car: Car): void {
  console.log(`${car.make} ${car.model} (${car.color})`);
}
```

### Use Default Arguments

Default arguments are cleaner than short circuiting or conditionals.

**Bad:**

```ts
function loadPages(count?: number) {
  const loadCount = count !== undefined ? count : 10;
  // ...
}
```

**Good:**

```ts
function loadPages(count: number = 10) {
  // ...
}
```

### Use Enums to Document Intent

Enums help document the intent when you care about distinct values rather than specific values.

**Bad:**

```ts
const GENRE = {
  ROMANTIC: 'romantic',
  DRAMA: 'drama',
  COMEDY: 'comedy',
  DOCUMENTARY: 'documentary',
};

projector.configureFilm(GENRE.COMEDY);
```

**Good:**

```ts
enum GENRE {
  ROMANTIC,
  DRAMA,
  COMEDY,
  DOCUMENTARY,
}

projector.configureFilm(GENRE.COMEDY);
```

---

## Functions

### Function Arguments (2 or Fewer Ideally)

Limit function parameters to make testing easier. Use object destructuring for multiple parameters.

**Bad:**

```ts
function createMenu(title: string, body: string, buttonText: string, cancellable: boolean) {
  // ...
}

createMenu('Foo', 'Bar', 'Baz', true);
```

**Good:**

```ts
type MenuOptions = {
  title: string;
  body: string;
  buttonText: string;
  cancellable: boolean;
};

function createMenu(options: MenuOptions) {
  // ...
}

createMenu({
  title: 'Foo',
  body: 'Bar',
  buttonText: 'Baz',
  cancellable: true,
});
```

### Functions Should Do One Thing

This is the most important rule in software engineering. Single-responsibility functions are easier to compose, test, and reason about.

**Bad:**

```ts
function emailActiveClients(clients: Client[]) {
  clients.forEach((client) => {
    const clientRecord = database.lookup(client);
    if (clientRecord.isActive()) {
      email(client);
    }
  });
}
```

**Good:**

```ts
function emailActiveClients(clients: Client[]) {
  clients.filter(isActiveClient).forEach(email);
}

function isActiveClient(client: Client) {
  const clientRecord = database.lookup(client);
  return clientRecord.isActive();
}
```

### Function Names Should Say What They Do

**Bad:**

```ts
function addToDate(date: Date, month: number): Date {
  // ...
}

const date = new Date();
addToDate(date, 1); // Hard to tell what is added
```

**Good:**

```ts
function addMonthToDate(date: Date, month: number): Date {
  // ...
}

const date = new Date();
addMonthToDate(date, 1);
```

### Functions Should Only Be One Level of Abstraction

When you have multiple levels of abstraction, your function is usually doing too much.

**Bad:**

```ts
function parseCode(code: string) {
  const REGEXES = [
    /* ... */
  ];
  const statements = code.split(' ');
  const tokens = [];

  REGEXES.forEach((regex) => {
    statements.forEach((statement) => {
      // ...
    });
  });

  const ast = [];
  tokens.forEach((token) => {
    // lex...
  });

  ast.forEach((node) => {
    // parse...
  });
}
```

**Good:**

```ts
function parseCode(code: string) {
  const tokens = tokenize(code);
  const syntaxTree = parse(tokens);

  syntaxTree.forEach((node) => {
    // parse...
  });
}

function tokenize(code: string): Token[] {
  // tokenization logic
}

function parse(tokens: Token[]): SyntaxTree {
  // parsing logic
}
```

### Remove Duplicate Code (DRY Principle)

Duplicate code means multiple places to update when logic changes. Extract common logic into reusable functions.

**Bad:**

```ts
function showDeveloperList(developers: Developer[]) {
  developers.forEach((developer) => {
    const expectedSalary = developer.calculateExpectedSalary();
    const experience = developer.getExperience();
    const githubLink = developer.getGithubLink();
    render({ expectedSalary, experience, githubLink });
  });
}

function showManagerList(managers: Manager[]) {
  managers.forEach((manager) => {
    const expectedSalary = manager.calculateExpectedSalary();
    const experience = manager.getExperience();
    const portfolio = manager.getMBAProjects();
    render({ expectedSalary, experience, portfolio });
  });
}
```

**Good:**

```ts
type Employee = Developer | Manager;

function showEmployeeList(employees: Employee[]) {
  employees.forEach((employee) => {
    const expectedSalary = employee.calculateExpectedSalary();
    const experience = employee.getExperience();
    const extra = employee.getExtraDetails();

    render({ expectedSalary, experience, extra });
  });
}
```

### Don't Use Flags as Function Parameters

Flags indicate that a function does more than one thing. Split functions if they follow different code paths.

**Bad:**

```ts
function createFile(name: string, temp: boolean) {
  if (temp) {
    fs.create(`./temp/${name}`);
  } else {
    fs.create(name);
  }
}
```

**Good:**

```ts
function createTempFile(name: string) {
  createFile(`./temp/${name}`);
}

function createFile(name: string) {
  fs.create(name);
}
```

### Avoid Side Effects

Functions should be predictable. Avoid modifying global state or mutating input parameters.

**Bad:**

```ts
let name = 'Robert C. Martin';

function toBase64() {
  name = btoa(name); // Modifies global variable
}

toBase64();
console.log(name); // 'Um9iZXJ0IEMuIE1hcnRpbg=='
```

**Good:**

```ts
const name = 'Robert C. Martin';

function toBase64(text: string): string {
  return btoa(text);
}

const encodedName = toBase64(name);
console.log(name); // Still 'Robert C. Martin'
```

### Favor Functional Programming

Use pure functions, map, filter, and reduce instead of imperative loops when possible.

**Bad:**

```ts
const contributions = [
  { name: 'Uncle Bobby', linesOfCode: 500 },
  { name: 'Suzie Q', linesOfCode: 1500 },
  { name: 'Jimmy Gosling', linesOfCode: 150 },
  { name: 'Gracie Hopper', linesOfCode: 1000 },
];

let totalOutput = 0;
for (let i = 0; i < contributions.length; i++) {
  totalOutput += contributions[i].linesOfCode;
}
```

**Good:**

```ts
const contributions = [
  { name: 'Uncle Bobby', linesOfCode: 500 },
  { name: 'Suzie Q', linesOfCode: 1500 },
  { name: 'Jimmy Gosling', linesOfCode: 150 },
  { name: 'Gracie Hopper', linesOfCode: 1000 },
];

const totalOutput = contributions.reduce((total, output) => total + output.linesOfCode, 0);
```

### Encapsulate Conditionals

Extract complex conditionals into well-named functions.

**Bad:**

```ts
if (subscription.isTrial || account.balance > 0) {
  // ...
}
```

**Good:**

```ts
function canActivateService(subscription: Subscription, account: Account): boolean {
  return subscription.isTrial || account.balance > 0;
}

if (canActivateService(subscription, account)) {
  // ...
}
```

### Avoid Negative Conditionals

Positive conditionals are easier to understand.

**Bad:**

```ts
function isEmailNotUsed(email: string): boolean {
  // ...
}

if (isEmailNotUsed(email)) {
  // ...
}
```

**Good:**

```ts
function isEmailUsed(email: string): boolean {
  // ...
}

if (!isEmailUsed(email)) {
  // ...
}
```

---

## Objects and Data Structures

### Use Getters and Setters

Using getters and setters provides encapsulation and makes it easier to add validation, logging, or computed properties.

**Bad:**

```ts
class BankAccount {
  balance: number = 0;
}

const account = new BankAccount();
account.balance = 100;
```

**Good:**

```ts
class BankAccount {
  private _balance: number = 0;

  get balance(): number {
    return this._balance;
  }

  set balance(amount: number) {
    if (amount < 0) {
      throw new Error('Balance cannot be negative');
    }
    this._balance = amount;
  }
}

const account = new BankAccount();
account.balance = 100;
```

### Make Objects Have Private/Protected Members

Use TypeScript's access modifiers to control visibility and protect internal state.

**Bad:**

```ts
class Employee {
  name: string;

  constructor(name: string) {
    this.name = name;
  }
}

const employee = new Employee('John Doe');
console.log(employee.name); // Direct access
```

**Good:**

```ts
class Employee {
  private name: string;

  constructor(name: string) {
    this.name = name;
  }

  getName(): string {
    return this.name;
  }
}

const employee = new Employee('John Doe');
console.log(employee.getName());
```

---

## Classes

### Prefer Composition Over Inheritance

Use composition to build complex functionality from simpler pieces.

**Bad:**

```ts
class Employee {
  private name: string;
  private email: string;

  constructor(name: string, email: string) {
    this.name = name;
    this.email = email;
  }
}

class EmployeeTaxData extends Employee {
  private ssn: string;

  constructor(name: string, email: string, ssn: string) {
    super(name, email);
    this.ssn = ssn;
  }
}
```

**Good:**

```ts
class Employee {
  constructor(
    private name: string,
    private email: string
  ) {}
}

class EmployeeTaxData {
  constructor(
    private employee: Employee,
    private ssn: string
  ) {}
}
```

### Use Method Chaining

Method chaining makes your code more expressive and less verbose.

**Bad:**

```ts
class QueryBuilder {
  private query: string = '';

  select(fields: string[]): void {
    this.query += `SELECT ${fields.join(', ')}`;
  }

  from(table: string): void {
    this.query += ` FROM ${table}`;
  }

  where(condition: string): void {
    this.query += ` WHERE ${condition}`;
  }
}

const queryBuilder = new QueryBuilder();
queryBuilder.select(['id', 'name']);
queryBuilder.from('users');
queryBuilder.where('age > 18');
```

**Good:**

```ts
class QueryBuilder {
  private query: string = '';

  select(fields: string[]): this {
    this.query += `SELECT ${fields.join(', ')}`;
    return this;
  }

  from(table: string): this {
    this.query += ` FROM ${table}`;
    return this;
  }

  where(condition: string): this {
    this.query += ` WHERE ${condition}`;
    return this;
  }

  build(): string {
    return this.query;
  }
}

const query = new QueryBuilder().select(['id', 'name']).from('users').where('age > 18').build();
```

---

## SOLID Principles

### Single Responsibility Principle (SRP)

A class should have only one reason to change.

**Bad:**

```ts
class UserSettings {
  constructor(private user: User) {}

  changeSettings(settings: Settings) {
    if (this.verifyCredentials()) {
      // ...
    }
  }

  verifyCredentials() {
    // ...
  }
}
```

**Good:**

```ts
class UserAuth {
  constructor(private user: User) {}

  verifyCredentials() {
    // ...
  }
}

class UserSettings {
  private auth: UserAuth;

  constructor(private user: User) {
    this.auth = new UserAuth(user);
  }

  changeSettings(settings: Settings) {
    if (this.auth.verifyCredentials()) {
      // ...
    }
  }
}
```

### Open/Closed Principle (OCP)

Classes should be open for extension but closed for modification.

**Bad:**

```ts
class Rectangle {
  constructor(
    public width: number,
    public height: number
  ) {}
}

class AreaCalculator {
  calculateArea(shapes: Rectangle[]): number {
    return shapes.reduce((area, shape) => {
      return area + shape.width * shape.height;
    }, 0);
  }
}
```

**Good:**

```ts
interface Shape {
  getArea(): number;
}

class Rectangle implements Shape {
  constructor(
    private width: number,
    private height: number
  ) {}

  getArea(): number {
    return this.width * this.height;
  }
}

class Circle implements Shape {
  constructor(private radius: number) {}

  getArea(): number {
    return Math.PI * this.radius ** 2;
  }
}

class AreaCalculator {
  calculateArea(shapes: Shape[]): number {
    return shapes.reduce((area, shape) => area + shape.getArea(), 0);
  }
}
```

### Liskov Substitution Principle (LSP)

Derived classes must be substitutable for their base classes.

**Bad:**

```ts
class Bird {
  fly() {
    // ...
  }
}

class Penguin extends Bird {
  fly() {
    throw new Error("Penguins can't fly");
  }
}
```

**Good:**

```ts
interface Bird {
  eat(): void;
}

interface FlyingBird extends Bird {
  fly(): void;
}

class Penguin implements Bird {
  eat() {
    // ...
  }
}

class Sparrow implements FlyingBird {
  eat() {
    // ...
  }

  fly() {
    // ...
  }
}
```

### Interface Segregation Principle (ISP)

Clients should not be forced to depend on interfaces they don't use.

**Bad:**

```ts
interface Worker {
  work(): void;
  eat(): void;
  sleep(): void;
}

class HumanWorker implements Worker {
  work() {
    /* ... */
  }
  eat() {
    /* ... */
  }
  sleep() {
    /* ... */
  }
}

class RobotWorker implements Worker {
  work() {
    /* ... */
  }
  eat() {
    /* Not needed */
  }
  sleep() {
    /* Not needed */
  }
}
```

**Good:**

```ts
interface Workable {
  work(): void;
}

interface Eatable {
  eat(): void;
}

interface Sleepable {
  sleep(): void;
}

class HumanWorker implements Workable, Eatable, Sleepable {
  work() {
    /* ... */
  }
  eat() {
    /* ... */
  }
  sleep() {
    /* ... */
  }
}

class RobotWorker implements Workable {
  work() {
    /* ... */
  }
}
```

### Dependency Inversion Principle (DIP)

High-level modules should not depend on low-level modules. Both should depend on abstractions.

**Bad:**

```ts
class MySQLDatabase {
  save(data: string) {
    // Save to MySQL
  }
}

class UserService {
  private db: MySQLDatabase;

  constructor() {
    this.db = new MySQLDatabase();
  }

  saveUser(user: User) {
    this.db.save(JSON.stringify(user));
  }
}
```

**Good:**

```ts
interface Database {
  save(data: string): void;
}

class MySQLDatabase implements Database {
  save(data: string) {
    // Save to MySQL
  }
}

class MongoDatabase implements Database {
  save(data: string) {
    // Save to MongoDB
  }
}

class UserService {
  constructor(private db: Database) {}

  saveUser(user: User) {
    this.db.save(JSON.stringify(user));
  }
}

// Usage
const mysqlDb = new MySQLDatabase();
const userService = new UserService(mysqlDb);
```

---

## Testing

### Single Concept per Test

Each test should verify one concept only.

**Bad:**

```ts
describe('UserService', () => {
  it('should create user and update user and delete user', async () => {
    const user = await userService.createUser({ name: 'John' });
    expect(user.name).toBe('John');

    const updated = await userService.updateUser(user.id, { name: 'Jane' });
    expect(updated.name).toBe('Jane');

    await userService.deleteUser(user.id);
    const deleted = await userService.getUser(user.id);
    expect(deleted).toBeNull();
  });
});
```

**Good:**

```ts
describe('UserService', () => {
  it('should create user', async () => {
    const user = await userService.createUser({ name: 'John' });
    expect(user.name).toBe('John');
  });

  it('should update user', async () => {
    const user = await userService.createUser({ name: 'John' });
    const updated = await userService.updateUser(user.id, { name: 'Jane' });
    expect(updated.name).toBe('Jane');
  });

  it('should delete user', async () => {
    const user = await userService.createUser({ name: 'John' });
    await userService.deleteUser(user.id);
    const deleted = await userService.getUser(user.id);
    expect(deleted).toBeNull();
  });
});
```

### Test Names Should Describe What They Test

Use descriptive test names that explain the scenario and expected outcome.

**Bad:**

```ts
describe('UserService', () => {
  it('test1', () => {
    /* ... */
  });
  it('test2', () => {
    /* ... */
  });
});
```

**Good:**

```ts
describe('UserService', () => {
  it('should return user when valid ID is provided', () => {
    /* ... */
  });
  it('should throw error when invalid ID is provided', () => {
    /* ... */
  });
});
```

---

## Error Handling

### Always Use Error for Throwing or Rejecting

Use proper Error objects instead of strings for better stack traces.

**Bad:**

```ts
function calculateTotal(items: Item[]): number {
  if (items.length === 0) {
    throw 'No items provided';
  }
  // ...
}
```

**Good:**

```ts
function calculateTotal(items: Item[]): number {
  if (items.length === 0) {
    throw new Error('No items provided');
  }
  // ...
}
```

### Don't Ignore Caught Errors

Always handle or log errors properly.

**Bad:**

```ts
try {
  functionThatMightThrow();
} catch (error) {
  console.log(error);
}
```

**Good:**

```ts
try {
  functionThatMightThrow();
} catch (error) {
  console.error('Error occurred:', error);
  notifyUserOfError(error);
  reportErrorToService(error);
}
```

### Use Custom Error Types

Create custom error classes for different error scenarios.

**Good:**

```ts
class ValidationError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'ValidationError';
  }
}

class NotFoundError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'NotFoundError';
  }
}

function getUser(id: string): User {
  const user = database.findById(id);
  if (!user) {
    throw new NotFoundError(`User with ID ${id} not found`);
  }
  return user;
}
```

---

## Formatting

### Use Consistent Capitalization

Follow TypeScript naming conventions consistently.

**Conventions:**

- `PascalCase` for classes, interfaces, types, enums
- `camelCase` for variables, functions, methods
- `UPPER_SNAKE_CASE` for constants
- `camelCase` for file names (or kebab-case)

**Good:**

```ts
// Classes, Interfaces, Types
class UserAccount {}
interface UserProfile {}
type UserSettings = {};
enum UserRole {}

// Variables and Functions
const userName = 'John';
function getUserById(id: string) {}

// Constants
const MAX_RETRY_COUNT = 3;
const API_BASE_URL = 'https://api.example.com';
```

### Function Callers and Callees Should Be Close

Place related functions near each other in the file.

**Bad:**

```ts
class UserService {
  createUser() {
    // ...
  }

  deleteUser() {
    // ...
  }

  validateUser() {
    // Used by createUser
  }
}
```

**Good:**

```ts
class UserService {
  createUser() {
    this.validateUser();
    // ...
  }

  private validateUser() {
    // Used by createUser
  }

  deleteUser() {
    // ...
  }
}
```

---

## Comments

### Only Comment Things That Have Business Logic Complexity

Code should be self-documenting. Comments are for "why", not "what".

**Bad:**

```ts
function calculateTotal(items: Item[]): number {
  // Create a variable to hold the total
  let total = 0;

  // Loop through all items
  for (const item of items) {
    // Add item price to total
    total += item.price;
  }

  // Return the total
  return total;
}
```

**Good:**

```ts
function calculateTotal(items: Item[]): number {
  return items.reduce((total, item) => total + item.price, 0);
}
```

### Don't Leave Commented Out Code

Delete commented-out code. Version control keeps history.

**Bad:**

```ts
function processUser(user: User) {
  // const oldImplementation = () => {
  //   // ...
  // };

  newImplementation(user);
}
```

**Good:**

```ts
function processUser(user: User) {
  newImplementation(user);
}
```

### Use JSDoc for Public APIs

Document public APIs with JSDoc for better IDE support.

**Good:**

```ts
/**
 * Calculates the total price of items in the cart
 * @param items - Array of items to calculate total for
 * @param discount - Optional discount percentage (0-100)
 * @returns Total price after discount
 * @throws {ValidationError} If discount is invalid
 */
function calculateTotal(items: Item[], discount?: number): number {
  if (discount && (discount < 0 || discount > 100)) {
    throw new ValidationError('Discount must be between 0 and 100');
  }

  const total = items.reduce((sum, item) => sum + item.price, 0);
  return discount ? total * (1 - discount / 100) : total;
}
```

---

## TypeScript-Specific Best Practices

### Use Strict Mode

Enable strict mode in `tsconfig.json` for better type safety.

**tsconfig.json:**

```json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "strictPropertyInitialization": true
  }
}
```

### Prefer Interfaces Over Types for Object Shapes

Interfaces are more extensible and provide better error messages.

**Good:**

```ts
interface User {
  id: string;
  name: string;
  email: string;
}

interface AdminUser extends User {
  permissions: string[];
}
```

### Use Type Guards

Create type guards for runtime type checking.

**Good:**

```ts
interface Bird {
  fly(): void;
}

interface Fish {
  swim(): void;
}

function isBird(pet: Bird | Fish): pet is Bird {
  return (pet as Bird).fly !== undefined;
}

function move(pet: Bird | Fish) {
  if (isBird(pet)) {
    pet.fly();
  } else {
    pet.swim();
  }
}
```

### Use Union Types Instead of Enums When Appropriate

Union types can be simpler for string constants.

**Good:**

```ts
type Status = 'pending' | 'approved' | 'rejected';

function updateStatus(status: Status) {
  // TypeScript ensures only valid values
}
```

### Avoid Type Assertions (as) When Possible

Use type guards and proper typing instead of assertions.

**Bad:**

```ts
function getUser(id: string): User {
  const data = fetchUserData(id);
  return data as User; // Dangerous
}
```

**Good:**

```ts
function isUser(data: unknown): data is User {
  return typeof data === 'object' && data !== null && 'id' in data && 'name' in data;
}

function getUser(id: string): User {
  const data = fetchUserData(id);
  if (isUser(data)) {
    return data;
  }
  throw new Error('Invalid user data');
}
```

### Use Readonly for Immutable Data

Mark properties as readonly when they shouldn't change.

**Good:**

```ts
interface User {
  readonly id: string;
  name: string;
  readonly createdAt: Date;
}

const user: User = {
  id: '123',
  name: 'John',
  createdAt: new Date(),
};

// user.id = '456'; // Error: Cannot assign to 'id' because it is a read-only property
user.name = 'Jane'; // OK
```

### Use Unknown Instead of Any

Use `unknown` for better type safety when the type is truly unknown.

**Bad:**

```ts
function processValue(value: any) {
  return value.toString(); // No type checking
}
```

**Good:**

```ts
function processValue(value: unknown) {
  if (typeof value === 'string') {
    return value.toUpperCase();
  }
  if (typeof value === 'number') {
    return value.toString();
  }
  throw new Error('Unsupported type');
}
```

---

## Summary Checklist

Before submitting code, verify:

### Variables

- [ ] Meaningful and pronounceable names
- [ ] No magic numbers or strings
- [ ] Proper use of const/let
- [ ] No unnecessary context in names

### Functions

- [ ] 2 or fewer parameters (use objects if more)
- [ ] Does one thing only
- [ ] Descriptive name
- [ ] No side effects
- [ ] Pure when possible

### Classes

- [ ] Single responsibility
- [ ] Proper encapsulation (private/protected)
- [ ] Composition over inheritance
- [ ] Follows SOLID principles

### TypeScript

- [ ] Strict mode enabled
- [ ] No `any` types (use `unknown` if needed)
- [ ] Proper interfaces and types
- [ ] Type guards for runtime checks
- [ ] Readonly for immutable data

### Error Handling

- [ ] Proper Error objects
- [ ] Errors are caught and handled
- [ ] Custom error types when appropriate

### Testing

- [ ] One concept per test
- [ ] Descriptive test names
- [ ] Good coverage of edge cases

### Code Quality

- [ ] No duplicate code (DRY)
- [ ] No dead code
- [ ] Consistent formatting
- [ ] Self-documenting (minimal comments)
- [ ] JSDoc for public APIs

---

Remember: These are guidelines, not absolute rules. Use judgment to apply them appropriately for your specific context.
