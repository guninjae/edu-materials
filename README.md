# 교육자료실

Supabase + Vercel로 배포한 정적 교육자료 웹사이트입니다.

- `index.html` — 사이트 (자료 목록·검색·분류, 관리자 등록/수정/삭제)
- `config.js` — Supabase URL과 publishable key (RLS로 보호되므로 공개 가능)
- `supabase.sql` — 테이블·보안 정책 생성 SQL

## 관리자 추가
Supabase → Authentication → Users → Add user → Create new user 후 UUID를 복사해 SQL Editor에서 실행:

```sql
insert into public.materials_admins (user_id) values ('사용자-UUID') on conflict (user_id) do nothing;
```
