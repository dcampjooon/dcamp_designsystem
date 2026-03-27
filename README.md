<p align="center">
  <img src="favicon.svg" width="80" height="80" alt="dcamp" />
</p>

# dcamp Design System

batchIntelli 프로젝트의 UI 디자인 시스템 스킬입니다.
Claude Code에 설치하면 프론트엔드 코드 작성 시 자동으로 디자인 가이드가 적용됩니다.

## 설치

### 방법 1: 설치 스크립트 (권장)

```bash
curl -fsSL https://raw.githubusercontent.com/dcamp2/dcamp_designsystem/main/install.sh | bash
```

### 방법 2: 수동 설치

```bash
# 스킬 디렉토리 생성
mkdir -p ~/.claude/skills/ui-standards/references

# 파일 복사
curl -fsSL https://raw.githubusercontent.com/dcamp2/dcamp_designsystem/main/skills/ui-standards/SKILL.md \
  -o ~/.claude/skills/ui-standards/SKILL.md

curl -fsSL https://raw.githubusercontent.com/dcamp2/dcamp_designsystem/main/skills/ui-standards/references/design-system.md \
  -o ~/.claude/skills/ui-standards/references/design-system.md

curl -fsSL https://raw.githubusercontent.com/dcamp2/dcamp_designsystem/main/skills/ui-standards/references/component-patterns.md \
  -o ~/.claude/skills/ui-standards/references/component-patterns.md

curl -fsSL https://raw.githubusercontent.com/dcamp2/dcamp_designsystem/main/skills/ui-standards/references/chart-standards.md \
  -o ~/.claude/skills/ui-standards/references/chart-standards.md
```

### 방법 3: Git clone

```bash
git clone https://github.com/dcamp2/dcamp_designsystem.git
cp -r dcamp_designsystem/skills/ui-standards ~/.claude/skills/ui-standards
```

## 적용 방식

이 스킬은 **자동 적용 + 수동 호출** 모두 지원합니다. 프론트엔드 코드 작성 시 자동 로드되며, `/ui-standards`로 직접 호출할 수도 있습니다.

### 글로벌 설치 (위 방법대로 설치한 경우)

`~/.claude/skills/`에 설치되므로 **모든 프로젝트**에서 프론트엔드 작업 시 자동 적용됩니다.
그냥 작업을 요청하면 됩니다:

```
> 산업분야 분포 차트 만들어줘
> KPI 카드 5개짜리 대시보드 페이지 추가해줘
> 이 테이블을 Card 안에 넣어줘
```

### 특정 프로젝트에서만 사용하고 싶은 경우

프로젝트 루트에 `.claude/skills/` 디렉토리로 설치하세요:

```bash
# 프로젝트 디렉토리에서 실행
mkdir -p .claude/skills/ui-standards/references
cp -r ~/.claude/skills/ui-standards/* .claude/skills/ui-standards/
```

### 프로젝트 CLAUDE.md에 명시하기 (권장)

프로젝트의 `CLAUDE.md`에 다음을 추가하면 Claude가 더 확실하게 디자인 시스템을 인식합니다:

```markdown
## UI Standards
- 이 프로젝트는 dcamp Design System(`ui-standards` 스킬)을 따릅니다
- 프론트엔드 코드 작성 시 ui-standards 스킬의 규칙을 준수하세요
- shadcn/ui base-nova 스타일, OKLCH neutral 팔레트, Pretendard 폰트 사용
```

### 사용 예시

#### 새 페이지 생성

```
> 7기 지원 현황 대시보드 페이지 만들어줘
```

Claude가 자동으로 적용하는 것:
- 페이지 헤더 (text-xl md:text-2xl font-bold)
- KPI 카드 그리드 (grid-cols-2 lg:grid-cols-5)
- 차트는 lazy-charts.tsx 통해 lazy loading
- 숫자는 formatNumber/formatValuation으로 포맷
- space-y-6 수직 리듬
- 스켈레톤 로딩 상태

#### 새 차트 추가

```
> 지역별 분포 수평 막대 차트 추가해줘
```

Claude가 자동으로 적용하는 것:
- Card > CardHeader > CardContent > ResponsiveContainer 구조
- LOCATION_COLORS 팔레트 사용
- TOOLTIP_STYLE, AXIS_TICK_STYLE, GRID_STYLE 적용
- 동적 높이 계산 (Math.max(350, data.length * 32))
- lazy-charts.tsx에 Lazy* export 등록

#### 기존 컴포넌트 수정

```
> 이 필터 바에 산업분야 필터 추가해줘
```

Claude가 자동으로 적용하는 것:
- Button variant="secondary" (활성) / "ghost" (비활성)
- size="sm" className="text-xs h-7"
- 구분선: w-px h-4 bg-border mx-1

## 설치 확인

Claude Code를 실행한 후 스킬 목록에 `ui-standards`가 있는지 확인하세요:

```
> /skills
# ui-standards가 표시되면 성공
```

## 구조

```
skills/ui-standards/
├── SKILL.md                          # 메인 스킬 (자동 로드)
│   ├── Purpose & Philosophy          # 디자인 원칙
│   ├── Hard Constraints (DO NOT)     # 금지 사항
│   ├── Required Patterns (DO)        # 필수 패턴
│   ├── Decision Framework            # 의사결정 가이드
│   └── File Organization             # 파일 구조 규칙
└── references/
    ├── design-system.md              # 디자인 토큰 (색상, 폰트, 간격)
    ├── component-patterns.md         # 14종 반복 UI 패턴 + 코드 예제
    ├── chart-standards.md            # Recharts 차트 규칙 + 색상 팔레트
    └── app-scaffold.md               # 앱 초기 셋업 (인증, 레이아웃, 다크모드)
```

## 포함된 내용

### 디자인 토큰
- OKLCH 무채색 팔레트 (라이트/다크 모드)
- Pretendard Variable + Geist Mono 폰트
- Border radius 체계 (10px 기본)
- 간격(spacing) 시스템

### 컴포넌트 패턴 (14종)
KPI Card Grid, Stats Card, Filter Bar, Page Header, Page Guide, Chart Card,
Table in Card, Detail Dialog, Badge Row, Tabs Navigation, Loading Skeletons,
Responsive Grid, Sidebar Navigation, Lazy Chart Loading

### 차트 표준
- 공유 스타일 (TOOLTIP_STYLE, AXIS_TICK_STYLE, GRID_STYLE)
- 색상 팔레트 (BATCH_COLORS, INDUSTRY_COLORS, LOCATION_COLORS)
- 차트 유형별 패턴 (수직/수평 막대, 라인, 산점도)
- Lazy loading 등록 절차

### 앱 초기 셋업 (App Scaffold)
- Root Layout + Pretendard 폰트 + ThemeProvider
- SSO 로그인 페이지 (Google OAuth + Magic Link)
- 대시보드 레이아웃 (사이드바 + 헤더 + 모바일 대응)
- 사이드바 하단 (사용자 이메일, 로그아웃, 다크모드 토글)
- Supabase 인증 (Browser/Server 클라이언트 + Middleware + OAuth Callback)
- 필수 환경 변수 + 패키지 목록

## 기술 스택

- Next.js 15+ (App Router)
- TypeScript + Tailwind CSS v4
- shadcn/ui (base-nova style)
- Recharts
- lucide-react
- next-themes (다크모드)

## 업데이트

최신 버전으로 업데이트하려면 설치 스크립트를 다시 실행하세요:

```bash
curl -fsSL https://raw.githubusercontent.com/dcamp2/dcamp_designsystem/main/install.sh | bash
```

## 라이선스

Internal use only - dcamp
