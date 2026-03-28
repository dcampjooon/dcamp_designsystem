# App Scaffold (Vue)

프로젝트를 새로 구성할 때 필요한 인증, 레이아웃, 다크모드 패턴.
이 가이드대로 구현하면 기존 batchIntelli와 동일한 기반 구조가 만들어집니다.

## 1. Vite + Vue 프로젝트 구조

```
project-root/
├── index.html
├── vite.config.ts
├── tailwind.config.js
├── components.json            ← shadcn-vue 설정
├── src/
│   ├── main.ts                ← 앱 진입점
│   ├── App.vue                ← 루트 컴포넌트
│   ├── style.css              ← 글로벌 CSS + 디자인 토큰
│   ├── router/index.ts        ← Vue Router 설정
│   ├── stores/                ← Pinia 스토어
│   │   ├── auth.ts
│   │   └── theme.ts
│   ├── lib/
│   │   ├── utils.ts           ← cn() 유틸리티
│   │   ├── api.ts             ← API 서비스
│   │   └── operations/format.ts
│   ├── components/
│   │   ├── ui/                ← shadcn-vue (수동 편집 금지)
│   │   ├── layout/            ← 사이드바, 헤더
│   │   └── dashboard/         ← 대시보드 컴포넌트
│   └── views/                 ← 페이지 컴포넌트
└── public/
```

## 2. Main Entry (main.ts)

```ts
import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import router from './router'
import './style.css'

const app = createApp(App)
app.use(createPinia())
app.use(router)
app.mount('#app')
```

## 3. Global CSS (style.css)

```css
@import url('https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/variable/pretendardvariable-dynamic-subset.min.css');

@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 0 0% 9%;
    --card: 0 0% 100%;
    --card-foreground: 0 0% 9%;
    --popover: 0 0% 100%;
    --popover-foreground: 0 0% 9%;
    --primary: 0 0% 9%;
    --primary-foreground: 0 0% 98%;
    --secondary: 0 0% 96%;
    --secondary-foreground: 0 0% 9%;
    --muted: 0 0% 96%;
    --muted-foreground: 0 0% 45%;
    --accent: 0 0% 96%;
    --accent-foreground: 0 0% 9%;
    --destructive: 0 84% 60%;
    --destructive-foreground: 0 0% 98%;
    --border: 0 0% 90%;
    --input: 0 0% 90%;
    --ring: 0 0% 64%;
    --radius: 0.5rem;

    /* Sidebar */
    --sidebar-background: 0 0% 98%;
    --sidebar-foreground: 240 5.3% 26.1%;
    --sidebar-primary: 240 5.9% 10%;
    --sidebar-primary-foreground: 0 0% 98%;
    --sidebar-accent: 240 4.8% 95.9%;
    --sidebar-accent-foreground: 240 5.9% 10%;
    --sidebar-border: 220 13% 91%;
  }

  .dark {
    --background: 0 0% 4%;
    --foreground: 0 0% 98%;
    --card: 0 0% 9%;
    --card-foreground: 0 0% 98%;
    --primary: 0 0% 98%;
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

    /* Sidebar */
    --sidebar-background: 240 5.9% 10%;
    --sidebar-foreground: 240 4.8% 95.9%;
    --sidebar-primary: 224.3 76.3% 48%;
    --sidebar-primary-foreground: 0 0% 100%;
    --sidebar-accent: 240 3.7% 15.9%;
    --sidebar-accent-foreground: 240 4.8% 95.9%;
    --sidebar-border: 240 3.7% 15.9%;
  }
}

@layer base {
  * {
    @apply border-border;
  }
  body {
    @apply bg-background text-foreground font-sans antialiased;
  }
}
```

## 4. Tailwind Config (tailwind.config.js)

```js
/** @type {import('tailwindcss').Config} */
export default {
  darkMode: ['class'],
  content: ['./index.html', './src/**/*.{vue,js,ts,jsx,tsx}'],
  theme: {
    container: {
      center: true,
      padding: '2rem',
      screens: { '2xl': '1400px' },
    },
    extend: {
      fontFamily: {
        sans: [
          'Pretendard Variable', 'Pretendard',
          '-apple-system', 'BlinkMacSystemFont', 'system-ui', 'Roboto', 'sans-serif',
        ],
      },
      colors: {
        border: 'hsl(var(--border))',
        input: 'hsl(var(--input))',
        ring: 'hsl(var(--ring))',
        background: 'hsl(var(--background))',
        foreground: 'hsl(var(--foreground))',
        primary: {
          DEFAULT: 'hsl(var(--primary))',
          foreground: 'hsl(var(--primary-foreground))',
        },
        secondary: {
          DEFAULT: 'hsl(var(--secondary))',
          foreground: 'hsl(var(--secondary-foreground))',
        },
        destructive: {
          DEFAULT: 'hsl(var(--destructive))',
          foreground: 'hsl(var(--destructive-foreground))',
        },
        muted: {
          DEFAULT: 'hsl(var(--muted))',
          foreground: 'hsl(var(--muted-foreground))',
        },
        accent: {
          DEFAULT: 'hsl(var(--accent))',
          foreground: 'hsl(var(--accent-foreground))',
        },
        popover: {
          DEFAULT: 'hsl(var(--popover))',
          foreground: 'hsl(var(--popover-foreground))',
        },
        card: {
          DEFAULT: 'hsl(var(--card))',
          foreground: 'hsl(var(--card-foreground))',
        },
        sidebar: {
          DEFAULT: 'hsl(var(--sidebar-background))',
          foreground: 'hsl(var(--sidebar-foreground))',
          border: 'hsl(var(--sidebar-border))',
          accent: 'hsl(var(--sidebar-accent))',
          'accent-foreground': 'hsl(var(--sidebar-accent-foreground))',
          primary: 'hsl(var(--sidebar-primary))',
          'primary-foreground': 'hsl(var(--sidebar-primary-foreground))',
        },
        dcamp: {
          orange: '#FF5E27',
          purple: '#662382',
        },
      },
      borderRadius: {
        lg: 'var(--radius)',
        md: 'calc(var(--radius) - 2px)',
        sm: 'calc(var(--radius) - 4px)',
      },
      keyframes: {
        'accordion-down': {
          from: { height: '0' },
          to: { height: 'var(--radix-accordion-content-height)' },
        },
        'accordion-up': {
          from: { height: 'var(--radix-accordion-content-height)' },
          to: { height: '0' },
        },
      },
      animation: {
        'accordion-down': 'accordion-down 0.2s ease-out',
        'accordion-up': 'accordion-up 0.2s ease-out',
      },
    },
  },
  plugins: [require('tailwindcss-animate'), require('@tailwindcss/typography')],
}
```

## 5. cn() Utility (lib/utils.ts)

```ts
import type { ClassValue } from 'clsx'
import { clsx } from 'clsx'
import { twMerge } from 'tailwind-merge'

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
```

## 6. Theme Store (stores/theme.ts)

```ts
import { defineStore } from 'pinia'
import { ref, watch } from 'vue'

export type ThemeMode = 'light' | 'dark' | 'system'

export const useThemeStore = defineStore('theme', () => {
  const mode = ref<ThemeMode>(
    (localStorage.getItem('theme') as ThemeMode) || 'light'
  )

  function setTheme(newMode: ThemeMode) {
    mode.value = newMode
    localStorage.setItem('theme', newMode)
    applyTheme()
  }

  function applyTheme() {
    const root = document.documentElement
    if (mode.value === 'dark' || (mode.value === 'system' && prefersDark())) {
      root.classList.add('dark')
    } else {
      root.classList.remove('dark')
    }
  }

  function prefersDark() {
    return window.matchMedia('(prefers-color-scheme: dark)').matches
  }

  // 시스템 테마 변경 감지
  watch(mode, applyTheme, { immediate: true })

  return { mode, setTheme }
})
```

## 7. Dashboard Layout (App.vue 또는 Layout 컴포넌트)

```vue
<script setup lang="ts">
import IconSidebar from '@/components/layout/IconSidebar.vue'
import SubNav from '@/components/layout/SubNav.vue'
import AppHeader from '@/components/layout/AppHeader.vue'
</script>

<template>
  <div class="flex h-dvh">
    <!-- 아이콘 사이드바 -->
    <IconSidebar />

    <!-- 서브 네비게이션 -->
    <SubNav />

    <!-- 메인 콘텐츠 -->
    <div class="flex flex-1 flex-col overflow-hidden">
      <AppHeader />
      <main class="flex-1 overflow-y-auto p-3 md:p-6">
        <RouterView />
      </main>
    </div>
  </div>
</template>
```

핵심:
- `h-dvh` (dynamic viewport height) — 모바일 주소창 대응
- `flex` 레이아웃으로 사이드바 + 콘텐츠 분리
- `overflow-y-auto` — 메인 콘텐츠만 스크롤
- `p-3 md:p-6` — 반응형 패딩

## 8. AppHeader (헤더 + 브레드크럼 + 사용자 메뉴)

```vue
<script setup lang="ts">
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import {
  DropdownMenuRoot, DropdownMenuTrigger, DropdownMenuPortal,
  DropdownMenuContent, DropdownMenuItem, DropdownMenuSeparator,
  DropdownMenuLabel, DropdownMenuRadioGroup, DropdownMenuRadioItem,
  DropdownMenuItemIndicator,
} from 'radix-vue'
import { Avatar } from '@/components/ui/avatar'
import { useAuthStore } from '@/stores/auth'
import { useThemeStore, type ThemeMode } from '@/stores/theme'
import { LogOut, Sun, Moon, Monitor, ChevronRight, Circle } from 'lucide-vue-next'

const emit = defineEmits<{ logout: [] }>()
const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()
const themeStore = useThemeStore()

const breadcrumbs = computed(() => {
  // route.path 기반으로 동적 생성
  const parts: { label: string; path?: string }[] = [{ label: 'Home', path: '/' }]
  // ... route에 따라 추가
  return parts
})

const themeOptions: { value: ThemeMode; label: string; icon: typeof Sun }[] = [
  { value: 'light', label: 'Light', icon: Sun },
  { value: 'dark', label: 'Dark', icon: Moon },
  { value: 'system', label: 'System', icon: Monitor },
]
</script>

<template>
  <header class="h-12 border-b flex items-center px-4 bg-card shrink-0 sticky top-0 z-30">
    <!-- 브레드크럼 -->
    <nav class="flex items-center gap-1 text-sm text-muted-foreground min-w-0">
      <template v-for="(crumb, index) in breadcrumbs" :key="index">
        <ChevronRight v-if="index > 0" class="h-3 w-3 shrink-0" />
        <a
          v-if="crumb.path && index < breadcrumbs.length - 1"
          href="#"
          class="truncate hover:text-foreground transition-colors"
          @click.prevent="router.push(crumb.path)"
        >
          {{ crumb.label }}
        </a>
        <span
          v-else
          :class="index === breadcrumbs.length - 1 ? 'text-foreground font-medium truncate' : 'truncate'"
        >
          {{ crumb.label }}
        </span>
      </template>
    </nav>

    <div class="flex-1" />

    <!-- 사용자 드롭다운 -->
    <DropdownMenuRoot>
      <DropdownMenuTrigger as-child>
        <button class="flex items-center gap-2 rounded-md px-2 py-1 hover:bg-accent transition-colors">
          <Avatar
            :src="authStore.user?.thumbnail_url"
            :alt="authStore.user?.name"
            :fallback="authStore.user?.name?.charAt(0)"
            size="sm"
          />
        </button>
      </DropdownMenuTrigger>

      <DropdownMenuPortal>
        <DropdownMenuContent
          align="end"
          :side-offset="8"
          class="z-50 min-w-[220px] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md"
        >
          <DropdownMenuLabel class="px-2 py-1.5">
            <div class="text-sm font-medium">{{ authStore.user?.name }}</div>
            <div class="text-xs text-muted-foreground">{{ authStore.user?.email }}</div>
          </DropdownMenuLabel>

          <DropdownMenuSeparator class="mx-1 my-1 h-px bg-border" />

          <!-- 테마 선택 -->
          <DropdownMenuRadioGroup
            :model-value="themeStore.mode"
            @update:model-value="themeStore.setTheme($event as ThemeMode)"
          >
            <DropdownMenuRadioItem
              v-for="option in themeOptions"
              :key="option.value"
              :value="option.value"
              class="relative flex cursor-pointer select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none transition-colors focus:bg-accent"
            >
              <span class="flex items-center gap-2 flex-1">
                <component :is="option.icon" class="h-3.5 w-3.5" />
                {{ option.label }}
              </span>
              <DropdownMenuItemIndicator>
                <Circle class="h-2 w-2 fill-current" />
              </DropdownMenuItemIndicator>
            </DropdownMenuRadioItem>
          </DropdownMenuRadioGroup>

          <DropdownMenuSeparator class="mx-1 my-1 h-px bg-border" />

          <DropdownMenuItem
            class="relative flex cursor-pointer select-none items-center gap-2 rounded-sm px-2 py-1.5 text-sm text-destructive"
            @select="emit('logout')"
          >
            <LogOut class="h-3.5 w-3.5" />
            로그아웃
          </DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenuPortal>
    </DropdownMenuRoot>
  </header>
</template>
```

핵심:
- Radix Vue로 접근성 있는 드롭다운 메뉴
- Pinia store로 인증/테마 상태 관리
- 브레드크럼은 `useRoute()` 기반 동적 생성
- `truncate` — 긴 텍스트 말줄임

## 9. SSO Login Page (Google + Magic Link)

```vue
<script setup lang="ts">
import { ref } from 'vue'
import { BarChart3, Mail } from 'lucide-vue-next'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'

const email = ref('')
const error = ref('')
const loading = ref(false)

async function handleGoogleLogin() {
  // Supabase Google OAuth
}

async function handleMagicLink() {
  if (!email.value.trim()) return
  loading.value = true
  error.value = ''
  try {
    // Supabase magic link
  } catch (e: any) {
    error.value = e.message
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="flex min-h-screen items-center justify-center bg-background">
    <div class="mx-auto w-full max-w-sm space-y-8 text-center">
      <!-- 로고 -->
      <div class="flex flex-col items-center gap-3">
        <div class="flex h-16 w-16 items-center justify-center rounded-2xl bg-primary/10">
          <BarChart3 class="h-8 w-8 text-primary" />
        </div>
        <div>
          <h1 class="text-2xl font-bold text-foreground">batchReport</h1>
          <p class="text-sm text-muted-foreground">디캠프 지원용 AI 분석 대시보드</p>
        </div>
      </div>

      <!-- Google SSO 버튼 -->
      <Button size="lg" class="w-full gap-3" @click="handleGoogleLogin">
        <img src="/google-icon.svg" class="h-4 w-4" alt="Google" />
        @dcamp.kr 계정으로 로그인
      </Button>

      <!-- 구분선 -->
      <div class="flex items-center gap-3">
        <div class="h-px flex-1 bg-border" />
        <span class="text-xs text-muted-foreground">또는</span>
        <div class="h-px flex-1 bg-border" />
      </div>

      <!-- 매직 링크 폼 -->
      <form class="space-y-3" @submit.prevent="handleMagicLink">
        <Input v-model="email" type="email" placeholder="외부 이메일 주소" />
        <p v-if="error" class="text-xs text-destructive">{{ error }}</p>
        <Button type="submit" variant="outline" size="lg" class="w-full gap-2" :disabled="loading">
          <Mail class="h-4 w-4" />
          이메일로 로그인 링크 받기
        </Button>
      </form>

      <!-- 안내 -->
      <p class="text-xs text-muted-foreground">
        @dcamp.kr 계정은 Google로 바로 로그인됩니다.<br />
        외부 이메일은 관리자 승인 후 사용 가능합니다.
      </p>
    </div>
  </div>
</template>
```

핵심:
- `min-h-screen items-center justify-center` — 화면 중앙 배치
- `max-w-sm` — 좁은 폼 폭
- `bg-primary/10` — 로고 배경 (투명도 10%)
- 에러: `text-xs text-destructive`

## 10. Vue Router Setup (router/index.ts)

```ts
import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/login',
      name: 'login',
      component: () => import('@/views/LoginView.vue'),
      meta: { requiresAuth: false },
    },
    {
      path: '/',
      component: () => import('@/components/layout/DashboardLayout.vue'),
      meta: { requiresAuth: true },
      children: [
        {
          path: '',
          name: 'dashboard',
          component: () => import('@/views/DashboardView.vue'),
        },
        {
          path: 'operations',
          name: 'operations',
          component: () => import('@/views/OperationsView.vue'),
        },
        {
          path: 'settings',
          name: 'settings',
          component: () => import('@/views/SettingsView.vue'),
        },
      ],
    },
  ],
})

// Auth guard
router.beforeEach(async (to) => {
  const { useAuthStore } = await import('@/stores/auth')
  const authStore = useAuthStore()

  if (to.meta.requiresAuth !== false && !authStore.isAuthenticated) {
    return { name: 'login' }
  }
  if (to.name === 'login' && authStore.isAuthenticated) {
    return { name: 'dashboard' }
  }
})

export default router
```

## 11. Supabase Client (lib/supabase.ts)

```ts
import { createClient } from '@supabase/supabase-js'

export const supabase = createClient(
  import.meta.env.VITE_SUPABASE_URL,
  import.meta.env.VITE_SUPABASE_ANON_KEY,
)
```

## 12. Auth Store (stores/auth.ts)

```ts
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { supabase } from '@/lib/supabase'
import type { User } from '@supabase/supabase-js'

export const useAuthStore = defineStore('auth', () => {
  const user = ref<User | null>(null)
  const isAuthenticated = computed(() => !!user.value)

  async function initialize() {
    const { data: { session } } = await supabase.auth.getSession()
    user.value = session?.user ?? null

    supabase.auth.onAuthStateChange((_event, session) => {
      user.value = session?.user ?? null
    })
  }

  async function signInWithGoogle() {
    const { error } = await supabase.auth.signInWithOAuth({
      provider: 'google',
      options: { redirectTo: `${window.location.origin}/auth/callback` },
    })
    if (error) throw error
  }

  async function signOut() {
    await supabase.auth.signOut()
    user.value = null
  }

  return { user, isAuthenticated, initialize, signInWithGoogle, signOut }
})
```

## 필수 환경 변수

```env
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=eyJ...
```

## 필수 패키지

```bash
npm install vue vue-router pinia @supabase/supabase-js
npm install @vueuse/core radix-vue lucide-vue-next
npm install chart.js vue-chartjs
npm install tailwindcss tailwindcss-animate @tailwindcss/typography
npm install class-variance-authority clsx tailwind-merge
npm install -D typescript vue-tsc @vitejs/plugin-vue
```
