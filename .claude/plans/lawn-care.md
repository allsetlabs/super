# Lawn Care Feature - Implementation Plan

## Overview

New `/lawn-care` route in DevBot mobile, modeled after Baby Logs. On first open, collects lawn profile (address, grass type). Submitting triggers a Claude session that web-searches for sqft, climate zone, and generates a structured annual lawn care plan displayed as vertical scrollable cards.

## Data Model

### Table: `lawn_profiles`

| Column       | Type          | Notes                               |
| ------------ | ------------- | ----------------------------------- |
| id           | TEXT PK       | 8-char UUID                         |
| address      | TEXT NOT NULL | Full street address                 |
| city         | TEXT          |                                     |
| state        | TEXT          |                                     |
| zip_code     | TEXT          |                                     |
| grass_type   | TEXT NOT NULL | e.g., Bermuda, Fescue, Zoysia       |
| sqft         | INTEGER       | Populated by Claude or user         |
| climate_zone | TEXT          | e.g., "7a" - populated by Claude    |
| sun_exposure | TEXT          | full_sun, partial_shade, full_shade |
| notes        | TEXT          |                                     |
| created_at   | TIMESTAMPTZ   |                                     |
| updated_at   | TIMESTAMPTZ   |                                     |

### Table: `lawn_plans`

| Column       | Type        | Notes                                        |
| ------------ | ----------- | -------------------------------------------- |
| id           | TEXT PK     | 8-char UUID                                  |
| profile_id   | TEXT FK     | References lawn_profiles                     |
| chat_id      | TEXT        | Interactive chat ID used to generate         |
| status       | TEXT        | generating, completed, failed                |
| plan_data    | JSONB       | Full structured plan (array of applications) |
| generated_at | TIMESTAMPTZ |                                              |
| created_at   | TIMESTAMPTZ |                                              |

### `plan_data` JSONB Structure

```json
{
  "summary": "Annual plan for 5000 sqft Bermuda lawn in zone 7a",
  "total_cost": 145.5,
  "applications": [
    {
      "order": 1,
      "date": "Early March",
      "name": "Pre-Emergent + Fertilizer",
      "description": "Prevent crabgrass and feed lawn coming out of dormancy",
      "product": "Scotts Turf Builder with Halts",
      "product_url": "",
      "product_covers": 2,
      "product_price": 45.99,
      "application_cost": 22.99,
      "how_to_apply": "Use broadcast spreader at setting 3.5",
      "amount": "12.5 lbs for 5000 sqft",
      "tips": "Apply before soil temp reaches 55°F",
      "watering": "Water lightly within 24 hours of application",
      "warnings": "Do not apply to newly seeded areas"
    }
  ]
}
```

## Files to Create/Modify

### 1. Supabase Migration

- **NEW**: `modules/devbot/supabase/migrations/YYYYMMDD000001_create_lawn_tables.sql`
  - Create `lawn_profiles` and `lawn_plans` tables

### 2. Backend Routes

- **NEW**: `modules/devbot/backend/src/routes/lawn-profiles.ts`
  - `GET /api/lawn-profiles` - List all profiles
  - `GET /api/lawn-profiles/:id` - Get single profile
  - `POST /api/lawn-profiles` - Create profile
  - `PATCH /api/lawn-profiles/:id` - Update profile
  - `DELETE /api/lawn-profiles/:id` - Delete profile
- **NEW**: `modules/devbot/backend/src/routes/lawn-plans.ts`
  - `GET /api/lawn-plans?profile_id=X` - List plans for profile
  - `GET /api/lawn-plans/:id` - Get single plan
  - `POST /api/lawn-plans/generate` - Generate new plan (starts Claude session)
  - `GET /api/lawn-plans/:id/status` - Check generation status
  - `DELETE /api/lawn-plans/:id` - Delete plan
- **EDIT**: `modules/devbot/backend/src/index.ts` - Register new routes

### 3. Backend Worker

- **NEW**: `modules/devbot/backend/src/lib/lawn-plan-worker.ts`
  - Spawns Claude in print mode with structured prompt
  - Includes `--chrome` for web search capability
  - Parses JSON response from Claude
  - Stores plan_data in `lawn_plans` table
  - Updates status: generating → completed/failed

### 4. Types

- **EDIT**: `modules/devbot/app/src/types/index.ts`
  - Add `LawnProfile`, `LawnPlan`, `LawnApplication` interfaces

### 5. API Client

- **EDIT**: `modules/devbot/app/src/lib/api.ts`
  - Add lawn profile CRUD methods
  - Add lawn plan methods (generate, get, list, delete, status)

### 6. Frontend Page

- **NEW**: `modules/devbot/app/src/pages/LawnCare.tsx`
  - **Profile Gate**: If no profile, show setup form
  - **Profile Form**: Address, city, state, zip, grass type selector, optional sqft/notes
  - **Plan Display**: Vertical scrollable cards when plan exists
  - **Generation State**: Loading/generating state with polling
  - **Regenerate**: Button to regenerate plan with updated profile

### 7. Navigation

- **EDIT**: `modules/devbot/app/src/components/SlideNav.tsx` - Add Lawn Care nav item
- **EDIT**: `modules/devbot/app/src/App.tsx` - Add `/lawn-care` route

## UI Flow

```
/lawn-care
├── No profile? → Setup Form
│   ├── Address (text input)
│   ├── City, State, Zip (text inputs)
│   ├── Grass Type (button picker: Bermuda, Fescue, Zoysia, St. Augustine, Kentucky Bluegrass, Ryegrass, Buffalo, Centipede)
│   ├── Sqft (optional number input - "Leave blank, we'll look it up")
│   ├── Notes (optional textarea)
│   └── [Generate My Plan] button
│
├── Profile exists, no plan? → Generating state
│   └── Spinner + "Claude is researching your lawn..."
│
└── Plan exists → Plan View
    ├── Header: Summary + total cost + sqft + grass type + zone
    ├── Settings icon → edit profile drawer
    ├── Regenerate icon → regenerate plan
    └── Application Cards (vertical scroll)
        ├── Card 1: Pre-Emergent (March)
        ├── Card 2: Fertilizer (May)
        ├── Card 3: Weed Control (July)
        └── Card 4: Winterizer (October)
```

## Application Card Layout

```
┌─────────────────────────────────┐
│ #1 · Early March                │
│ Pre-Emergent + Fertilizer       │
├─────────────────────────────────┤
│ Prevent crabgrass and feed lawn │
│ coming out of dormancy          │
├─────────────────────────────────┤
│ 🛒 Product                      │
│ Scotts Turf Builder with Halts  │
│ 💰 $22.99 (product: $45.99/2)  │
├─────────────────────────────────┤
│ 📏 Amount: 12.5 lbs / 5000sqft │
│ 🔧 Broadcast spreader, 3.5     │
├─────────────────────────────────┤
│ 💡 Apply before soil temp 55°F │
│ 💧 Water lightly within 24hrs  │
│ ⚠️ Not for newly seeded areas  │
└─────────────────────────────────┘
```

## Claude Prompt (for plan generation)

The worker will send a detailed prompt asking Claude to:

1. Web search the address for estimated lot/lawn sqft
2. Determine USDA hardiness zone from location
3. Assess typical sun exposure for the area
4. Research best products for grass type + zone
5. Return a structured JSON plan with 3-6 annual applications
6. Include real product names, prices, and application rates
7. Calculate cost per application (product_price / product_covers)

## Implementation Order

1. Supabase migration (create tables)
2. Types (TypeScript interfaces)
3. Backend routes (lawn-profiles CRUD)
4. Backend routes (lawn-plans + worker)
5. API client methods
6. Frontend page (LawnCare.tsx)
7. Navigation + routing
8. Lint + type-check
