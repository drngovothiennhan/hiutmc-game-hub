-- Viện Thực Hành (05/10/2026): thêm 5 ca Nội lô hai (Tiêu hóa, Tim mạch, Hô hấp, Nhiễm, Nội tiết). Additive, idempotent.
insert into y_quan_private.tu_chan_catalog(case_id, room, level, active, track)
select v.case_id, v.room, v.level, true, v.track from (values
  ('noi-tieu-hoa-011','capcuu','Trung bình','noi'),
  ('noi-tim-mach-007','capcuu','Trung bình','noi'),
  ('noi-ho-hap-006','capcuu','Trung bình','noi'),
  ('noi-nhiem-003','capcuu','Khó','noi'),
  ('noi-noi-tiet-004','capcuu','Khó','noi')
) as v(case_id, room, level, track)
on conflict (case_id) do update
  set room = excluded.room, level = excluded.level, track = excluded.track, active = true;
