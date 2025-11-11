# Architecture Decision Record (ADR)

## ADR-001: Next.js App Router 分层架构设计

**状态**: 已接受
**日期**: 2025-01-30
**决策者**: 开发团队

### 背景

GoodWe 组织管理系统当前使用 Mock 数据，缺乏数据持久化和状态管理。系统需要一个清晰的分层架构来支持：

1. 数据持久化和状态管理
2. 业务逻辑封装
3. 清晰的关注点分离
4. 可测试性和可维护性
5. 符合 Next.js 最佳实践

### 决策

采用基于 Next.js App Router 的四层架构模式：

```
src/
├── app/          # UI 层 - 页面渲染
├── actions/      # Server Actions 层 - 输入输出处理
├── services/     # 业务逻辑层 - 业务规则
├── repositories/ # 数据访问层 - 数据库操作
├── lib/          # 共享工具和类型
└── types/        # TypeScript 类型定义
```

### 架构详述

#### 1. App 层 (`src/app/`)
**职责**:
- UI 页面渲染
- 用户交互处理
- 通过导入 actions 获取数据或执行操作
- 保持现有的页面和组件结构

**规则**:
- 只能调用 actions，不能直接调用 services 或 repositories
- 专注于 UI 逻辑，不包含业务逻辑
- 保持现有的 `_components` 约定

**示例**:
```typescript
// src/app/organizations/page.tsx
import { getOrganizations, createOrganization } from '@/actions/organization-actions'

export default async function OrganizationsPage() {
  const organizations = await getOrganizations()
  // UI 渲染逻辑
}
```

#### 2. Actions 层 (`src/actions/`)
**职责**:
- 使用 `"use server"` 标记的 Server Actions
- 处理输入参数验证和序列化
- 调用 services 层执行业务逻辑
- 处理错误和返回格式化结果
- 作为 App 层和 Services 层的桥梁

**规则**:
- 只能调用 services，不能直接调用 repositories
- 负责输入输出的转换和验证
- 不包含业务逻辑，只做编排

**示例**:
```typescript
// src/actions/organization-actions.ts
'use server'

import { organizationService } from '@/services/organization-service'
import { CreateOrganizationSchema } from '@/types/organization'

export async function createOrganization(formData: FormData) {
  const validated = CreateOrganizationSchema.parse(formData)
  return await organizationService.createOrganization(validated)
}
```

#### 3. Services 层 (`src/services/`)
**职责**:
- 封装业务逻辑和业务规则
- 参数校验和业务规则验证
- 组合多个 repositories 的操作
- 处理业务流程和状态转换
- 业务异常处理

**规则**:
- 只依赖 repositories 层
- 不能直接访问数据库
- 包含所有业务逻辑和规则
- 可以组合多个 repositories

**示例**:
```typescript
// src/services/organization-service.ts
import { organizationRepository } from '@/repositories/organization-repository'
import { addressRepository } from '@/repositories/address-repository'

export class OrganizationService {
  async createOrganization(data: CreateOrganizationData) {
    // 业务规则验证
    await this.validateOrganizationName(data.name)

    // 业务逻辑执行
    const organization = await organizationRepository.create(data)

    // 相关数据处理
    if (data.addresses) {
      await this.createDefaultAddresses(organization.id, data.addresses)
    }

    return organization
  }
}
```

#### 4. Repositories 层 (`src/repositories/`)
**职责**:
- 封装数据库访问逻辑 (Prisma CRUD)
- 数据模型转换 (Database ↔ Domain Models)
- 查询优化和数据缓存
- 数据库事务管理

**规则**:
- 只负责数据持久化
- 不包含业务逻辑
- 提供清晰的数据访问接口
- 处理数据库特定的操作

**示例**:
```typescript
// src/repositories/organization-repository.ts
import { prisma } from '@/lib/prisma'

export class OrganizationRepository {
  async findById(id: string) {
    return await prisma.organization.findUnique({
      where: { id },
      include: { addresses: true }
    })
  }

  async create(data: CreateOrganizationData) {
    return await prisma.organization.create({
      data,
      include: { addresses: true }
    })
  }
}
```

### 依赖关系

```
App Layer
    ↓ (import actions)
Actions Layer
    ↓ (call services)
Services Layer
    ↓ (call repositories)
Repositories Layer
    ↓ (use Prisma)
Database
```

**严格的依赖规则**:
- 上层只能依赖下层
- 同层之间可以相互依赖
- 不允许反向依赖或跨层依赖

### 架构实施强制规则

#### 🚫 禁止的模式

**1. 跨层依赖**
```typescript
// ❌ 错误：App层直接调用Repository
import { userRepository } from '@/repositories/user-repository'

// ❌ 错误：Service层直接使用Prisma
import { prisma } from '@/lib/prisma'

// ❌ 错误：创建API Routes而不是Server Actions
export async function GET() { ... }
```

**2. 反向依赖**
```typescript
// ❌ 错误：Repository调用Service
import { userService } from '@/services/user-service'

// ❌ 错误：Service调用Action
import { createUser } from '@/actions/user-actions'
```

**3. 前端代码修改（严格禁止）**
```typescript
// ❌ 禁止：在后端开发过程中修改前端UI组件
// ❌ 禁止：更改组件布局、样式或用户交互逻辑
// ❌ 禁止：修改页面结构、路由或导航
// ❌ 禁止：更改表单字段、验证规则或UI状态管理
// ❌ 禁止：调整响应式设计、主题或视觉效果

// 🚨 严格规则：前端代码在后端开发期间为只读状态
// 后端开发者只能：
// - 创建新的 actions 文件
// - 在现有页面中 import 新的 actions
// - 替换 mock 数据调用为真实 actions 调用
```

#### ✅ 正确的模式

**1. App层：只导入Actions**
```typescript
// ✅ 正确：App层只导入Actions
import { createUser, getUsers } from '@/actions/user-actions'

export default async function UsersPage() {
  const users = await getUsers()
  return <UserList users={users} />
}
```

**2. Actions层：调用Services + 验证**
```typescript
// ✅ 正确：Actions调用Services
'use server'
import { userService } from '@/services/user-service'
import { CreateUserSchema } from '@/lib/validations'

export async function createUser(data: CreateUserRequest) {
  const validated = CreateUserSchema.parse(data)
  return await userService.createUser(validated)
}
```

**3. Services层：调用Repositories + 业务逻辑**
```typescript
// ✅ 正确：Services调用Repositories
import { userRepository } from '@/repositories/user-repository'

export class UserService {
  async createUser(data: CreateUserData) {
    // 业务规则验证
    await this.validateUserEmail(data.email)

    // 调用Repository
    return await userRepository.create(data)
  }
}
```

**4. Repositories层：只使用Prisma**
```typescript
// ✅ 正确：Repository只使用Prisma
import { prisma } from '@/lib/prisma'

export class UserRepository {
  async create(data: CreateUserData) {
    return await prisma.user.create({ data })
  }
}
```

#### 📋 实施检查清单

**创建新功能时必须遵循**：

**🚨 前端保护规则（最高优先级）**：
- [ ] ✅ **严格禁止**修改任何前端UI组件、布局、样式
- [ ] ✅ **严格禁止**更改页面结构、路由、导航或用户交互
- [ ] ✅ **严格禁止**修改表单字段、验证规则或UI状态管理
- [ ] ✅ **严格禁止**调整响应式设计、主题或视觉效果
- [ ] ✅ **仅允许**：创建actions、在现有页面import actions、替换mock数据调用

1. **✅ Actions层**
   - [ ] 使用 `'use server'` 指令
   - [ ] 只导入 Services 和 验证Schemas
   - [ ] 处理输入验证（Zod schemas）
   - [ ] 处理错误和返回统一格式
   - [ ] 调用 `revalidatePath()` 更新缓存

2. **✅ Services层**
   - [ ] 只导入 Repositories 和 类型定义
   - [ ] 实现业务逻辑和规则验证
   - [ ] 可以组合多个 Repositories
   - [ ] 不直接访问数据库
   - [ ] 抛出业务异常

3. **✅ Repositories层**
   - [ ] 只导入 Prisma 客户端和类型
   - [ ] 只包含数据访问逻辑
   - [ ] 不包含业务逻辑
   - [ ] 处理数据库特定操作
   - [ ] 返回领域模型

4. **✅ 类型安全**
   - [ ] 使用统一的类型定义
   - [ ] Request/Response 类型分离
   - [ ] Zod schemas 与 TypeScript 类型匹配

#### 🔧 架构违规检测

**自动检测规则**：
```bash
# 检测跨层依赖
grep -r "import.*repositories" src/app/
grep -r "import.*prisma" src/services/

# 检测API Routes（应该使用Server Actions）
find src/app -name "route.ts" -o -name "route.js"

# 检测反向依赖
grep -r "import.*actions" src/services/
grep -r "import.*services" src/repositories/
```

#### ⚠️ 常见违规场景

1. **直接在组件中调用Service** → 应该使用Actions
2. **在Service中直接使用Prisma** → 应该通过Repository
3. **创建API Route而不是Server Action** → 违反Next.js最佳实践
4. **在Repository中写业务逻辑** → 应该在Service层
5. **跳过验证层直接操作** → 必须通过完整链路

### 类型定义结构

```
src/types/
├── database.ts      # Prisma 生成的数据库类型
├── domain.ts        # 领域模型类型
├── api.ts           # API 请求/响应类型
└── form.ts          # 表单验证 schemas (Zod)
```

### 共享工具

```
src/lib/
├── prisma.ts        # Prisma 客户端
├── validations.ts   # Zod schemas
├── utils.ts         # 工具函数
└── constants.ts     # 常量定义
```

### 实施计划

#### 阶段 1: 基础设施搭建
1. 创建 `src/` 目录结构
2. 移动现有 `app/` 到 `src/app/`
3. 设置 Prisma 和数据库 schema
4. 创建基础类型定义

#### 阶段 2: Repositories 层
1. 实现 `OrganizationRepository`
2. 实现 `InventoryPlanRepository`
3. 实现 `EmissionSourceRepository`
4. 实现 `UserRepository`

#### 阶段 3: Services 层
1. 实现 `OrganizationService`
2. 实现 `CarbonAccountingService`
3. 实现 `UserManagementService`
4. 添加业务规则和验证

#### 阶段 4: Actions 层
1. 创建组织管理相关 actions
2. 创建碳核算相关 actions
3. 创建用户管理相关 actions
4. 添加错误处理和验证

#### 阶段 5: 页面迁移
1. 更新组织管理页面
2. 更新盘查计划页面
3. 更新排放目标页面
4. 移除 mock 数据依赖

### 优势

1. **清晰的关注点分离**: 每层都有明确的职责
2. **可测试性**: 每层都可以独立测试
3. **可维护性**: 业务逻辑集中在 services 层
4. **符合 Next.js 最佳实践**: 充分利用 Server Actions
5. **类型安全**: TypeScript 覆盖全部层次
6. **扩展性**: 易于添加新功能和模块

### 风险与缓解

**风险**: 初期开发复杂度增加
**缓解**: 逐步迁移，保持向后兼容

**风险**: 开发团队学习成本
**缓解**: 提供详细文档和示例代码

**风险**: 性能考虑
**缓解**: 合理使用缓存和查询优化

---

## ADR-002: 数据库策略与环境配置

**状态**: 已接受
**日期**: 2025-01-30
**决策者**: 开发团队

### 背景

需要为开发和生产环境选择合适的数据库解决方案，平衡开发效率、部署复杂度和生产性能需求。

### 决策

**开发环境**: SQLite3
**生产环境**: PostgreSQL

### 数据库配置策略

#### 开发环境 (SQLite3)
```typescript
// prisma/schema.prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "sqlite"
  url      = env("DATABASE_URL") // file:./dev.db
}
```

**优势**:
- 零配置，无需安装额外数据库服务
- 快速启动开发环境
- 文件数据库，便于版本控制和共享
- 支持完整的关系型数据库功能

#### 生产环境 (PostgreSQL)
```typescript
// prisma/schema.prisma (生产配置)
datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL") // postgresql://...
}
```

**优势**:
- 高性能和可扩展性
- 丰富的数据类型支持
- 强大的查询优化器
- 企业级特性 (JSON 支持、全文搜索等)

#### 环境配置管理
```bash
# .env.development
DATABASE_URL="file:./dev.db"

# .env.production
DATABASE_URL="postgresql://user:password@host:port/database"
```

#### Schema 兼容性保证
- 使用 Prisma 的跨数据库兼容特性
- 避免使用数据库特定功能
- 测试迁移在两种数据库上的兼容性

---

## ADR-003: React Query 状态管理策略

**状态**: 已接受
**日期**: 2025-01-30
**决策者**: 开发团队

### 背景

需要在客户端管理服务器状态，处理数据缓存、同步、后台更新等复杂场景。React Query 提供了完整的服务器状态管理解决方案。

### 决策

采用 **TanStack Query (React Query)** 作为客户端状态管理解决方案，配合 Server Actions 使用。

### 架构集成

#### 客户端查询模式
```typescript
// src/hooks/use-organizations.ts
import { useQuery } from '@tanstack/react-query'
import { getOrganizations } from '@/actions/organization-actions'

export function useOrganizations() {
  return useQuery({
    queryKey: ['organizations'],
    queryFn: getOrganizations,
    staleTime: 5 * 60 * 1000, // 5分钟
    cacheTime: 10 * 60 * 1000, // 10分钟
  })
}
```

#### 数据变更模式
```typescript
// src/hooks/use-create-organization.ts
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { createOrganization } from '@/actions/organization-actions'

export function useCreateOrganization() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: createOrganization,
    onSuccess: () => {
      // 无效化缓存，触发重新获取
      queryClient.invalidateQueries({ queryKey: ['organizations'] })
    },
  })
}
```

#### 查询键管理
```typescript
// src/lib/query-keys.ts
export const queryKeys = {
  organizations: ['organizations'] as const,
  organization: (id: string) => ['organizations', id] as const,
  inventoryPlans: ['inventory-plans'] as const,
  inventoryPlan: (id: string) => ['inventory-plans', id] as const,
  emissionSources: (orgId: string, scope: string) =>
    ['emission-sources', orgId, scope] as const,
}
```

#### 提供器配置
```typescript
// src/app/providers.tsx
'use client'

import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { ReactQueryDevtools } from '@tanstack/react-query-devtools'

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 60 * 1000, // 1分钟
      retry: (failureCount, error) => {
        if (error.status === 404) return false
        return failureCount < 3
      },
    },
  },
})

export function Providers({ children }: { children: React.ReactNode }) {
  return (
    <QueryClientProvider client={queryClient}>
      {children}
      <ReactQueryDevtools initialIsOpen={false} />
    </QueryClientProvider>
  )
}
```

### React Query 最佳实践

1. **查询键标准化**: 使用 `queryKeys` 对象统一管理
2. **错误处理**: 在 mutation 中处理错误状态
3. **乐观更新**: 对用户体验关键的操作使用乐观更新
4. **缓存策略**: 根据数据特性设置合适的 `staleTime` 和 `cacheTime`
5. **后台重新验证**: 利用 `refetchOnWindowFocus` 保持数据新鲜

---

## ADR-004: 测试驱动开发 (TDD) 方法论

**状态**: 已接受
**日期**: 2025-01-30
**决策者**: 开发团队

### 背景

为了确保代码质量、可维护性和业务逻辑的正确性，需要建立系统性的测试策略和开发流程。

### 决策

采用 **测试驱动开发 (TDD)** 方法论，结合分层架构进行全面测试覆盖。

### TDD 开发流程

#### 红-绿-重构循环
1. **红**: 编写失败的测试用例
2. **绿**: 编写最小可工作代码使测试通过
3. **重构**: 改进代码结构和质量

#### 测试金字塔策略
```
        E2E Tests (少量)
           ↑
    Integration Tests (适量)
           ↑
    Unit Tests (大量)
```

### 测试技术栈

#### 测试框架
- **Vitest**: 单元测试和集成测试
- **Playwright**: E2E 测试
- **Testing Library**: React 组件测试
- **MSW**: API 模拟

#### 配置示例
```typescript
// vitest.config.ts
import { defineConfig } from 'vitest/config'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
    setupFiles: ['./tests/setup.ts'],
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      thresholds: {
        global: {
          branches: 80,
          functions: 80,
          lines: 80,
          statements: 80
        }
      }
    }
  }
})
```

### 分层测试策略

#### 1. Repository 层测试
```typescript
// tests/repositories/organization-repository.test.ts
import { describe, it, expect, beforeEach } from 'vitest'
import { OrganizationRepository } from '@/repositories/organization-repository'

describe('OrganizationRepository', () => {
  let repository: OrganizationRepository

  beforeEach(() => {
    repository = new OrganizationRepository()
  })

  it('should create organization with valid data', async () => {
    // 红: 编写测试
    const orgData = {
      name: '测试公司',
      industry: '制造业'
    }

    const result = await repository.create(orgData)

    expect(result.id).toBeDefined()
    expect(result.name).toBe('测试公司')
  })
})
```

#### 2. Service 层测试
```typescript
// tests/services/organization-service.test.ts
import { describe, it, expect, vi } from 'vitest'
import { OrganizationService } from '@/services/organization-service'

describe('OrganizationService', () => {
  it('should validate organization name uniqueness', async () => {
    // Mock repository
    const mockRepo = {
      findByName: vi.fn().mockResolvedValue(null),
      create: vi.fn().mockResolvedValue({ id: '1', name: '新公司' })
    }

    const service = new OrganizationService(mockRepo)

    // 测试业务逻辑
    const result = await service.createOrganization({
      name: '新公司',
      industry: '制造业'
    })

    expect(mockRepo.findByName).toHaveBeenCalledWith('新公司')
    expect(result.name).toBe('新公司')
  })
})
```

### TDD 实施规范

#### 开发工作流
1. **需求分析**: 将用户故事转化为测试用例
2. **编写测试**: 先写测试，描述期望行为
3. **实现功能**: 编写最小可工作代码
4. **重构优化**: 改进代码质量和性能
5. **集成测试**: 验证组件间协作

#### 测试覆盖率要求
- **单元测试**: 90%+ 覆盖率
- **集成测试**: 80%+ 覆盖关键业务流程
- **E2E 测试**: 100% 覆盖主要用户旅程

#### 持续集成
```yaml
# .github/workflows/test.yml
name: Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm ci
      - run: npm run test:unit
      - run: npm run test:integration
      - run: npm run test:e2e
```

### 测试数据管理

#### 测试数据库
```typescript
// tests/helpers/db-setup.ts
import { PrismaClient } from '@prisma/client'

export async function setupTestDb() {
  const prisma = new PrismaClient({
    datasources: {
      db: { url: 'file:./test.db' }
    }
  })

  await prisma.$executeRaw`PRAGMA foreign_keys = ON`
  return prisma
}

export async function cleanupTestDb(prisma: PrismaClient) {
  await prisma.$disconnect()
}
```

#### 测试工厂
```typescript
// tests/factories/organization-factory.ts
import { faker } from '@faker-js/faker'

export function createOrganizationData(overrides = {}) {
  return {
    name: faker.company.name(),
    industry: '制造业',
    createdDate: new Date(),
    ...overrides
  }
}
```

### 后续决策

- ADR-005: 表单处理和验证方案
- ADR-006: 错误处理和日志记录策略
- ADR-007: API 文档和版本管理
- ADR-008: 部署和 CI/CD 流程