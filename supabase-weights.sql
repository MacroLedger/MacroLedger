-- Macro Ledger: add bodyweight syncing to an existing setup.
-- Paste into Supabase > SQL Editor > New query, then press Run. Safe to run more than once.

-- Morning weigh-ins: one weight (kg) per person per day
create table if not exists public.weights (
  user_id    uuid not null default auth.uid() references auth.users (id) on delete cascade,
  date       date not null,
  kg         numeric(5,1) not null check (kg > 0 and kg < 500),
  updated_at timestamptz not null default now(),
  primary key (user_id, date)
);

-- Each signed-in person can only see and change their own weights
alter table public.weights enable row level security;
drop policy if exists "Own weights" on public.weights;
create policy "Own weights" on public.weights
  for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
