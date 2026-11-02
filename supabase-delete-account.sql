-- Macro Ledger: lets each person delete their own account and everything in it
-- (Settings → Account → Delete my account and data).
-- Paste into Supabase > SQL Editor > New query, then press Run. Safe to run more than once.

-- Runs with the owner's rights so it can remove the sign-in itself, but it only ever touches the
-- account of whoever is signed in (auth.uid()), so nobody can delete anyone else.
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
  if to_regclass('public.weights') is not null then
    execute 'delete from public.weights where user_id = $1' using me;
  end if;
  delete from public.profiles where user_id = me;
  delete from auth.users where id = me;
end;
$$;

-- Only signed-in people may call it
revoke all on function public.delete_my_account() from public, anon;
grant execute on function public.delete_my_account() to authenticated;
