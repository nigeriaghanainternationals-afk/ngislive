-- Run once in Supabase > SQL Editor.
-- One designated class teacher per class; a teacher can head only one class.
alter table public.classes add column if not exists class_teacher_id text;

create unique index if not exists classes_one_class_per_teacher
  on public.classes (class_teacher_id) where class_teacher_id is not null;

-- OPTIONAL: pre-fill classes that currently have exactly ONE assigned teacher.
-- (Classes with two or more teachers must be set by hand in Class Teachers.)
-- update public.classes c set class_teacher_id = x.tid
-- from (select class_id, min(teacher_id::text) as tid from public.class_teachers
--       group by class_id having count(*) = 1) x
-- where x.class_id = c.id and c.class_teacher_id is null;
