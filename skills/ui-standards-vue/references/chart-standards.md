# Chart Standards (Vue + Chart.js)

Chart.js + vue-chartjs 기반 차트 규칙. 모든 차트는 이 표준을 따릅니다.

> 색상/스타일 상수: `src/lib/operations/format.ts`

## Required Setup

모든 차트 컴포넌트에서 Chart.js를 등록해야 합니다:

```ts
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  BarElement,
  LineElement,
  PointElement,
  ArcElement,
  Tooltip,
  Legend,
  Filler,
} from 'chart.js'

// 사용하는 요소만 등록
ChartJS.register(CategoryScale, LinearScale, BarElement, Tooltip, Legend)
```

## Shared Styles

모든 차트에서 import하여 사용:

```ts
import {
  TOOLTIP_STYLE,
  AXIS_TICK_STYLE,
  GRID_STYLE,
  BATCH_COLORS,
  INDUSTRY_COLORS,
  LOCATION_COLORS,
} from '@/lib/operations/format'
```

### TOOLTIP_STYLE

```ts
{
  backgroundColor: 'hsl(var(--popover))',
  titleColor: 'hsl(var(--popover-foreground))',
  bodyColor: 'hsl(var(--popover-foreground))',
  borderColor: 'hsl(var(--border))',
  borderWidth: 1,
  cornerRadius: 8,
  padding: { top: 8, bottom: 8, left: 12, right: 12 },
  titleFont: { size: 13, family: 'Pretendard Variable' },
  bodyFont: { size: 13, family: 'Pretendard Variable' },
  boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)',  // floating 오버레이 예외
}
```

### AXIS_TICK_STYLE

```ts
{
  color: 'hsl(var(--muted-foreground))',
  font: { size: 12, family: 'Pretendard Variable' },
}
```

### GRID_STYLE

```ts
{
  color: 'hsl(var(--border))',
  drawBorder: false,
}
```

## Color Palettes

### BATCH_COLORS (기수별)

```ts
{
  1: '#94a3b8',  // slate-400
  2: '#a1a1aa',  // zinc-400
  3: '#a3a3a3',  // neutral-400
  4: '#78716c',  // stone-500
  5: '#6366f1',  // indigo-500
  6: '#8b5cf6',  // violet-500
  7: '#f97316',  // orange-500 (현재 기수 강조)
}
```

규칙: **현재/최신 기수는 항상 orange (#f97316)**로 강조.

### INDUSTRY_COLORS (산업분야, 21색 순환)

```ts
[
  '#6366f1', '#8b5cf6', '#a78bfa', '#c084fc',  // 보라 계열
  '#f97316', '#fb923c', '#fdba74',              // 주황 계열
  '#10b981', '#34d399', '#6ee7b7',              // 초록 계열
  '#3b82f6', '#60a5fa', '#93c5fd',              // 파랑 계열
  '#ef4444', '#f87171',                         // 빨강 계열
  '#eab308', '#facc15',                         // 노랑 계열
  '#ec4899', '#f472b6',                         // 핑크 계열
  '#14b8a6', '#2dd4bf',                         // 청록 계열
]
```

### LOCATION_COLORS (지역, 17색)

```ts
[
  '#3b82f6', '#6366f1', '#8b5cf6', '#a78bfa',
  '#10b981', '#14b8a6', '#06b6d4',
  '#f97316', '#eab308', '#ef4444',
  '#ec4899', '#78716c', '#94a3b8',
  '#64748b', '#6b7280', '#71717a', '#737373',
]
```

### Brand Colors (dcamp)

```ts
{
  seolleung: { bg: 'rgba(255, 94, 39, 0.7)', border: '#FF5E27' },  // 디캠프 선릉
  mapo: { bg: 'rgba(102, 35, 130, 0.7)', border: '#662382' },      // 디캠프 마포
}
```

## Chart Component Structure

모든 차트 파일은 이 구조를 따릅니다:

```vue
<script setup lang="ts">
import { computed } from 'vue'
import { Bar } from 'vue-chartjs'
import {
  Chart as ChartJS,
  CategoryScale, LinearScale, BarElement, Tooltip, Legend,
} from 'chart.js'
import { TOOLTIP_STYLE, AXIS_TICK_STYLE, GRID_STYLE } from '@/lib/operations/format'

ChartJS.register(CategoryScale, LinearScale, BarElement, Tooltip, Legend)

interface Props {
  data: SomeType
}

const props = defineProps<Props>()

const chartData = computed(() => ({
  labels: props.data.map(d => d.label),
  datasets: [{
    label: '지원수',
    data: props.data.map(d => d.value),
    backgroundColor: '#FF5E27',
    borderColor: '#FF5E27',
    borderWidth: 1,
    borderRadius: 4,
  }],
}))

const chartOptions = computed(() => ({
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: { display: false },
    tooltip: TOOLTIP_STYLE,
  },
  scales: {
    x: { ticks: AXIS_TICK_STYLE, grid: { display: false } },
    y: { ticks: AXIS_TICK_STYLE, grid: GRID_STYLE, beginAtZero: true },
  },
}))
</script>

<template>
  <div class="rounded-lg border bg-card">
    <div class="px-4 py-3 border-b">
      <span class="text-base font-semibold">차트 제목</span>
    </div>
    <div class="px-4 py-3">
      <div class="h-[300px]">
        <Bar :data="chartData" :options="chartOptions" />
      </div>
    </div>
  </div>
</template>
```

## Chart Types & Patterns

### Vertical Bar Chart (수직 막대)

- 높이: `h-[300px]` 고정
- borderRadius: `4` (상단 모서리 둥글게)
- vue-chartjs: `<Bar :data :options />`

### Horizontal Bar Chart (수평 막대)

- 높이: **동적** — `Math.max(350, data.length * 32) + 'px'`
- indexAxis: `'y'` (Chart.js v4 수평 모드)
- borderRadius: `4`
- 좌측 여백: `scales.y.ticks.padding: 8`

```ts
const options = computed(() => ({
  indexAxis: 'y' as const,
  responsive: true,
  maintainAspectRatio: false,
  // ...
}))
```

### Line Chart (라인)

- 높이: `h-[350px]`
- 현재 기수: `borderWidth: 3`, 불투명, orange
- 이전 기수: `borderWidth: 2`, `borderColor: alpha 0.7`
- 과거 기수: `borderWidth: 1`, `borderColor: alpha 0.35`
- `pointRadius: 0` (포인트 숨김)
- `tension: 0.3` (약간 곡선)

```ts
import { Line } from 'vue-chartjs'
import { LineElement, PointElement, Filler } from 'chart.js'

ChartJS.register(LineElement, PointElement, Filler)
```

### Stacked Bar Chart (스택 막대)

- `scales.x.stacked: true`, `scales.y.stacked: true`
- 각 dataset에 고유 색상

```vue
<script setup lang="ts">
const chartOptions = computed(() => ({
  responsive: true,
  maintainAspectRatio: false,
  scales: {
    x: { stacked: true, ticks: AXIS_TICK_STYLE },
    y: { stacked: true, beginAtZero: true, ticks: { ...AXIS_TICK_STYLE, precision: 0 } },
  },
}))
</script>
```

### Doughnut / Pie Chart

```ts
import { Doughnut } from 'vue-chartjs'
import { ArcElement } from 'chart.js'

ChartJS.register(ArcElement, Tooltip, Legend)

// cutout: '60%' for doughnut, '0%' for pie
```

## View Mode Toggle (일별/주별/월별)

차트 상단 헤더에 뷰 모드 전환 버튼:

```vue
<script setup lang="ts">
import { ref } from 'vue'

type ViewMode = 'days' | 'weeks' | 'months'
const viewMode = ref<ViewMode>('weeks')

const modes: { key: ViewMode; label: string }[] = [
  { key: 'days', label: '일별' },
  { key: 'weeks', label: '주별' },
  { key: 'months', label: '월별' },
]
</script>

<template>
  <div class="flex items-center justify-between px-4 py-3 border-b">
    <span class="text-sm font-semibold">차트 제목</span>
    <div class="flex gap-1">
      <button
        v-for="m in modes"
        :key="m.key"
        :class="[
          'px-2 py-0.5 text-xs rounded transition-colors',
          viewMode === m.key
            ? 'bg-primary text-primary-foreground'
            : 'bg-muted text-muted-foreground hover:bg-accent',
        ]"
        @click="viewMode = m.key"
      >
        {{ m.label }}
      </button>
    </div>
  </div>
</template>
```

## Tooltip Formatting

항상 수치 + 단위/퍼센트 포함:

```ts
tooltip: {
  ...TOOLTIP_STYLE,
  callbacks: {
    label: (ctx: any) => `${ctx.dataset.label}: ${formatNumber(ctx.raw)}건`,
  },
}
```

복합 포맷: `` `${value}건 (${pct}%)` ``

## Lazy Loading (필수)

모든 차트는 `lazy-charts.ts`에 등록 후 사용:

```ts
// 1. 차트 컴포넌트 생성: charts/MyChart.vue
// 2. lazy-charts.ts에 등록
import { defineAsyncComponent } from 'vue'
import ChartSkeleton from './ChartSkeleton.vue'

export const LazyMyChart = defineAsyncComponent({
  loader: () => import('./MyChart.vue'),
  loadingComponent: ChartSkeleton,
})

// 3. 페이지에서 Lazy 버전만 import
import { LazyMyChart } from '@/components/operations/charts/lazy-charts'
```

직접 import 금지: ~~`import MyChart from './charts/MyChart.vue'`~~

## Annotation Plugin (참조선)

목표선/이벤트 표시 시 `chartjs-plugin-annotation` 사용:

```ts
import annotationPlugin from 'chartjs-plugin-annotation'
ChartJS.register(annotationPlugin)

const options = computed(() => ({
  plugins: {
    annotation: {
      annotations: {
        targetLine: {
          type: 'line',
          yMin: targetValue,
          yMax: targetValue,
          borderColor: '#f97316',
          borderDash: [6, 4],
          borderWidth: 1,
          label: { display: true, content: '타겟', position: 'end' },
        },
      },
    },
  },
}))
```
