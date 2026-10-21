-- 교육자료 테이블
create table if not exists public.materials (
  id bigint generated always as identity primary key,
  title text not null,
  category text not null default '자료',
  description text,
  url text,
  created_at timestamptz not null default now()
);

-- 관리자 목록
create table if not exists public.materials_admins (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

alter table public.materials enable row level security;
alter table public.materials_admins enable row level security;

create or replace function public.is_materials_admin()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.materials_admins where user_id = auth.uid());
$$;

grant execute on function public.is_materials_admin() to anon, authenticated;
grant select on public.materials to anon, authenticated;
grant insert, update, delete on public.materials to authenticated;
grant select on public.materials_admins to authenticated;

drop policy if exists "public read" on public.materials;
create policy "public read" on public.materials for select using (true);

drop policy if exists "admin insert" on public.materials;
create policy "admin insert" on public.materials for insert to authenticated with check (public.is_materials_admin());

drop policy if exists "admin update" on public.materials;
create policy "admin update" on public.materials for update to authenticated using (public.is_materials_admin()) with check (public.is_materials_admin());

drop policy if exists "admin delete" on public.materials;
create policy "admin delete" on public.materials for delete to authenticated using (public.is_materials_admin());

drop policy if exists "self read" on public.materials_admins;
create policy "self read" on public.materials_admins for select to authenticated using (user_id = auth.uid());

-- 예시 자료
insert into public.materials (title, category, description, url) values
 ('신입 온보딩 가이드', '온보딩', '입사 첫 주에 필요한 내용을 정리했습니다.', null),
 ('직무 역량 체크리스트', '직무 역량', '분기별 자기 점검용 체크리스트입니다.', null),
 ('필수 교육: 정보보안', '필수 교육', '연 1회 이수해야 하는 정보보안 교육입니다.', null);
