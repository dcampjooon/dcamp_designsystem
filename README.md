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
    └── chart-standards.md            # Recharts 차트 규칙 + 색상 팔레트
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
