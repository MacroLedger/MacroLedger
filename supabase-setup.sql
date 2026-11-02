-- Macro Ledger: database setup for Supabase.
-- Paste this whole file into Supabase > SQL Editor > New query, then press Run.
-- Safe to run more than once.

-- Your daily goals (one row per person)
create table if not exists public.profiles (
  user_id    uuid primary key references auth.users (id) on delete cascade,
  goals      jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

-- One row per person per day; that day's food entries live in "entries"
create table if not exists public.days (
  user_id    uuid not null default auth.uid() references auth.users (id) on delete cascade,
  date       date not null,
  entries    jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (user_id, date)
);

-- Row level security: each signed-in person can only ever see and change their own rows
alter table public.profiles enable row level security;
alter table public.days enable row level security;

drop policy if exists "Own profile" on public.profiles;
create policy "Own profile" on public.profiles
  for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Own days" on public.days;
create policy "Own days" on public.days
  for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- Morning weigh-ins: one weight (kg) per person per day
create table if not exists public.weights (
  user_id    uuid not null default auth.uid() references auth.users (id) on delete cascade,
  date       date not null,
  kg         numeric(5,1) not null check (kg > 0 and kg < 500),
  updated_at timestamptz not null default now(),
  primary key (user_id, date)
);
alter table public.weights enable row level security;
drop policy if exists "Own weights" on public.weights;
create policy "Own weights" on public.weights
  for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- "Delete my account and data" in Settings → Account. It only ever deletes the signed-in person's own account.
create or replace function public.delete_my_account()
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  me uuid := auth.uid();
begin
  if me is null then
    raise exception 'Not signed in';
  end if;
  delete from public.days where user_id = me;
  delete from public.weights where user_id = me;
  delete from public.profiles where user_id = me;
  delete from auth.users where id = me;
end;
$$;
revoke all on function public.delete_my_account() from public, anon;
grant execute on function public.delete_my_account() to authenticated;
