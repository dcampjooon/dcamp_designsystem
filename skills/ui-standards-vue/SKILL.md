# batchIntelli UI Design System (Vue)

## Purpose & Philosophy

경영진용 내부 분석 대시보드. 디자인 원칙:

- **데이터 밀도 > 장식** — 모든 픽셀이 데이터 목적을 가져야 한다
- **Remove decoration test** — 시각 요소를 제거해도 데이터 이해에 영향이 없으면 제거
- **무채색 중립 베이스** — 색상은 데이터 의미 전달에만 사용 (기수 구분, 산업 분류 등)
- **한국어 우선** — Pretendard Variable 본문, 숫자는 억원/조원 단위 포맷
- **일관된 밀도** — 같은 유형의 정보는 같은 패턴으로 표현

## Hard Constraints — DO NOT

- Pretendard Variable / Geist Mono 외 폰트 사용 금지
- lucide-vue-next 외 아이콘 라이브러리 금지
- UI chrome에 raw hex 금지 — 반드시 CSS 변수 (`hsl(var(--border))`, `bg-primary` 등). 단, 차트 데이터 색상(`BATCH_COLORS` 등)은 hex 허용.
- className에 반드시 `cn()` from `@/lib/utils` 사용
- 커스텀 CSS 클래스 금지 — Tailwind 유틸리티만
- shadcn-vue style은 `new-york`
- 차트 색상 하드코딩 금지 — `BATCH_COLORS` / `INDUSTRY_COLORS` / `LOCATION_COLORS` from `@/lib/operations/format`
- 차트 컴포넌트 직접 import 금지 — `lazy-charts.ts`의 `Lazy*` 버전만 사용
- `console.log` 프로덕션 코드 금지
- 카드, 버튼, 입력 등 정적 UI에 box-shadow 금지 — 모든 구분은 `border`로 처리. (예외: 차트 Tooltip, Popover, DropdownMenu 등 floating 오버레이에만 shadow 허용)

## Required Patterns — DO

- shadcn-vue 컴포넌트 사용 (Card, Badge, Button, Dialog, Sheet, Tabs, Table)
- 모든 컴포넌트: `<script setup lang="ts">` + TypeScript props interface
- 차트: `Card > header(title) > content > div(h-[300px]) > <Bar :data :options />`
- KPI 그리드: 데이터 배열 `v-for` — 하드코딩된 반복 템플릿 금지
- 모든 비동기 콘텐츠에 스켈레톤 로딩 상태 필수
- 페이지 수직 리듬: `space-y-6` (섹션 간 24px)
- 반응형 그리드: `grid-cols-1 sm:grid-cols-2 lg:grid-cols-N gap-4`
- 숫자 포맷: `formatNumber` / `formatPercent` / `formatValuation` from `@/lib/operations/format`
- 날짜 비교: `todayKst()` from `@/lib/utils/kst-date` (UTC 금지)
- 새 차트 생성 시 `lazy-charts.ts`에 `Lazy*` export 등록 필수
- v-model 지원 시 `defineEmits` + `computed` getter/setter 패턴 사용

## Visual Anti-patterns — DO NOT

- 카드/버튼/입력에 box-shadow (floating 오버레이만 예외)
- 배경 그라데이션
- 컬러 배경 카드/섹션 (모든 카드 bg는 `bg-card`)
- `border-2` 이상의 굵은 테두리
- hover 시 transform/scale 애니메이션
- 컬러 아이콘 (아이콘은 항상 `text-muted-foreground`)
- 장식 목적의 일러스트/이미지
- 빈 상태(empty state)에 과한 장식 — 텍스트 한 줄이면 충분
- `<style scoped>` 블록 — Tailwind 유틸리티만 사용

## Compact Density Rules

테이블과 카드는 "스캔 가능한 밀도"를 유지한다:
- 테이블 셀: `text-[13px] px-4 py-2.5` — 기본 `text-sm`보다 1px 작음
- KPI 카드 헤더: `pb-2` — 라벨과 숫자 사이 최소 간격
- 뱃지: `text-xs py-0.5 px-2` — 인라인에서 행 높이를 깨뜨리지 않는 크기
- 사이드바 메뉴: `rounded-lg px-3 py-2` — 아래 메뉴 아이템 클래스 참조
- 숫자: 반드시 `tabular-nums` (고정폭 숫자) — 컬럼 정렬 유지

## Sidebar Rules

- **너비**: `w-60` (240px) 고정
- **배경색**: 순수 무채색 (`--sidebar-background: 0 0% 98%`). hue가 없는 neutral gray만 사용.
- **메뉴 아이템 클래스**: 활성/비활성 모두 아래 베이스를 공유한다:
  ```
  flex items-center gap-2.5 rounded-lg px-3 py-1.5 text-[13px] transition-colors
  ```
  - 메뉴 아이템 간격: `space-y-px` (거의 없음)
  - 그룹 간 간격: `pt-3`
  - 활성: `bg-sidebar-accent text-sidebar-accent-foreground font-medium`
  - 비활성: `text-sidebar-foreground/70 hover:bg-sidebar-accent/50 hover:text-sidebar-accent-foreground`
- **메뉴 그룹**: 모든 메뉴 항목은 반드시 그룹으로 묶는다. 그룹 헤더는 아래 클래스를 적용:
  ```
  flex w-full items-center justify-between px-3 py-1.5 text-[10px] font-semibold uppercase tracking-wider text-muted-foreground/50 hover:text-muted-foreground/80 transition-colors
  ```
- **그룹 토글**: 각 그룹은 접기/펼치기 가능. **기본값은 열림(open)**. ChevronDown/ChevronRight 아이콘 사용.
- **하단 영역**: `mt-auto border-t`로 하단 고정. 이메일만 표시 (썸네일/이름 없음) + 로그아웃 아이콘 버튼.
  ```
  <p class="truncate text-xs text-muted-foreground">이메일</p>
  <Button variant="ghost" size="icon" class="h-7 w-7"><LogOut /></Button>
  ```

## Decision Framework

### 페이지 레이아웃

- **콘텐츠 영역**: 가로 full-width (`max-w` 제한 없음), 패딩 `px-8 py-8`
- **본문 배경색**: `bg-white dark:bg-black` — 사이드바(`bg-sidebar`)와 구분
- **카드 border-radius**: `rounded-xl` — 본문 내 카드/콘텐츠 컨테이너는 모두 `rounded-xl` 사용
- **페이지 제목**: `<h1 class="text-xl md:text-2xl font-bold">제목</h1>`
- **페이지 설명**: `<p class="mt-1 text-sm text-muted-foreground">설명</p>`
- **섹션 간 간격**: `space-y-6`

### KPI 카드

- **카드 컨테이너**: `rounded-xl border bg-card p-5 flex flex-col gap-4`
- **카드 제목**: `group-data-[size=sm]/card:text-sm text-sm font-medium text-muted-foreground`
- **카드 숫자**: `text-2xl font-bold`
- **카드 설명**: `mt-1 flex items-center gap-1 text-xs text-muted-foreground`
- **카드 그리드**: `grid-cols-2 lg:grid-cols-5 gap-4`
- **아이콘**: 제목 우측에 `h-4 w-4 text-muted-foreground`

### 새 페이지 구성 순서

1. **페이지 헤더**: `h1` (text-xl md:text-2xl font-bold) + `p` (mt-1 text-sm text-muted-foreground)
2. **PageGuide**: 경영진 설명용 접이식 가이드 (선택)
3. **BatchSelector**: 기수/계열 선택 (해당 시)
4. **KPI 카드 그리드**: `grid-cols-2 lg:grid-cols-5 gap-4`
5. **콘텐츠 영역**: 차트/테이블 `grid-cols-1 lg:grid-cols-2`

### Button variant 선택

| 상황 | variant |
|------|---------|
| 필터 활성 상태 | `secondary` |
| 필터 비활성 상태 | `ghost` |
| 주요 액션 | `default` |
| 보조 액션 | `outline` |
| 위험 액션 | `destructive` |

### Badge variant 선택

| 상황 | variant |
|------|---------|
| 현재/강조 항목 | `default` |
| 일반 상태 표시 | `secondary` |
| 태그/분류 | `outline` |

### Card padding 선택

| 상황 | CardHeader |
|------|-----------|
| KPI 카드 | `pb-2` (빽빽하게) |
| 콘텐츠 카드 | 기본 `p-6` |
| 컴팩트 카드 | `pt-4 pb-3 px-4` (CardHeader 없이) |

## File Organization

```
src/views/[feature]/[Feature]View.vue       — 페이지 (Vue Router)
src/components/[feature]/*.vue              — 피처별 컴포넌트
src/components/operations/shared/*.vue      — 운영 현황 공유 컴포넌트
src/components/operations/charts/*.vue      — 차트 컴포넌트
src/components/operations/charts/lazy-charts.ts — Lazy 차트 레지스트리
src/components/dashboard/*.vue              — 사이드바, 헤더, PageGuide 등
src/components/ui/*.vue                     — shadcn-vue 관리 (수동 편집 금지)
src/lib/operations/format.ts               — 포맷팅 + 차트 색상/스타일
src/stores/*.ts                             — Pinia 스토어
src/lib/api.ts                              — API 서비스
```

## References

- 디자인 토큰 (색상, 폰트, 간격, 반경): `references/design-system.md`
- 18종 반복 UI 패턴 + 코드 예제: `references/component-patterns.md`
- Chart.js 차트 규칙 + 색상 팔레트: `references/chart-standards.md`
- 앱 초기 셋업 (인증, 레이아웃, 다크모드): `references/app-scaffold.md`
