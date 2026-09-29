-- HIU Y Quan: server-owned Thap van case library (13 disease scenarios).
-- Additive: the three original scenarios keep their ids, prompts and rubric;
-- ten new scenarios are added. Scoring weights, XP and credit formulas are
-- unchanged (diagnosis 40 + Bat cuong 20 + inquiry 20 + reasoning 20).
-- Existing daily slots, visits, credits and ratings are not touched.

create table if not exists y_quan_private.case_library (
  profile_id text primary key,
  prompt text not null,
  pattern text not null,
  diagnosis_terms text[] not null check (cardinality(diagnosis_terms) > 0),
  b8c text[] not null check (cardinality(b8c) = 3),
  reasoning_groups jsonb not null check (jsonb_typeof(reasoning_groups) = 'array' and jsonb_array_length(reasoning_groups) > 0),
  active boolean not null default true,
  created_at timestamptz not null default now()
);
alter table y_quan_private.case_library enable row level security;
drop policy if exists y_quan_private_no_client_access on y_quan_private.case_library;
create policy y_quan_private_no_client_access on y_quan_private.case_library for all to public using (false) with check (false);
revoke all on y_quan_private.case_library from public, anon, authenticated;

insert into y_quan_private.case_library (profile_id, prompt, pattern, diagnosis_terms, b8c, reasoning_groups) values
('can-khi-uat-ket','Gần đây tôi hay thấy tức ở hai bên sườn, lúc có lúc không.','Can khí uất kết',
  array['can khí uất kết','can khí uất'],array['Lý','Khí trệ thiên thực','Hàn nhiệt không nổi bật'],
  '[["tình chí","cảm xúc","tâm trạng","bực bội"],["căng thẳng","áp lực","lo lắng"],["ngực sườn","tức sườn","hai bên sườn"],["đầy tức","tức nặng","căng tức"],["thở dài","thở hắt"],["kinh nguyệt","chu kỳ"]]'::jsonb),
('ty-vi-hu-han','Bụng tôi đau âm ỉ, ăn lạnh vào thì khó chịu hơn.','Tỳ vị hư hàn',
  array['tỳ vị hư hàn','tỳ vị hư'],array['Lý','Hàn','Hư'],
  '[["sợ lạnh","ghét lạnh","bụng lạnh","tay chân lạnh"],["thích ấm","thích đồ ấm","uống ấm","ưa ấm"],["ăn kém","ăn ít","chán ăn","kém ăn","nhanh no"],["đại tiện lỏng","đại tiện thường lỏng","phân lỏng","đi ngoài lỏng","tiêu chảy"],["chườm ấm","xoa ấm","chườm nóng"]]'::jsonb),
('am-hu-hoa-vuong','Chiều tối tôi hay thấy nóng âm ỉ, đêm ngủ không yên.','Âm hư hỏa vượng',
  array['âm hư hỏa vượng','âm hư hỏa'],array['Lý','Nhiệt hư','Hư'],
  '[["triều nhiệt","nóng chiều","nóng về chiều","nóng âm ỉ","nóng buổi chiều"],["mồ hôi trộm","mồ hôi khi ngủ","mồ hôi lúc ngủ","mồ hôi ban đêm","mồ hôi đêm"],["ù tai","tai ù"],["lưng gối","mỏi lưng","lưng mỏi","gối mỏi"],["khô họng","họng khô","khô miệng","miệng khô"]]'::jsonb),
('tam-ty-luong-hu','Dạo này tôi khó ngủ, hay quên và tim đập nhanh mỗi khi mệt.','Tâm Tỳ lưỡng hư',
  array['tâm tỳ lưỡng hư'],array['Lý','Hư','Hàn nhiệt không nổi bật'],
  '[["mất ngủ","khó ngủ","ngủ không sâu","hay tỉnh giấc","khó vào giấc"],["hay quên","đãng trí","kém tập trung","kém trí nhớ"],["hồi hộp","đánh trống ngực","tim đập nhanh"],["ăn kém","ăn ít","chán ăn","kém ăn","đầy bụng"],["mệt mỏi","kém sức","đuối sức","hoa mắt"],["sắc mặt nhợt","sắc mặt hơi nhợt","mặt nhợt","xanh xao","nhợt nhạt"]]'::jsonb),
('phong-han-pham-phe','Tôi bị ớn lạnh, nghẹt mũi và đau đầu từ sau hôm dầm mưa.','Phong hàn phạm Phế',
  array['phong hàn phạm phế'],array['Biểu','Hàn','Thực'],
  '[["sợ lạnh","ớn lạnh","ghét lạnh","rét"],["không ra mồ hôi","không có mồ hôi","không mồ hôi","vô hãn"],["nghẹt mũi","ngạt mũi","nước mũi trong","chảy mũi trong","sổ mũi"],["đau đầu","nhức đầu","đau gáy","gáy đau"],["đờm trắng","đờm loãng","ho đờm trắng"]]'::jsonb),
('phong-nhiet-pham-phe','Tôi sốt, đau họng và ho có đờm vàng từ hai ngày nay.','Phong nhiệt phạm Phế',
  array['phong nhiệt phạm phế'],array['Biểu','Nhiệt','Thực'],
  '[["sốt","phát nóng","nóng nhiều","nóng người"],["đau họng","họng đau","rát họng","họng sưng"],["đờm vàng","đờm đặc","ho đờm vàng"],["khát","thích uống mát","thích nước mát","uống nước mát"],["ra ít mồ hôi","có mồ hôi","mồ hôi ít","sốt không hạ"],["sợ gió","hơi sợ lạnh"]]'::jsonb),
('phe-am-hu','Tôi ho khan kéo dài, họng khô, chiều tối thấy nóng âm ỉ.','Phế âm hư',
  array['phế âm hư'],array['Lý','Nhiệt hư','Hư'],
  '[["ho khan","ho không đờm","ít đờm","ho kéo dài"],["họng khô","khô họng","khô miệng","miệng khô"],["nóng chiều","nóng về chiều","triều nhiệt","nóng âm ỉ","nóng buổi chiều"],["mồ hôi trộm","mồ hôi khi ngủ","mồ hôi lúc ngủ","mồ hôi đêm"],["giọng khàn","giọng hơi khàn","hơi khàn","khàn tiếng","khàn giọng"]]'::jsonb),
('bang-quang-thap-nhiet','Tôi đi tiểu buốt, nước tiểu vàng và đi nhiều lần trong ngày.','Bàng quang thấp nhiệt',
  array['bàng quang thấp nhiệt'],array['Lý','Nhiệt','Thực'],
  '[["tiểu buốt","tiểu rát","đau khi tiểu","buốt khi tiểu"],["nước tiểu vàng","tiểu vàng","nước tiểu sẫm","tiểu sẫm màu"],["tiểu nhiều lần","đi nhiều lần","mỗi lần ít","tiểu gắt","tiểu nhắt","đi tiểu nhiều lần"],["bụng dưới","tức bụng dưới","căng tức bụng dưới"],["khát","miệng đắng","thích uống nước mát","thích nước mát"]]'::jsonb),
('dam-thap-tro-tre','Đầu tôi nặng, người nặng nề, hay buồn nôn và nhiều đờm.','Đàm thấp trở trệ',
  array['đàm thấp trở trệ'],array['Lý','Hàn nhiệt không nổi bật','Thực'],
  '[["nặng đầu","đầu nặng","đầu như bị bịt"],["người nặng","nặng nề","chân tay nặng","mình nặng"],["buồn nôn","nôn","ăn không ngon","đầy bụng"],["nhiều đờm","đờm nhiều","khạc đờm","có đờm"],["đầy tức","tức ngực","ngực đầy","bụng đầy"],["béo ngọt","ít vận động","trời ẩm","nồm ẩm"]]'::jsonb),
('huyet-u-tro-lac','Tôi đau nhói một chỗ ở vai gáy, về đêm đau nhiều hơn.','Huyết ứ trở lạc',
  array['huyết ứ trở lạc'],array['Lý','Hàn nhiệt không nổi bật','Thực'],
  '[["đau cố định","cố định","đau một chỗ","đau không di chuyển","đau một điểm","một điểm"],["đau nhói","kim châm","châm chích","đau như dao"],["đau về đêm","đêm đau","đau tăng về đêm","đêm đau nhiều"],["ấn đau","ấn vào đau","ấn vào chỗ đau","sợ đè","không thích đè","không thích bị đè","cự án"],["môi tím","tím tối","sắc mặt sạm","thâm tím"],["va đập","chấn thương","té ngã","sau chấn thương"]]'::jsonb),
('can-duong-thuong-cang','Tôi hay đau căng đầu, chóng mặt, mặt đỏ và dễ cáu gắt.','Can dương thượng cang',
  array['can dương thượng cang'],array['Lý','Nhiệt','Hư thực thác tạp'],
  '[["đau căng đầu","nhức đầu","đau đầu","căng đầu"],["chóng mặt","hoa mắt","choáng váng"],["dễ cáu","cáu gắt","nóng nảy","bực bội","tức giận"],["mặt đỏ","đỏ mặt","bốc hỏa","bốc nóng"],["ù tai","tai ù"],["lưng gối","mỏi lưng","gối mỏi","lưng mỏi"]]'::jsonb),
('than-duong-hu','Lưng gối tôi lạnh và mỏi, đêm phải dậy tiểu nhiều lần.','Thận dương hư',
  array['thận dương hư'],array['Lý','Hàn','Hư'],
  '[["sợ lạnh","chân tay lạnh","tay chân lạnh","ghét lạnh"],["lưng gối","lưng mỏi","gối lạnh","đau lưng","lưng lạnh"],["tiểu đêm","đi tiểu đêm","tiểu nhiều về đêm","nước tiểu trong","tiểu trong"],["mệt mỏi","kém sức","đuối sức","sức lực giảm"],["phân lỏng","đại tiện lỏng","tiêu chảy","ngũ canh tả","lỏng buổi sáng"]]'::jsonb),
('khi-huyet-luong-hu','Tôi hay chóng mặt khi đứng dậy, người mệt và da xanh xao.','Khí huyết lưỡng hư',
  array['khí huyết lưỡng hư'],array['Lý','Hư','Hàn nhiệt không nổi bật'],
  '[["chóng mặt","hoa mắt","choáng khi đứng dậy"],["mệt mỏi","kém sức","đuối sức","không có sức"],["sắc mặt nhợt","mặt nhợt","xanh xao","nhợt nhạt","da xanh"],["hồi hộp","tim đập nhanh","đánh trống ngực"],["hụt hơi","khó thở khi gắng sức","ngại nói","nói nhỏ"],["kinh ít","kinh nguyệt ít","chu kỳ ít","sau ốm"]]'::jsonb)
on conflict (profile_id) do update set
  prompt = excluded.prompt,
  pattern = excluded.pattern,
  diagnosis_terms = excluded.diagnosis_terms,
  b8c = excluded.b8c,
  reasoning_groups = excluded.reasoning_groups;

-- A clinic day now draws five DIFFERENT scenarios from the library
-- (shuffled once per day) instead of repeating one of three.
create or replace function public.y_quan_open_clinic_v1(p_doctor_avatar_id text)
returns jsonb
language plpgsql
security definer
set search_path to 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
as $function$
declare
  mid uuid := private.current_member_id();
  d date := (now() at time zone 'Asia/Ho_Chi_Minh')::date;
  start_minute integer := floor(random() * 121)::integer;
begin
  if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
  if p_doctor_avatar_id not in ('male','female') then raise exception 'Doctor avatar invalid'; end if;

  insert into y_quan_private.clinics(member_id,doctor_avatar_id,is_open,last_seen_at,updated_at)
  values(mid,p_doctor_avatar_id,true,now(),now())
  on conflict(member_id) do update
  set doctor_avatar_id=excluded.doctor_avatar_id,is_open=true,last_seen_at=now(),updated_at=now();

  insert into y_quan_private.daily_slots(doctor_id,local_day,slot_no,starts_at,case_profile_id,case_prompt)
  with shuffled as (
    select l.profile_id, l.prompt,
           row_number() over (order by random()) as rn,
           count(*) over () as total
    from y_quan_private.case_library l
    where l.active
  )
  select mid,d,g.n::smallint,
         (d::timestamp + time '08:00' + make_interval(mins => start_minute + (g.n - 1) * 120))
           at time zone 'Asia/Ho_Chi_Minh',
         sh.profile_id,sh.prompt
  from generate_series(1,5) as g(n)
  join shuffled sh on sh.rn = ((g.n - 1) % sh.total) + 1
  on conflict(doctor_id,local_day,slot_no) do nothing;

  return public.y_quan_dashboard_v1();
end $function$;

-- Data-driven daily-case scoring. Same weights and formulas as before; the
-- rubric now comes from y_quan_private.case_library.
create or replace function public.y_quan_submit_daily_case_v1(
  p_slot_no smallint,
  p_answered_domains text[],
  p_diagnosis text,
  p_reasoning text
)
returns jsonb
language plpgsql
security definer
set search_path to 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
as $function$
declare
  mid uuid := private.current_member_id();
  d date := (now() at time zone 'Asia/Ho_Chi_Minh')::date;
  s y_quan_private.daily_slots%rowtype;
  lib y_quan_private.case_library%rowtype;
  valid_ids text[] := array['cold','sweat','pain','bowel','food','chest','senses','thirst','history','course'];
  answered text[];
  n integer;
  diagnosis_points integer;
  b8c_points integer;
  inquiry_points integer;
  matched integer;
  term_count integer;
  reasoning_points integer;
  score integer;
  xp integer;
  credits integer;
  normalized_diagnosis text := lower(coalesce(p_diagnosis,''));
  normalized_reasoning text := lower(coalesce(p_reasoning,''));
begin
  if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
  select * into s from y_quan_private.daily_slots
  where doctor_id=mid and local_day=d and slot_no=p_slot_no for update;
  if s.doctor_id is null then raise exception 'Daily case not found'; end if;
  if s.completed_at is not null then
    return jsonb_build_object('already_completed',true,'bot_score',s.bot_score,'experience',s.experience_awarded);
  end if;

  select coalesce(array_agg(distinct x),'{}') into answered
  from unnest(coalesce(p_answered_domains,'{}')) x where x=any(valid_ids);
  n := cardinality(answered);
  if n <> 10 then
    raise exception 'Complete all ten Thap van domains before submitting';
  end if;

  select * into lib from y_quan_private.case_library where profile_id = s.case_profile_id;
  if lib.profile_id is null then raise exception 'Case profile not found'; end if;

  diagnosis_points := case when exists (
    select 1 from unnest(lib.diagnosis_terms) t where position(t in normalized_diagnosis) > 0
  ) then 40 else 0 end;
  b8c_points := case
    when position('bát cương: ' || lower(array_to_string(lib.b8c, ' · ')) in normalized_diagnosis) > 0 then 20
    else 0 end;
  inquiry_points := round(20.0 * least(n,10) / 10);

  select count(*) into matched from jsonb_array_elements(lib.reasoning_groups) grp
  where exists (
    select 1 from jsonb_array_elements_text(grp) kw
    where position(kw in normalized_reasoning) > 0
  );
  term_count := greatest(jsonb_array_length(lib.reasoning_groups), 1);
  reasoning_points := round(20.0 * matched / term_count);
  score := least(100,diagnosis_points+b8c_points+inquiry_points+reasoning_points);
  xp := score;
  credits := floor(score/20.0);

  update y_quan_private.daily_slots
  set completed_at=now(),bot_score=score,experience_awarded=xp
  where doctor_id=mid and local_day=d and slot_no=p_slot_no;
  update y_quan_private.clinics
  set experience=experience+xp,updated_at=now(),last_seen_at=now()
  where member_id=mid;
  insert into y_quan_private.credit_ledger(member_id,source_kind,source_id,delta,metadata)
  values(mid,'case',s.slot_id,credits,jsonb_build_object(
    'bot_score',score,'experience',xp,'full',score=100,'case_profile_id',s.case_profile_id
  ))
  on conflict(member_id,source_kind,source_id) do nothing;
  return jsonb_build_object(
    'bot_score',score,'bot_stars',case when score>=90 then 5 when score>=80 then 4 when score>=65 then 3 when score>=50 then 2 else 1 end,
    'experience',xp,'credits',credits,'full_case',score=100
  );
end $function$;
