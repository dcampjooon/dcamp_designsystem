# Design Tokens

> Source of truth: `src/style.css` + `tailwind.config.js` + `components.json`

## Fonts

### 본문 (sans)
- **Pretendard Variable**
- CDN: `https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/variable/pretendardvariable-dynamic-subset.min.css`
- CSS: `--font-sans: "Pretendard Variable", "Pretendard", -apple-system, BlinkMacSystemFont, system-ui, Roboto, sans-serif`

### 코드 (mono)
- **Geist Mono** (vite plugin 또는 CDN)
- CSS: `--font-mono: "Geist Mono", monospace`

## Color Palette (HSL)

모든 색상은 HSL CSS 변수. UI chrome은 무채색, 색상은 차트/뱃지 데이터에만.

### Light Mode (:root)

```css
--background: 0 0% 100%;          /* 흰색 */
--foreground: 0 0% 9%;            /* 거의 검정 */
--card: 0 0% 100%;
--card-foreground: 0 0% 9%;
--popover: 0 0% 100%;
--popover-foreground: 0 0% 9%;
--primary: 0 0% 9%;               /* 매우 어두운 회색 */
--primary-foreground: 0 0% 98%;
--secondary: 0 0% 96%;            /* 매우 밝은 회색 */
--secondary-foreground: 0 0% 9%;
--muted: 0 0% 96%;
--muted-foreground: 0 0% 45%;     /* 중간 회색 — 보조 텍스트 */
--accent: 0 0% 96%;
--accent-foreground: 0 0% 9%;
--destructive: 0 84% 60%;         /* 빨강 */
--destructive-foreground: 0 0% 98%;
--border: 0 0% 90%;
--input: 0 0% 90%;
--ring: 0 0% 64%;
--radius: 0.5rem;
```

### Dark Mode (.dark)

```css
--background: 0 0% 4%;
--foreground: 0 0% 98%;
--card: 0 0% 9%;
--card-foreground: 0 0% 98%;
--primary: 0 0% 98%;              /* 라이트와 반전 */
--primary-foreground: 0 0% 9%;
--secondary: 0 0% 15%;
--secondary-foreground: 0 0% 98%;
--muted: 0 0% 15%;
--muted-foreground: 0 0% 64%;
--accent: 0 0% 15%;
--accent-foreground: 0 0% 98%;
--destructive: 0 62% 50%;
--border: 0 0% 15%;
--input: 0 0% 15%;
--ring: 0 0% 84%;
```

### Brand Colors

차트/뱃지에서 브랜드 식별에 사용. Tailwind config에 등록:

```js
dcamp: {
  orange: '#FF5E27',  // 디캠프 오렌지
  purple: '#662382',  // 디캠프 퍼플
}
```

### Sidebar Colors

순수 무채색 (achromatic). 사이드바는 hue가 없는 neutral gray 계열만 사용.

```css
/* Light */
--sidebar-background: 0 0% 98%;
--sidebar-foreground: 0 0% 4%;
--sidebar-primary: 0 0% 9%;
--sidebar-primary-foreground: 0 0% 98%;
--sidebar-accent: 0 0% 96%;
--sidebar-accent-foreground: 0 0% 9%;
--sidebar-border: 0 0% 90%;
--sidebar-ring: 0 0% 63%;

/* Dark */
--sidebar-background: 0 0% 6%;
--sidebar-foreground: 0 0% 96%;
--sidebar-primary: 0 0% 98%;
--sidebar-primary-foreground: 0 0% 9%;
--sidebar-accent: 0 0% 15%;
--sidebar-accent-foreground: 0 0% 96%;
--sidebar-border: 0 0% 15%;
```

## shadcn-vue Configuration

```json
{
  "$schema": "https://shadcn-vue.com/schema.json",
  "style": "new-york",
  "typescript": true,
  "tailwind": {
    "config": "tailwind.config.js",
    "css": "src/style.css",
    "baseColor": "neutral",
    "cssVariables": true
  },
  "iconLibrary": "lucide",
  "aliases": {
    "components": "@/components",
    "utils": "@/lib/utils",
    "ui": "@/components/ui",
    "lib": "@/lib",
    "composables": "@/composables"
  }
}
```

## Border Radius System

기본값 `--radius: 0.5rem` (8px)에서 산출:

| Token | 계산 | 결과 | 용도 |
|-------|------|------|------|
| `rounded-sm` | `radius - 4px` | 4px | 작은 요소 |
| `rounded-md` | `radius - 2px` | 6px | 입력 필드 |
| `rounded-lg` | `= radius` | 8px | 버튼, 카드 |
| `rounded-full` | 9999px | pill | 뱃지 |

## Typography Hierarchy

| 요소 | 클래스 | 용도 |
|------|--------|------|
| h1 | `text-xl md:text-2xl font-bold` | 페이지 제목 |
| h2 | `text-lg font-semibold` | 섹션 제목 |
| h3 / Card Title | `text-base font-semibold` | 카드/차트 제목 |
| 본문 | `text-sm` (md: `text-base`) | 일반 텍스트 |
| 보조 설명 | `text-sm text-muted-foreground` | 부가 설명 |
| KPI 값 | `text-2xl font-bold` | 숫자, 통계 |
| 캡션/라벨 | `text-xs text-muted-foreground` | 작은 레이블 |
| 테이블 셀 | `text-[13px]` | 데이터 밀도 높은 셀 |

## Spacing System

| 용도 | Tailwind | px |
|------|----------|----|
| 인라인 요소 간격 | `gap-1` / `gap-1.5` | 4 / 6 |
| 컴포넌트 내부 간격 | `gap-2` | 8 |
| 아이템 간 간격 | `gap-3` | 12 |
| 카드 간 간격 | `gap-4` | 16 |
| 섹션 간 간격 | `gap-6` / `space-y-6` | 24 |
| 카드 패딩 | `p-4` ~ `p-6` | 16~24 |
| 메인 콘텐츠 패딩 | `p-3 md:p-6` | 12~24 |
| 헤더/사이드바 높이 | `h-12` ~ `h-14` | 48~56 |
| 기본 버튼/입력 높이 | `h-7` | 28 |
| 작은 버튼 높이 | `h-7` | 28 |
| 큰 버튼 높이 | `h-8` | 32 |

## Dark Mode

- **Provider**: Pinia store (`useThemeStore`)
- **Selector**: `.dark` class on `<html>`
- **Modes**: `light`, `dark`, `system`
- **전환**: class toggle (transition 없음 — 깜빡임 방지)
- **차트**: CSS 변수로 자동 대응
- **다크모드 입력**: `dark:bg-input/30`, `dark:hover:bg-input/50`
- **다크모드 테두리**: HSL 기반 자동 반전

## Technology Stack

- Vue 3 (Composition API, `<script setup lang="ts">`)
- Vite (빌드)
- TypeScript
- Tailwind CSS v3 (`tailwind.config.js` + `@tailwind` directives)
- Radix Vue (headless primitives)
- shadcn-vue (new-york style)
- CVA (class-variance-authority)
- `cn()` = clsx + tailwind-merge
- Pinia (상태 관리)
- Vue Router (라우팅)
- Chart.js + vue-chartjs (차트)
- @vueuse/core (컴포지션 유틸리티)
- lucide-vue-next (아이콘)
