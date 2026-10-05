-- Viện Thực Hành (05/10/2026): thêm 5 ca Nội mới (ChatGPT soạn, Claude kiểm nguồn). Additive, idempotent.
insert into y_quan_private.tu_chan_catalog(case_id, room, level, active, track)
select v.case_id, v.room, v.level, true, v.track from (values
  ('noi-noi-tiet-003','capcuu','Trung bình','noi'),
  ('noi-huyet-hoc-002','capcuu','Trung bình','noi'),
  ('noi-than-004','capcuu','Trung bình','noi'),
  ('noi-co-xuong-khop-001','capcuu','Trung bình','noi'),
  ('noi-than-kinh-003','capcuu','Dễ','noi')
) as v(case_id, room, level, track)
on conflict (case_id) do update
  set room = excluded.room, level = excluded.level, track = excluded.track, active = true;
