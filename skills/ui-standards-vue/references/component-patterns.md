# Component Patterns (Vue)

batchIntelli에서 반복되는 18종 UI 패턴. 새 기능 구현 시 이 패턴을 따르세요.

> 모든 컴포넌트는 `<script setup lang="ts">` + TypeScript props interface를 사용합니다.

## 1. KPI Card Grid

**용도**: 대시보드 상단 핵심 지표

```vue
<script setup lang="ts">
import { computed } from 'vue'
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card'
import { Building2, Users, Percent, TrendingUp } from 'lucide-vue-next'
import { formatNumber } from '@/lib/operations/format'

interface Props {
  total: number
  companies: number
  rate: number
  newCount: number
}

const props = defineProps<Props>()

const kpis = computed(() => [
  { title: '총 지원', value: formatNumber(props.total), icon: Building2, desc: '전체 지원수' },
  { title: '차주 기업수', value: formatNumber(props.companies), icon: Users, desc: '차주 지원 기업' },
  { title: '차주 비율', value: `${props.rate}%`, icon: Percent, desc: '전체 대비' },
  { title: '신규 기업수', value: formatNumber(props.newCount), icon: TrendingUp, desc: '처음 지원' },
])
</script>

<template>
  <div class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-5">
    <Card v-for="kpi in kpis" :key="kpi.title">
      <CardHeader class="flex flex-row items-center justify-between pb-2">
        <CardTitle class="text-sm font-medium text-muted-foreground">
          {{ kpi.title }}
        </CardTitle>
        <component :is="kpi.icon" class="h-4 w-4 text-muted-foreground" />
      </CardHeader>
      <CardContent>
        <div class="text-2xl font-bold tabular-nums">{{ kpi.value }}</div>
        <p class="mt-1 text-xs text-muted-foreground">{{ kpi.desc }}</p>
      </CardContent>
    </Card>
  </div>
</template>
```

## 2. Stats Card (Compact)

**용도**: 섹션 내 요약 통계 (CardHeader 없이)

```vue
<script setup lang="ts">
import type { Component } from 'vue'
import { cn } from '@/lib/utils'

interface Props {
  title: string
  value: string
  description?: string
  icon?: Component
  class?: string
}

const props = defineProps<Props>()
</script>

<template>
  <div :class="cn('rounded-lg border bg-card p-6', props.class)">
    <div class="flex items-center justify-between">
      <p class="text-sm font-medium text-muted-foreground">{{ title }}</p>
      <component :is="icon" v-if="icon" class="h-4 w-4 text-muted-foreground" />
    </div>
    <p class="mt-2 text-2xl font-bold tabular-nums">{{ value }}</p>
    <p v-if="description" class="mt-1 text-xs text-muted-foreground">{{ description }}</p>
  </div>
</template>
```

## 3. Filter Bar

**용도**: 데이터 필터링 컨트롤

```vue
<script setup lang="ts">
import { Button } from '@/components/ui/button'

interface Props {
  options: string[]
  active: Set<string>
  filteredCount: number
}

const props = defineProps<Props>()
const emit = defineEmits<{
  toggle: [option: string]
}>()

const isActive = (opt: string) => props.active.has(opt)
</script>

<template>
  <div class="flex items-center gap-2 flex-wrap">
    <span class="text-xs text-muted-foreground">라벨:</span>
    <Button
      v-for="opt in options"
      :key="opt"
      :variant="isActive(opt) ? 'secondary' : 'ghost'"
      size="sm"
      class="text-xs h-7"
      @click="emit('toggle', opt)"
    >
      {{ opt }}
    </Button>
    <div class="w-px h-4 bg-border mx-1" />
    <span class="text-xs text-muted-foreground ml-auto">
      {{ filteredCount }}건
    </span>
  </div>
</template>
```

## 4. Page Header

**용도**: 모든 페이지 상단

```vue
<template>
  <!-- 기본 -->
  <div>
    <h1 class="text-xl md:text-2xl font-bold">페이지 제목</h1>
    <p class="text-sm text-muted-foreground mt-1">한 줄 설명</p>
  </div>

  <!-- 액션 버튼 포함 -->
  <div class="flex items-center justify-between">
    <div>
      <h1 class="text-xl md:text-2xl font-bold">제목</h1>
      <p class="text-sm text-muted-foreground mt-1">설명</p>
    </div>
    <Button variant="outline" size="sm">액션</Button>
  </div>
</template>
```

## 5. Page Guide

**용도**: 경영진용 접이식 설명

```vue
<script setup lang="ts">
import { ref } from 'vue'
import { ChevronDown, ChevronUp, Info } from 'lucide-vue-next'

interface Props {
  title: string
  items: string[]
}

defineProps<Props>()

const isOpen = ref(false)
</script>

<template>
  <div class="rounded-lg border bg-card">
    <button
      class="flex w-full items-center justify-between px-4 py-3 text-sm font-medium hover:bg-accent/50 transition-colors"
      @click="isOpen = !isOpen"
    >
      <span class="flex items-center gap-2">
        <Info class="h-4 w-4 text-muted-foreground" />
        {{ title }}
      </span>
      <component :is="isOpen ? ChevronUp : ChevronDown" class="h-4 w-4 text-muted-foreground" />
    </button>
    <div v-if="isOpen" class="border-t px-4 py-3">
      <ul class="space-y-1.5 text-sm text-muted-foreground">
        <li v-for="(item, i) in items" :key="i" class="flex items-start gap-2">
          <span class="mt-1.5 h-1 w-1 shrink-0 rounded-full bg-muted-foreground" />
          {{ item }}
        </li>
      </ul>
    </div>
  </div>
</template>
```

## 6. Chart Card

**용도**: 모든 Chart.js 시각화

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
  title: string
  data: { labels: string[]; datasets: any[] }
}

const props = defineProps<Props>()

const options = computed(() => ({
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
      <span class="text-base font-semibold">{{ title }}</span>
    </div>
    <div class="px-4 py-3">
      <div class="h-[300px]">
        <Bar :data="data" :options="options" />
      </div>
    </div>
  </div>
</template>
```

## 7. Table in Card

**용도**: 카드 안에 감싼 데이터 테이블

```vue
<script setup lang="ts">
import {
  Table, TableHeader, TableBody, TableRow, TableHead, TableCell,
} from '@/components/ui/table'

interface Column {
  key: string
  label: string
  align?: 'left' | 'right'
}

interface Props {
  title: string
  columns: Column[]
  data: Record<string, any>[]
}

defineProps<Props>()
</script>

<template>
  <div class="rounded-lg border bg-card">
    <div class="px-4 py-3 border-b">
      <span class="text-base font-semibold">{{ title }}</span>
    </div>
    <div class="max-h-[400px] overflow-auto">
      <Table>
        <TableHeader>
          <TableRow class="bg-muted/50">
            <TableHead
              v-for="col in columns"
              :key="col.key"
              :class="col.align === 'right' ? 'text-right' : ''"
              class="text-xs whitespace-nowrap"
            >
              {{ col.label }}
            </TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          <TableRow v-for="(row, i) in data" :key="i" class="hover:bg-muted/30">
            <TableCell
              v-for="col in columns"
              :key="col.key"
              :class="[
                'text-[13px] whitespace-nowrap',
                col.align === 'right' ? 'text-right tabular-nums' : '',
              ]"
            >
              <slot :name="`cell-${col.key}`" :row="row" :value="row[col.key]">
                {{ row[col.key] }}
              </slot>
            </TableCell>
          </TableRow>
        </TableBody>
      </Table>
    </div>
  </div>
</template>
```

## 8. Detail Dialog

**용도**: 레코드 상세 보기

```vue
<script setup lang="ts">
import {
  Dialog, DialogContent, DialogHeader, DialogTitle,
} from '@/components/ui/dialog'

interface Field {
  label: string
  value: string | number
}

interface Props {
  open: boolean
  title: string
  fields: Field[]
}

defineProps<Props>()
const emit = defineEmits<{ 'update:open': [value: boolean] }>()
</script>

<template>
  <Dialog :open="open" @update:open="emit('update:open', $event)">
    <DialogContent class="max-w-lg max-h-[85vh] overflow-y-auto">
      <DialogHeader>
        <DialogTitle>{{ title }}</DialogTitle>
      </DialogHeader>
      <div class="space-y-2">
        <div
          v-for="field in fields"
          :key="field.label"
          class="grid grid-cols-[140px_1fr] gap-2 py-1.5 border-b border-border last:border-0"
        >
          <div class="text-sm font-medium text-muted-foreground">{{ field.label }}</div>
          <div class="text-sm">{{ field.value }}</div>
        </div>
      </div>
    </DialogContent>
  </Dialog>
</template>
```

## 9. Badge Row

**용도**: 태그/상태 표시

```vue
<script setup lang="ts">
import { Badge } from '@/components/ui/badge'

interface Props {
  status: string
  tags: string[]
}

defineProps<Props>()
</script>

<template>
  <div class="flex flex-wrap gap-1.5">
    <Badge variant="secondary" class="text-xs">{{ status }}</Badge>
    <Badge v-for="tag in tags" :key="tag" variant="outline" class="text-xs">{{ tag }}</Badge>
  </div>
</template>
```

## 10. Tabs Navigation

**용도**: 멀티뷰 페이지

```vue
<script setup lang="ts">
import { ref } from 'vue'
import { Tabs, TabsList, TabsTrigger, TabsContent } from '@/components/ui/tabs'
import { BarChart3, Table2 } from 'lucide-vue-next'

const activeTab = ref('chart')
</script>

<template>
  <Tabs v-model="activeTab" class="space-y-4">
    <TabsList>
      <TabsTrigger value="chart" class="gap-1 text-xs">
        <BarChart3 class="w-3.5 h-3.5" /> 차트
      </TabsTrigger>
      <TabsTrigger value="table" class="gap-1 text-xs">
        <Table2 class="w-3.5 h-3.5" /> 테이블
      </TabsTrigger>
    </TabsList>
    <TabsContent value="chart">
      <slot name="chart" />
    </TabsContent>
    <TabsContent value="table">
      <slot name="table" />
    </TabsContent>
  </Tabs>
</template>
```

## 11. Loading Skeletons

**용도**: 비동기 콘텐츠 로딩 상태 (필수)

```vue
<script setup lang="ts">
import { Card, CardHeader, CardContent } from '@/components/ui/card'
import { Skeleton } from '@/components/ui/skeleton'
</script>

<template>
  <!-- KPI 스켈레톤 -->
  <div class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-5">
    <Card v-for="i in 5" :key="i">
      <CardHeader class="pb-2">
        <Skeleton class="h-4 w-24" />
      </CardHeader>
      <CardContent>
        <Skeleton class="h-8 w-16" />
      </CardContent>
    </Card>
  </div>

  <!-- 차트 스켈레톤 -->
  <div class="rounded-lg border bg-card">
    <div class="px-4 py-3 border-b">
      <Skeleton class="h-5 w-32" />
    </div>
    <div class="px-4 py-3">
      <Skeleton class="h-[300px] w-full" />
    </div>
  </div>
</template>
```

## 12. Responsive Grid

**용도**: 멀티 컬럼 레이아웃

```vue
<template>
  <!-- KPI: 5열 -->
  <div class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-5">

  <!-- 차트: 2열 -->
  <div class="grid grid-cols-1 gap-4 lg:grid-cols-2">

  <!-- 통계: 3열 -->
  <div class="grid grid-cols-1 gap-4 md:grid-cols-3">
</template>
```

## 13. Sidebar Navigation

**용도**: 이미 구축됨 — 재구현 금지

새 메뉴 추가 시 `sections` 배열에 항목 추가:

```ts
{ id: 'new-page', label: '새 페이지', icon: SomeIcon }
```

## 14. Lazy Chart Loading

**용도**: 모든 차트 컴포넌트 (필수)

```ts
// lazy-charts.ts
import { defineAsyncComponent } from 'vue'
import ChartSkeleton from './ChartSkeleton.vue'

export const LazyNewChart = defineAsyncComponent({
  loader: () => import('./NewChart.vue'),
  loadingComponent: ChartSkeleton,
})
```

```vue
<!-- 페이지에서 Lazy 버전만 import -->
<script setup lang="ts">
import { LazyNewChart } from '@/components/operations/charts/lazy-charts'
</script>

<template>
  <LazyNewChart :data="chartData" />
</template>
```

직접 import 금지: ~~`import NewChart from './charts/NewChart.vue'`~~

## 15. Cohort Pill Tabs

**용도**: 대시보드 상단 기수 선택

```vue
<script setup lang="ts">
import { cn } from '@/lib/utils'
import { formatNumber } from '@/lib/operations/format'

interface CohortTab {
  batch: number
  count: number
}

interface Props {
  tabs: CohortTab[]
  activeBatch: number
}

const props = defineProps<Props>()
const emit = defineEmits<{ select: [batch: number] }>()
</script>

<template>
  <div class="flex items-center gap-2 flex-wrap">
    <button
      v-for="tab in tabs"
      :key="tab.batch"
      :class="cn(
        'inline-flex items-center rounded-full px-3 py-1 text-sm tabular-nums transition-colors',
        tab.batch === activeBatch
          ? 'bg-primary text-primary-foreground font-medium'
          : 'bg-secondary text-muted-foreground hover:bg-accent'
      )"
      @click="emit('select', tab.batch)"
    >
      {{ tab.batch }}기 {{ formatNumber(tab.count) }}건
    </button>
  </div>
</template>
```

## 16. Settings Date Range Table

**용도**: 설정 페이지의 기수별 모집 기간 관리

```vue
<script setup lang="ts">
import { Calendar, Trash2, Sparkles } from 'lucide-vue-next'
import { Input } from '@/components/ui/input'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'

interface DateRange {
  id: number
  startDate: string
  endDate: string
}

interface Props {
  ranges: DateRange[]
}

defineProps<Props>()
const emit = defineEmits<{
  add: []
  remove: [id: number]
  change: [id: number, field: 'startDate' | 'endDate', value: string]
}>()
</script>

<template>
  <div class="space-y-4">
    <div class="flex items-center gap-2">
      <Calendar class="h-5 w-5 text-muted-foreground" />
      <h2 class="text-base font-semibold">배치 모집 기간</h2>
    </div>
    <div class="space-y-2">
      <div v-for="(range, idx) in ranges" :key="range.id" class="flex items-center gap-3">
        <span class="w-8 text-center text-sm text-muted-foreground">{{ idx + 1 }}</span>
        <Badge variant="outline" class="text-xs">{{ idx + 1 }}기</Badge>
        <Input
          type="date"
          :model-value="range.startDate"
          class="w-40"
          @update:model-value="emit('change', range.id, 'startDate', $event as string)"
        />
        <span class="text-muted-foreground">~</span>
        <Input
          type="date"
          :model-value="range.endDate"
          class="w-40"
          @update:model-value="emit('change', range.id, 'endDate', $event as string)"
        />
        <Button
          variant="ghost"
          size="icon"
          class="h-7 w-7 rounded-full text-destructive hover:bg-destructive/10"
          @click="emit('remove', range.id)"
        >
          <Trash2 class="h-3.5 w-3.5" />
        </Button>
      </div>
    </div>
    <Button variant="ghost" size="sm" class="gap-1 text-sm text-muted-foreground" @click="emit('add')">
      <Sparkles class="h-3.5 w-3.5" />
      기수 추가
    </Button>
  </div>
</template>
```

## 17. Email Registration List

**용도**: 설정 페이지의 외부 사용자 이메일 등록/관리

```vue
<script setup lang="ts">
import { ref } from 'vue'
import { Trash2 } from 'lucide-vue-next'
import { Input } from '@/components/ui/input'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'

interface Props {
  emails: string[]
}

defineProps<Props>()
const emit = defineEmits<{
  add: [email: string]
  remove: [email: string]
}>()

const input = ref('')

function handleAdd() {
  if (!input.value.trim()) return
  emit('add', input.value.trim())
  input.value = ''
}
</script>

<template>
  <div class="space-y-4">
    <h2 class="text-base font-semibold">외부 이메일 등록</h2>

    <div class="flex items-center gap-2">
      <Input
        v-model="input"
        type="email"
        placeholder="이메일 주소"
        class="flex-1"
        @keyup.enter="handleAdd"
      />
      <Button variant="outline" size="sm" @click="handleAdd">등록</Button>
    </div>

    <div>
      <p class="text-sm font-medium mb-2">등록된 외부 사용자 ({{ emails.length }}명)</p>
      <div class="space-y-1.5">
        <div
          v-for="email in emails"
          :key="email"
          class="flex items-center justify-between rounded-md border px-3 py-2"
        >
          <span class="text-sm">{{ email }}</span>
          <div class="flex items-center gap-2">
            <Badge variant="secondary" class="text-xs">외부팀</Badge>
            <Button
              variant="ghost"
              size="icon"
              class="h-7 w-7 text-destructive hover:bg-destructive/10"
              @click="emit('remove', email)"
            >
              <Trash2 class="h-3.5 w-3.5" />
            </Button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
```

## 18. Full Data Table Page

**용도**: 검색+필터가 포함된 풀 페이지 데이터 테이블

```vue
<script setup lang="ts">
import { ref } from 'vue'
import { Search } from 'lucide-vue-next'
import { Input } from '@/components/ui/input'
import { Button } from '@/components/ui/button'
import {
  Table, TableHeader, TableBody, TableRow, TableHead, TableCell,
} from '@/components/ui/table'

interface Column {
  key: string
  label: string
  align?: 'left' | 'right'
}

interface FilterDef {
  key: string
  label: string
  options: string[]
}

interface Props {
  columns: Column[]
  data: Record<string, any>[]
  filters: FilterDef[]
}

defineProps<Props>()

const searchQuery = ref('')
const activeFilters = ref<Record<string, string>>({})

function resetFilters() {
  searchQuery.value = ''
  activeFilters.value = {}
}
</script>

<template>
  <div class="space-y-4">
    <!-- 검색 + 필터 바 -->
    <div class="flex items-center gap-2 flex-wrap">
      <div class="relative w-64">
        <Search class="absolute left-2.5 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
        <Input v-model="searchQuery" placeholder="검색..." class="pl-9" />
      </div>
      <select
        v-for="filter in filters"
        :key="filter.key"
        v-model="activeFilters[filter.key]"
        class="h-7 rounded-md border border-input bg-background px-3 text-sm text-muted-foreground"
      >
        <option value="">{{ filter.label }}</option>
        <option v-for="opt in filter.options" :key="opt" :value="opt">{{ opt }}</option>
      </select>
      <Button variant="ghost" size="sm" class="text-xs text-muted-foreground ml-auto" @click="resetFilters">
        초기화
      </Button>
    </div>

    <!-- 테이블 -->
    <div class="rounded-lg border overflow-hidden">
      <div class="overflow-x-auto">
        <Table>
          <TableHeader>
            <TableRow class="bg-muted/50">
              <TableHead
                v-for="col in columns"
                :key="col.key"
                :class="col.align === 'right' ? 'text-right' : ''"
                class="text-xs whitespace-nowrap"
              >
                {{ col.label }}
              </TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            <TableRow v-for="(row, i) in data" :key="i" class="hover:bg-muted/30">
              <TableCell
                v-for="col in columns"
                :key="col.key"
                :class="[
                  'text-[13px] whitespace-nowrap',
                  col.align === 'right' ? 'text-right tabular-nums' : '',
                ]"
              >
                <slot :name="`cell-${col.key}`" :row="row" :value="row[col.key]">
                  {{ row[col.key] }}
                </slot>
              </TableCell>
            </TableRow>
          </TableBody>
        </Table>
      </div>
    </div>
  </div>
</template>
```
