-- NGIS: Affective Domain + Psychomotor ratings (A/B/C/D/F) for the termly report card.
-- Run ONCE in Supabase > SQL Editor. Safe to re-run.
create table if not exists public.term_report_traits(
  student_id text not null,
  term_id text not null,
  session_id text not null,
  class_id text,
  ratings jsonb default '{}'::jsonb,
  updated_by text,
  updated_at timestamptz default now(),
  primary key (student_id, term_id, session_id)
);
alter table public.term_report_traits enable row level security;
drop policy if exists "trt_all" on public.term_report_traits;
create policy "trt_all" on public.term_report_traits for all using (true) with check (true);
notify pgrst, 'reload schema';
