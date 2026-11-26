-- NGIS register: school-wide holidays / mid-term break (run once in Supabase SQL Editor)
create table if not exists register_holidays(
  day text primary key,            -- YYYY-MM-DD
  label text not null,
  kind text default 'holiday',     -- holiday | midterm | other
  created_by text, created_at timestamptz default now());
alter table register_holidays enable row level security;
create policy "reg_hol_all" on register_holidays for all using(true) with check(true);
notify pgrst, 'reload schema';
