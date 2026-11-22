-- NGIS: Termly report card comments + "Next term begins" date.
-- Run ONCE in Supabase > SQL Editor. Safe to re-run.

-- 1) Class teacher's and Principal's comment for each pupil, per term and session
create table if not exists public.term_report_comments(
  student_id text not null,
  term_id text not null,
  session_id text not null,
  class_id text,
  teacher_comment text,
  principal_comment text,
  updated_by text,
  updated_at timestamptz default now(),
  primary key (student_id, term_id, session_id)
);

-- 2) "Next term begins" date, one per term and session (printed on every termly report card)
create table if not exists public.term_report_settings(
  term_id text not null,
  session_id text not null,
  next_term_begins date,
  updated_by text,
  updated_at timestamptz default now(),
  primary key (term_id, session_id)
);

alter table public.term_report_comments enable row level security;
alter table public.term_report_settings enable row level security;
drop policy if exists "trc_all" on public.term_report_comments;
create policy "trc_all" on public.term_report_comments for all using (true) with check (true);
drop policy if exists "trs_all" on public.term_report_settings;
create policy "trs_all" on public.term_report_settings for all using (true) with check (true);

notify pgrst, 'reload schema';
