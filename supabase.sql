-- Rode este script no SQL Editor do seu projeto Supabase (uma vez só).

-- Cada cota (ou presente único) é uma linha. O id é a chave primária,
-- então duas pessoas não conseguem marcar a mesma cota ao mesmo tempo.
create table if not exists public.cotas (
  id text primary key,            -- ex.: 'fraldas-1', 'carrinho-7'
  presente text not null,         -- id do presente
  n int not null,                 -- número da cota
  por text not null,              -- nome de quem marcou
  created_at timestamptz not null default now()
);

create table if not exists public.presencas (
  id uuid primary key default gen_random_uuid(),
  nome text not null,
  vai boolean not null,
  acompanhante boolean not null default false,
  created_at timestamptz not null default now()
);

-- Acesso pela chave anon (pública). Qualquer pessoa com o link pode ler,
-- marcar presentes, desmarcar e confirmar presença.
alter table public.cotas enable row level security;
alter table public.presencas enable row level security;

create policy "cotas leitura" on public.cotas for select using (true);
create policy "cotas marcar" on public.cotas for insert with check (true);
create policy "cotas desmarcar" on public.cotas for delete using (true);

create policy "presencas leitura" on public.presencas for select using (true);
create policy "presencas inserir" on public.presencas for insert with check (true);
