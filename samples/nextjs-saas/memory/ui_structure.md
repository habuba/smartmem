# UI structure

## Route map (App Router)

### Public — `app/(marketing)/`
- `/` — landing
- `/pricing` — plan table, links to Clerk signup
- `/legal/{terms,privacy}`

### Authenticated — `app/(app)/` (Clerk middleware)
- `/dashboard` — KPI tiles, "needs your approval" queue, recent activity
- `/invoices` — list (RSC, filter via searchParams: status, vendor, dateRange)
  - `/invoices/new` — upload form (Server Action)
  - `/invoices/[id]` — detail: PDF viewer, extracted fields, chain progress, action panel
- `/chains` — chain templates list
  - `/chains/[id]` — template editor (rules + steps)
- `/queue` — current user's pending approvals (alias of `/invoices?assignee=me&status=pending`)
- `/audit` — exportable audit log viewer
- `/settings`
  - `/settings/profile`
  - `/settings/members` — invite, role changes, seat count
  - `/settings/billing` — Stripe Customer Portal link, current plan, usage
  - `/settings/integrations` — NetSuite, QBO, Slack, email-in address

## Layouts
- `(marketing)/layout.tsx` — top nav, footer, no auth
- `(app)/layout.tsx` — sidebar (nav), top bar (org switcher, user menu), Clerk provider
- `(app)/settings/layout.tsx` — sub-nav for settings sections

## Design system
Built on **Radix Primitives** + **Tailwind**, no off-the-shelf component lib. We extracted shadcn-style primitives into `components/ui/` and own them.

Tokens (Tailwind `theme.extend`):
- Colors: neutral-scale (zinc), accent (indigo-600), semantic (success, warn, danger)
- Spacing: 4px base, density-tuned (lists use `py-2` not `py-4`)
- Typography: Inter via `next/font`, mono = JetBrains Mono for amounts/IDs

## Shared components
- `components/ui/` — `Button`, `Dialog`, `DropdownMenu`, `Tooltip`, `Toast`, `Combobox`, `DataTable` (TanStack Table wrapper), `DateRangePicker`, `Sheet`
- `components/shared/` — `OrgSwitcher`, `UserMenu`, `EmptyState`, `ErrorState`, `PageHeader`, `Breadcrumbs`
- `components/invoices/` — `InvoiceListTable` (RSC), `InvoiceFilters` (client, syncs to URL), `ApprovalActions` (client, server-action form), `ChainProgress` (RSC), `PdfViewer` (client, react-pdf)
- `components/chains/` — `ChainTemplateEditor` (client, dnd-kit for step reorder), `RuleBuilder` (client)

## Component-tree pattern
RSC list pages render the data table server-side. Filter UI is a small client component that updates `searchParams` via `router.replace`. The list re-renders on the server without a full nav. Action buttons inside rows are client components that wrap server actions in `<form>`.

## Keyboard shortcuts
Global cmd-k command palette (`cmdk`). On `/invoices`: `j/k` navigate rows, `a` approve, `r` reject, `o` open detail. Bound via a single `useGlobalHotkeys` hook on the (app) layout.
