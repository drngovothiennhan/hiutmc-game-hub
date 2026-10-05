-- Viện Thực Hành (05/10/2026): thêm 5 ca Nội lô ba (Tiêu hóa gan mật, Thận, Thần kinh, Huyết học, Cơ xương khớp). Additive, idempotent.
insert into y_quan_private.tu_chan_catalog(case_id, room, level, active, track)
select v.case_id, v.room, v.level, true, v.track from (values
  ('noi-tieu-hoa-012','capcuu','Trung bình','noi'),
  ('noi-than-005','capcuu','Khó','noi'),
  ('noi-than-kinh-004','capcuu','Khó','noi'),
  ('noi-huyet-hoc-003','capcuu','Khó','noi'),
  ('noi-co-xuong-khop-002','capcuu','Trung bình','noi')
) as v(case_id, room, level, track)
on conflict (case_id) do update
  set room = excluded.room, level = excluded.level, track = excluded.track, active = true;
