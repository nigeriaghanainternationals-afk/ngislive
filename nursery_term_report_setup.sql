-- NGIS: Nursery (Montessori) End-of-Term Report Card.
-- Run ONCE in Supabase > SQL Editor. Safe to re-run.

-- 1) Topics the class teacher enters for each term (one row per class per term).
--    topics = {"practical":["Pouring water","Buttoning"],"sensorial":[...], ...}  (keys = the nine learning areas)
create table if not exists public.nursery_term_topics(
  id uuid primary key default gen_random_uuid(),
  class_id text not null,
  session_id text not null,            -- the Session & Term (term id) chosen in the app
  topics jsonb not null default '{}'::jsonb,
  days_open integer,                   -- number of days school opened this term
  next_term_begins date,               -- printed on every report card of this class
  updated_by text,
  updated_at timestamptz default now(),
  unique (class_id, session_id)
);

-- 2) One report per pupil per term: the grades, comments and attendance.
--    grades = {"practical":{"o":"Mastered","t":{"Pouring water":"Developing"}}, ...}
create table if not exists public.nursery_term_reports(
  id uuid primary key default gen_random_uuid(),
  student_id text not null,
  class_id text not null,
  session_id text not null,
  class_teacher text,
  report_date date,
  grades jsonb not null default '{}'::jsonb,
  days_present integer,
  teacher_comment text,
  head_comment text,
  updated_by text,
  updated_at timestamptz default now(),
  unique (student_id, session_id)
);

alter table public.nursery_term_topics enable row level security;
alter table public.nursery_term_reports enable row level security;
drop policy if exists "ntt_all" on public.nursery_term_topics;
create policy "ntt_all" on public.nursery_term_topics for all using (true) with check (true);
drop policy if exists "ntr_all" on public.nursery_term_reports;
create policy "ntr_all" on public.nursery_term_reports for all using (true) with check (true);

notify pgrst, 'reload schema';
