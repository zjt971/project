# RI-9-2：缺失模組技術解決方案規格 / Technical Solutions Specification for Missing Modules

- **文件編號**：RI-9-2
- **版本**：v1.0
- **狀態**：Draft for Architecture Review
- **作者**：Tao Yu 和他的 GPT 智能助手
- **建立日期**：2025-11-05
- **參考文件**：PRD EIS-REINS-PRD-001.md、ADR-001~008、RI-9-1實施路線圖

---

## 1. 文件目的 / Document Purpose

本文檔針對PRD中定義但尚未實作的核心模組，提供詳細的技術解決方案、資料模型設計、API規格和實作指引。每個模組都遵循既定的四層架構（ADR-001）和國際化策略（ADR-008）。

---

## 2. Facultative Management（臨分管理）技術規格

### 2.1 資料模型設計

```prisma
// 新增至 prisma/schema.prisma
model Facultative {
  id                String              @id @default(uuid())
  facultativeCode   String              @unique
  policyNumber      String
  reinsurerIds      String[]            // JSON array of reinsurer IDs
  sumInsured        Decimal
  facultativeShare  Decimal             // 臨分比例 0-100
  facultativePremium Decimal?
  lineOfBusiness    String
  effectiveDate     DateTime
  expiryDate        DateTime
  currency          String              @default("TWD")
  status            FacultativeStatus   @default(DRAFT)
  notes             String?
  attachments       Json?               // 文件附件
  createdAt         DateTime            @default(now())
  updatedAt         DateTime            @updatedAt
  
  // 關聯
  shares            FacultativeShare[]
  documents         FacultativeDocument[]
  versions          FacultativeVersion[]
  
  @@index([facultativeCode])
  @@index([policyNumber])
  @@index([status])
}

model FacultativeShare {
  id              String      @id @default(uuid())
  facultativeId   String
  reinsurerId     String
  sharePercentage Decimal
  premium         Decimal?
  commission      Decimal?
  notes           String?
  createdAt       DateTime    @default(now())
  updatedAt       DateTime    @updatedAt
  
  facultative     Facultative @relation(fields: [facultativeId], references: [id], onDelete: Cascade)
  reinsurer       Reinsurer   @relation(fields: [reinsurerId], references: [id])
  
  @@index([facultativeId])
  @@index([reinsurerId])
}

model FacultativeDocument {
  id            String      @id @default(uuid())
  facultativeId String
  fileName      String
  filePath      String
  fileSize      Int?
  mimeType      String?
  uploadedBy    String?
  uploadedAt    DateTime    @default(now())
  
  facultative   Facultative @relation(fields: [facultativeId], references: [id], onDelete: Cascade)
  
  @@index([facultativeId])
}

model FacultativeVersion {
  id            String            @id @default(uuid())
  facultativeId String
  versionNumber String
  status        FacultativeStatus
  changeSummary String?
  snapshot      Json
  createdBy     String?
  createdAt     DateTime          @default(now())
  
  facultative   Facultative       @relation(fields: [facultativeId], references: [id], onDelete: Cascade)
  
  @@unique([facultativeId, versionNumber])
  @@index([facultativeId, createdAt])
}

enum FacultativeStatus {
  DRAFT
  PENDING
  ACTIVE
  DECLINED
  EXPIRED
  CANCELLED
}
```

### 2.2 Service層實作

```typescript
// src/services/facultative-service.ts
import { facultativeRepository } from "@/repositories/facultative-repository";
import { treatyRepository } from "@/repositories/treaty-repository";
import type { CreateFacultativeRequest, FacultativeDetail } from "@/types/facultative";

export class FacultativeService {
  async createFacultative(request: CreateFacultativeRequest): Promise<FacultativeDetail> {
    // 1. 檢查是否有適用的Treaty
    const matchingTreaties = await this.findMatchingTreaties(
      request.policyNumber,
      request.lineOfBusiness,
      request.effectiveDate
    );
    
    if (matchingTreaties.length > 0) {
      // 提示用戶可能有適用的合約
      throw new FacultativeValidationError(
        'existingTreatyFound',
        'policyNumber',
        matchingTreaties[0].treatyCode
      );
    }
    
    // 2. 驗證再保人份額
    const totalShare = request.shares.reduce((sum, share) => sum + share.sharePercentage, 0);
    if (totalShare > 100) {
      throw new FacultativeValidationError('shareExceeds100', 'shares', totalShare.toString());
    }
    
    // 3. 生成臨分代號
    const facultativeCode = await this.generateFacultativeCode();
    
    // 4. 建立臨分記錄
    return facultativeRepository.createWithShares({
      ...request,
      facultativeCode,
      status: 'DRAFT'
    });
  }
  
  private async findMatchingTreaties(
    policyNumber: string,
    lineOfBusiness: string,
    effectiveDate: string
  ) {
    return treatyRepository.findApplicableTreaties({
      lineOfBusiness,
      effectiveDate: new Date(effectiveDate),
      status: 'ACTIVE'
    });
  }
  
  private async generateFacultativeCode(): Promise<string> {
    const year = new Date().getFullYear();
    const latest = await facultativeRepository.findLatestCode();
    // 格式：FAC-YYYY-XXXX
    return `FAC-${year}-${(latest?.sequence || 0) + 1}`.padStart(4, '0');
  }
}
```

---

## 3. Cession Engine（分保計算引擎）技術規格

### 3.1 計算引擎架構

```typescript
// src/services/cession-engine/calculation-engine.ts
export interface CessionCalculationInput {
  policyData: {
    policyNumber: string;
    sumInsured: Decimal;
    premium: Decimal;
    lineOfBusiness: string;
    effectiveDate: Date;
    currency: string;
  };
  treatyId?: string;
  facultativeId?: string;
  calculationDate: Date;
  calculationType: 'PREMIUM' | 'CLAIM';
  claimAmount?: Decimal;
}

export interface CessionCalculationResult {
  calculationId: string;
  policyNumber: string;
  grossAmount: Decimal;
  retentionAmount: Decimal;
  cededAmount: Decimal;
  commissionAmount: Decimal;
  netAmount: Decimal;
  currency: string;
  breakdown: CessionBreakdown[];
  calculatedAt: Date;
  calculatedBy: string;
}

export interface CessionBreakdown {
  treatyId?: string;
  facultativeId?: string;
  reinsurerId: string;
  reinsurerName: string;
  sharePercentage: Decimal;
  cededAmount: Decimal;
  commissionRate: Decimal;
  commissionAmount: Decimal;
  calculationMethod: 'QUOTA_SHARE' | 'SURPLUS' | 'EXCESS_OF_LOSS' | 'FACULTATIVE';
}

export class CessionCalculationEngine {
  async calculate(input: CessionCalculationInput): Promise<CessionCalculationResult> {
    // 1. 驗證輸入資料
    this.validateInput(input);
    
    // 2. 查找適用的合約或臨分
    const applicableContracts = await this.findApplicableContracts(input);
    
    // 3. 執行計算
    const breakdown = await this.performCalculation(input, applicableContracts);
    
    // 4. 彙總結果
    return this.aggregateResults(input, breakdown);
  }
  
  private async findApplicableContracts(input: CessionCalculationInput) {
    if (input.facultativeId) {
      return await facultativeRepository.findById(input.facultativeId);
    }
    
    if (input.treatyId) {
      return await treatyRepository.findById(input.treatyId);
    }
    
    // 自動匹配適用合約
    return await treatyRepository.findApplicableTreaties({
      lineOfBusiness: input.policyData.lineOfBusiness,
      effectiveDate: input.policyData.effectiveDate,
      sumInsured: input.policyData.sumInsured,
      status: 'ACTIVE'
    });
  }
  
  private async performCalculation(
    input: CessionCalculationInput,
    contracts: any[]
  ): Promise<CessionBreakdown[]> {
    const breakdown: CessionBreakdown[] = [];
    
    for (const contract of contracts) {
      if (contract.treatyType === 'PROPORTIONAL') {
        breakdown.push(...await this.calculateProportional(input, contract));
      } else {
        breakdown.push(...await this.calculateNonProportional(input, contract));
      }
    }
    
    return breakdown;
  }
  
  private async calculateProportional(
    input: CessionCalculationInput,
    treaty: any
  ): Promise<CessionBreakdown[]> {
    const breakdown: CessionBreakdown[] = [];
    
    for (const share of treaty.shares) {
      const sharePercentage = share.sharePercentage;
      const cededAmount = input.policyData.premium.mul(sharePercentage).div(100);
      const commissionAmount = cededAmount.mul(share.commissionRate || 0).div(100);
      
      breakdown.push({
        treatyId: treaty.id,
        reinsurerId: share.reinsurerId,
        reinsurerName: share.reinsurer.name,
        sharePercentage,
        cededAmount,
        commissionRate: share.commissionRate || new Decimal(0),
        commissionAmount,
        calculationMethod: treaty.cessionMethod
      });
    }
    
    return breakdown;
  }
  
  private async calculateNonProportional(
    input: CessionCalculationInput,
    treaty: any
  ): Promise<CessionBreakdown[]> {
    // 非比例合約計算邏輯
    const breakdown: CessionBreakdown[] = [];
    
    if (input.calculationType === 'CLAIM' && input.claimAmount) {
      const attachmentPoint = treaty.attachmentPoint || new Decimal(0);
      const limitAmount = treaty.limitAmount || new Decimal(0);
      
      if (input.claimAmount.gt(attachmentPoint)) {
        const excessAmount = input.claimAmount.sub(attachmentPoint);
        const cededAmount = Decimal.min(excessAmount, limitAmount);
        
        for (const share of treaty.shares) {
          const shareCeded = cededAmount.mul(share.sharePercentage).div(100);
          
          breakdown.push({
            treatyId: treaty.id,
            reinsurerId: share.reinsurerId,
            reinsurerName: share.reinsurer.name,
            sharePercentage: share.sharePercentage,
            cededAmount: shareCeded,
            commissionRate: share.commissionRate || new Decimal(0),
            commissionAmount: new Decimal(0), // XOL通常無佣金
            calculationMethod: 'EXCESS_OF_LOSS'
          });
        }
      }
    }
    
    return breakdown;
  }
}
```

### 3.2 批次處理系統

```typescript
// src/services/cession-engine/batch-processor.ts
export interface BatchCalculationJob {
  id: string;
  name: string;
  type: 'PREMIUM_CALCULATION' | 'CLAIM_RECOVERY';
  inputCriteria: {
    dateRange: { start: Date; end: Date };
    lineOfBusiness?: string[];
    treatyIds?: string[];
    policyNumbers?: string[];
  };
  status: 'PENDING' | 'RUNNING' | 'COMPLETED' | 'FAILED' | 'CANCELLED';
  progress: {
    totalRecords: number;
    processedRecords: number;
    successRecords: number;
    errorRecords: number;
  };
  results?: {
    outputPath: string;
    errorReportPath?: string;
    summary: BatchCalculationSummary;
  };
  createdBy: string;
  createdAt: Date;
  startedAt?: Date;
  completedAt?: Date;
  errorMessage?: string;
}

export class BatchProcessor {
  async submitBatch(job: Omit<BatchCalculationJob, 'id' | 'status' | 'progress'>): Promise<string> {
    const batchId = generateBatchId();
    
    // 儲存批次工作
    await batchRepository.create({
      ...job,
      id: batchId,
      status: 'PENDING',
      progress: { totalRecords: 0, processedRecords: 0, successRecords: 0, errorRecords: 0 }
    });
    
    // 非同步執行
    this.processBatchAsync(batchId);
    
    return batchId;
  }
  
  private async processBatchAsync(batchId: string) {
    try {
      await this.updateBatchStatus(batchId, 'RUNNING');
      
      const job = await batchRepository.findById(batchId);
      const inputData = await this.fetchInputData(job.inputCriteria);
      
      await this.updateBatchProgress(batchId, { totalRecords: inputData.length });
      
      const results = [];
      const errors = [];
      
      for (const [index, data] of inputData.entries()) {
        try {
          const result = await cessionEngine.calculate(data);
          results.push(result);
          await this.updateBatchProgress(batchId, { 
            processedRecords: index + 1,
            successRecords: results.length 
          });
        } catch (error) {
          errors.push({ data, error: error.message });
          await this.updateBatchProgress(batchId, { 
            processedRecords: index + 1,
            errorRecords: errors.length 
          });
        }
      }
      
      // 儲存結果
      const outputPath = await this.saveResults(batchId, results);
      const errorReportPath = errors.length > 0 ? await this.saveErrorReport(batchId, errors) : undefined;
      
      await this.completeBatch(batchId, {
        outputPath,
        errorReportPath,
        summary: this.generateSummary(results, errors)
      });
      
    } catch (error) {
      await this.failBatch(batchId, error.message);
    }
  }
}
```

---

## 3. Claim Recovery（理賠攤回）技術規格

### 3.1 資料模型

```prisma
model ClaimRecovery {
  id                String                @id @default(uuid())
  recoveryCode      String                @unique
  claimId           String                // 原理賠編號
  policyNumber      String
  treatyId          String?
  facultativeId     String?
  lossDate          DateTime
  reportedDate      DateTime
  grossClaimAmount  Decimal
  recoverableAmount Decimal
  cededRatio        Decimal
  currency          String                @default("TWD")
  status            ClaimRecoveryStatus   @default(PENDING)
  dueDate           DateTime?
  notes             String?
  createdAt         DateTime              @default(now())
  updatedAt         DateTime              @updatedAt
  
  // 關聯
  responses         RecoveryResponse[]
  disputes          RecoveryDispute[]
  attachments       RecoveryAttachment[]
  
  @@index([recoveryCode])
  @@index([claimId])
  @@index([status])
  @@index([dueDate])
}

model RecoveryResponse {
  id              String              @id @default(uuid())
  recoveryId      String
  reinsurerId     String
  responseStatus  ResponseStatus      @default(PENDING)
  responseDate    DateTime?
  responseMessage String?
  agreedAmount    Decimal?
  paidAmount      Decimal?
  paidDate        DateTime?
  settlementRef   String?
  createdAt       DateTime            @default(now())
  updatedAt       DateTime            @updatedAt
  
  recovery        ClaimRecovery       @relation(fields: [recoveryId], references: [id], onDelete: Cascade)
  reinsurer       Reinsurer           @relation(fields: [reinsurerId], references: [id])
  
  @@index([recoveryId])
  @@index([reinsurerId])
}

model RecoveryDispute {
  id                    String        @id @default(uuid())
  recoveryId            String
  disputeReason         String
  disputeAmount         Decimal?
  raisedBy              String        // 'CEDANT' | 'REINSURER'
  assignedTo            String?
  targetResolutionDate  DateTime?
  status                String        @default("OPEN") // OPEN | IN_PROGRESS | RESOLVED | CLOSED
  resolutionNotes       String?
  resolvedAt            DateTime?
  createdAt             DateTime      @default(now())
  updatedAt             DateTime      @updatedAt
  
  recovery              ClaimRecovery @relation(fields: [recoveryId], references: [id], onDelete: Cascade)
  
  @@index([recoveryId])
  @@index([status])
}

enum ClaimRecoveryStatus {
  PENDING
  SUBMITTED
  ACKNOWLEDGED
  AGREED
  DISPUTED
  PAID
  CLOSED
}

enum ResponseStatus {
  PENDING
  ACKNOWLEDGED
  AGREED
  DISPUTED
  DECLINED
  PAID
}
```

### 3.2 理賠攤回服務

```typescript
// src/services/claim-recovery-service.ts
export class ClaimRecoveryService {
  async createRecoveryFromClaim(claimData: ClaimData): Promise<ClaimRecoveryDetail> {
    // 1. 查找適用的合約或臨分
    const applicableContracts = await this.findApplicableContracts(claimData);
    
    if (applicableContracts.length === 0) {
      throw new ClaimRecoveryError('noApplicableContract', claimData.claimId);
    }
    
    // 2. 計算攤回金額
    const calculations = await Promise.all(
      applicableContracts.map(contract => 
        cessionEngine.calculate({
          policyData: claimData.policy,
          treatyId: contract.treatyId,
          facultativeId: contract.facultativeId,
          calculationType: 'CLAIM',
          claimAmount: claimData.claimAmount
        })
      )
    );
    
    // 3. 建立攤回記錄
    const recoveryCode = await this.generateRecoveryCode();
    const totalRecoverable = calculations.reduce(
      (sum, calc) => sum.add(calc.cededAmount), 
      new Decimal(0)
    );
    
    return claimRecoveryRepository.create({
      recoveryCode,
      claimId: claimData.claimId,
      policyNumber: claimData.policy.policyNumber,
      grossClaimAmount: claimData.claimAmount,
      recoverableAmount: totalRecoverable,
      cededRatio: totalRecoverable.div(claimData.claimAmount).mul(100),
      lossDate: claimData.lossDate,
      reportedDate: claimData.reportedDate,
      currency: claimData.currency,
      status: 'PENDING'
    });
  }
  
  async submitToReinsurers(recoveryId: string): Promise<void> {
    const recovery = await claimRecoveryRepository.findById(recoveryId);
    const reinsurers = await this.getInvolvedReinsurers(recoveryId);
    
    for (const reinsurer of reinsurers) {
      // 建立再保人回覆記錄
      await recoveryResponseRepository.create({
        recoveryId,
        reinsurerId: reinsurer.id,
        responseStatus: 'PENDING'
      });
      
      // 發送通知（郵件/API）
      await this.notifyReinsurer(reinsurer, recovery);
    }
    
    await claimRecoveryRepository.updateStatus(recoveryId, 'SUBMITTED');
  }
  
  async processReinsurerResponse(
    recoveryId: string,
    reinsurerId: string,
    response: ReinsurerResponse
  ): Promise<void> {
    await recoveryResponseRepository.update(recoveryId, reinsurerId, {
      responseStatus: response.status,
      responseDate: new Date(),
      responseMessage: response.message,
      agreedAmount: response.agreedAmount
    });
    
    if (response.status === 'DISPUTED') {
      await this.createDispute(recoveryId, response.disputeReason);
    }
    
    // 檢查是否所有再保人都已回覆
    await this.checkCompletionStatus(recoveryId);
  }
}
```

---

## 4. SoA Reconciliation（對帳結算）技術規格

### 4.1 資料模型

```prisma
model SoaBatch {
  id                  String        @id @default(uuid())
  batchCode           String        @unique
  periodStart         DateTime
  periodEnd           DateTime
  treatyIds           String[]      // JSON array
  reinsurerIds        String[]      // JSON array  
  currency            String
  cededPremiumTotal   Decimal       @default(0)
  commissionTotal     Decimal       @default(0)
  recoverableTotal    Decimal       @default(0)
  priorBalance        Decimal       @default(0)
  varianceAmount      Decimal       @default(0)
  settlementAmount    Decimal       @default(0)
  status              SoaStatus     @default(DRAFT)
  generatedAt         DateTime      @default(now())
  approvedAt          DateTime?
  approvedBy          String?
  lockedAt            DateTime?
  sentAt              DateTime?
  
  // 關聯
  items               SoaItem[]
  variances           SoaVariance[]
  documents           SoaDocument[]
  
  @@index([batchCode])
  @@index([periodStart, periodEnd])
  @@index([status])
}

model SoaItem {
  id              String    @id @default(uuid())
  batchId         String
  sourceType      String    // 'PREMIUM' | 'COMMISSION' | 'RECOVERY' | 'ADJUSTMENT'
  sourceId        String    // Treaty/Facultative/Recovery ID
  description     String
  amount          Decimal
  currency        String
  transactionDate DateTime
  
  batch           SoaBatch  @relation(fields: [batchId], references: [id], onDelete: Cascade)
  
  @@index([batchId])
  @@index([sourceType, sourceId])
}

model SoaVariance {
  id              String          @id @default(uuid())
  batchId         String
  sourceType      String
  sourceRef       String
  varianceAmount  Decimal
  varianceReason  String?
  assignedTo      String?
  status          VarianceStatus  @default(PENDING)
  resolvedAt      DateTime?
  resolutionNotes String?
  createdAt       DateTime        @default(now())
  
  batch           SoaBatch        @relation(fields: [batchId], references: [id], onDelete: Cascade)
  
  @@index([batchId])
  @@index([status])
}

enum SoaStatus {
  DRAFT
  PENDING
  APPROVED
  LOCKED
  SENT
}

enum VarianceStatus {
  PENDING
  IN_PROGRESS
  RESOLVED
  WAIVED
}
```

### 4.2 SoA生成服務

```typescript
// src/services/soa-service.ts
export class SoaService {
  async generateSoaBatch(request: SoaGenerationRequest): Promise<SoaBatchDetail> {
    // 1. 驗證期間和範圍
    this.validateGenerationRequest(request);
    
    // 2. 彙整資料
    const aggregatedData = await this.aggregateData(request);
    
    // 3. 比對前期結餘
    const priorBalance = await this.calculatePriorBalance(request);
    
    // 4. 檢測差異
    const variances = await this.detectVariances(aggregatedData, priorBalance);
    
    // 5. 建立SoA批次
    const batchCode = this.generateBatchCode(request);
    
    return soaRepository.createBatch({
      batchCode,
      periodStart: request.periodStart,
      periodEnd: request.periodEnd,
      treatyIds: request.treatyIds,
      reinsurerIds: request.reinsurerIds,
      currency: request.currency,
      cededPremiumTotal: aggregatedData.premiumTotal,
      commissionTotal: aggregatedData.commissionTotal,
      recoverableTotal: aggregatedData.recoverableTotal,
      priorBalance,
      varianceAmount: variances.reduce((sum, v) => sum.add(v.amount), new Decimal(0)),
      status: 'DRAFT',
      items: aggregatedData.items,
      variances
    });
  }
  
  private async aggregateData(request: SoaGenerationRequest) {
    // 彙整保費資料
    const premiumData = await cessionRepository.findPremiumsByPeriod(
      request.periodStart,
      request.periodEnd,
      request.treatyIds,
      request.reinsurerIds
    );
    
    // 彙整佣金資料
    const commissionData = await cessionRepository.findCommissionsByPeriod(
      request.periodStart,
      request.periodEnd,
      request.treatyIds,
      request.reinsurerIds
    );
    
    // 彙整攤回資料
    const recoveryData = await claimRecoveryRepository.findByPeriod(
      request.periodStart,
      request.periodEnd,
      request.treatyIds,
      request.reinsurerIds
    );
    
    return {
      premiumTotal: premiumData.reduce((sum, item) => sum.add(item.amount), new Decimal(0)),
      commissionTotal: commissionData.reduce((sum, item) => sum.add(item.amount), new Decimal(0)),
      recoverableTotal: recoveryData.reduce((sum, item) => sum.add(item.amount), new Decimal(0)),
      items: [...premiumData, ...commissionData, ...recoveryData]
    };
  }
  
  async approveSoaBatch(batchId: string, approvedBy: string): Promise<SoaBatchDetail> {
    // 檢查是否有未處理的差異
    const unresolvedVariances = await soaRepository.findUnresolvedVariances(batchId);
    if (unresolvedVariances.length > 0) {
      throw new SoaValidationError('unresolvedVariances', unresolvedVariances.length.toString());
    }
    
    // 更新狀態並鎖定
    return soaRepository.updateStatus(batchId, 'APPROVED', {
      approvedBy,
      approvedAt: new Date(),
      lockedAt: new Date()
    });
  }
  
  async generateSoaDocument(batchId: string, format: 'PDF' | 'EXCEL'): Promise<string> {
    const batch = await soaRepository.findById(batchId);
    
    if (format === 'PDF') {
      return await this.generatePdfDocument(batch);
    } else {
      return await this.generateExcelDocument(batch);
    }
  }
}
```

---

## 5. IFRS17 Reporting 技術規格

### 5.1 資料模型

```prisma
model Ifrs17ReportBatch {
  id                String              @id @default(uuid())
  batchCode         String              @unique
  reportingPeriod   DateTime
  periodStart       DateTime
  periodEnd         DateTime
  reportingDimension String             // 'TREATY' | 'REINSURER' | 'LOB' | 'GROUP'
  currency          String
  csmOpening        Decimal             @default(0)
  csmRelease        Decimal             @default(0)
  csmClosing        Decimal             @default(0)
  raOpening         Decimal             @default(0)
  raRelease         Decimal             @default(0)
  raClosing         Decimal             @default(0)
  revenueAdjustment Decimal             @default(0)
  lossComponentChange Decimal           @default(0)
  status            Ifrs17ReportStatus @default(DRAFT)
  generatedAt       DateTime            @default(now())
  approvedAt        DateTime?
  approvedBy        String?
  
  // 關聯
  details           Ifrs17ReportDetail[]
  parameters        Ifrs17Parameter[]
  
  @@index([batchCode])
  @@index([reportingPeriod])
  @@index([status])
}

model Ifrs17ReportDetail {
  id              String            @id @default(uuid())
  batchId         String
  entityType      String            // 'TREATY' | 'FACULTATIVE'
  entityId        String
  entityCode      String
  coverageUnits   Decimal           @default(0)
  csmMovement     Decimal           @default(0)
  raMovement      Decimal           @default(0)
  premiumEarned   Decimal           @default(0)
  claimsIncurred  Decimal           @default(0)
  
  batch           Ifrs17ReportBatch @relation(fields: [batchId], references: [id], onDelete: Cascade)
  
  @@index([batchId])
  @@index([entityType, entityId])
}

model Ifrs17Parameter {
  id            String            @id @default(uuid())
  batchId       String?
  name          String
  value         String
  dataType      String            // 'DECIMAL' | 'PERCENTAGE' | 'DATE' | 'STRING'
  effectiveFrom DateTime
  effectiveTo   DateTime?
  description   String?
  createdAt     DateTime          @default(now())
  
  batch         Ifrs17ReportBatch? @relation(fields: [batchId], references: [id])
  
  @@index([name, effectiveFrom])
  @@index([batchId])
}

enum Ifrs17ReportStatus {
  DRAFT
  PENDING
  APPROVED
  LOCKED
  PUBLISHED
}
```

### 5.2 IFRS17計算引擎

```typescript
// src/services/ifrs17-engine/ifrs17-calculation-engine.ts
export class Ifrs17CalculationEngine {
  async generateReport(request: Ifrs17ReportRequest): Promise<Ifrs17ReportDetail> {
    // 1. 載入參數
    const parameters = await this.loadParameters(request.reportingPeriod);
    
    // 2. 載入基礎資料
    const baseData = await this.loadBaseData(request);
    
    // 3. 計算CSM變動
    const csmMovements = await this.calculateCsmMovements(baseData, parameters);
    
    // 4. 計算RA變動
    const raMovements = await this.calculateRaMovements(baseData, parameters);
    
    // 5. 計算收益調整
    const revenueAdjustments = await this.calculateRevenueAdjustments(baseData, parameters);
    
    // 6. 彙總報表
    return this.aggregateReport(csmMovements, raMovements, revenueAdjustments);
  }
  
  private async calculateCsmMovements(
    baseData: Ifrs17BaseData,
    parameters: Ifrs17Parameter[]
  ): Promise<CsmMovement[]> {
    const movements: CsmMovement[] = [];
    
    for (const contract of baseData.contracts) {
      // CSM期初餘額
      const openingCsm = await this.getOpeningCsm(contract.id, baseData.periodStart);
      
      // 本期CSM釋放（依Coverage Units）
      const coverageUnits = await this.calculateCoverageUnits(contract, baseData.period);
      const servicePattern = await this.getServicePattern(contract.id);
      const csmRelease = openingCsm.mul(servicePattern.releaseRate);
      
      // 經驗調整
      const experienceAdjustment = await this.calculateExperienceAdjustment(contract, baseData.period);
      
      // 期末CSM
      const closingCsm = openingCsm.sub(csmRelease).add(experienceAdjustment);
      
      movements.push({
        contractId: contract.id,
        openingCsm,
        csmRelease,
        experienceAdjustment,
        closingCsm,
        coverageUnits
      });
    }
    
    return movements;
  }
  
  private async calculateRaMovements(
    baseData: Ifrs17BaseData,
    parameters: Ifrs17Parameter[]
  ): Promise<RaMovement[]> {
    // RA計算邏輯
    const riskAdjustmentRate = this.getParameterValue(parameters, 'RISK_ADJUSTMENT_RATE');
    
    return baseData.contracts.map(contract => {
      const openingRa = contract.openingRa || new Decimal(0);
      const raRelease = openingRa.mul(riskAdjustmentRate).div(100);
      const closingRa = openingRa.sub(raRelease);
      
      return {
        contractId: contract.id,
        openingRa,
        raRelease,
        closingRa
      };
    });
  }
}
```

---

## 6. Data Import & Migration 技術規格

### 6.1 資料導入架構

```typescript
// src/services/data-import/import-engine.ts
export interface ImportJob {
  id: string;
  name: string;
  type: 'TREATY' | 'REINSURER' | 'FACULTATIVE' | 'CLAIM';
  sourceType: 'CSV' | 'EXCEL' | 'API' | 'DATABASE';
  filePath?: string;
  mapping: FieldMapping[];
  validationRules: ValidationRule[];
  status: ImportStatus;
  progress: ImportProgress;
  results?: ImportResults;
}

export interface FieldMapping {
  sourceField: string;
  targetField: string;
  dataType: 'STRING' | 'NUMBER' | 'DATE' | 'BOOLEAN';
  required: boolean;
  defaultValue?: any;
  transformation?: string; // JavaScript expression
}

export class DataImportEngine {
  async submitImportJob(job: Omit<ImportJob, 'id' | 'status' | 'progress'>): Promise<string> {
    const jobId = generateJobId();
    
    // 1. 驗證檔案格式
    await this.validateFile(job.filePath, job.sourceType);
    
    // 2. 建立導入工作
    await importRepository.createJob({
      ...job,
      id: jobId,
      status: 'PENDING',
      progress: { stage: 'QUEUED', percentage: 0 }
    });
    
    // 3. 非同步處理
    this.processImportAsync(jobId);
    
    return jobId;
  }
  
  private async processImportAsync(jobId: string) {
    try {
      const job = await importRepository.findById(jobId);
      
      // 1. 讀取資料
      await this.updateProgress(jobId, 'READING', 10);
      const rawData = await this.readSourceData(job);
      
      // 2. 資料轉換
      await this.updateProgress(jobId, 'TRANSFORMING', 30);
      const transformedData = await this.transformData(rawData, job.mapping);
      
      // 3. 資料驗證
      await this.updateProgress(jobId, 'VALIDATING', 50);
      const validationResults = await this.validateData(transformedData, job.validationRules);
      
      if (validationResults.errors.length > 0) {
        await this.generateErrorReport(jobId, validationResults.errors);
        await this.updateJobStatus(jobId, 'FAILED', 'Validation errors found');
        return;
      }
      
      // 4. 寫入暫存
      await this.updateProgress(jobId, 'STAGING', 70);
      await this.writeToStaging(jobId, validationResults.validData);
      
      // 5. 等待審核
      await this.updateJobStatus(jobId, 'PENDING_APPROVAL');
      
    } catch (error) {
      await this.updateJobStatus(jobId, 'FAILED', error.message);
    }
  }
  
  async approveImport(jobId: string, approvedBy: string): Promise<ImportResults> {
    const stagingData = await importRepository.getStagingData(jobId);
    
    // 開始正式導入
    await this.updateProgress(jobId, 'IMPORTING', 80);
    
    const results = await this.performImport(stagingData);
    
    // 清理暫存資料
    await importRepository.clearStagingData(jobId);
    
    // 更新工作狀態
    await this.updateJobStatus(jobId, 'COMPLETED');
    
    return results;
  }
}
```

---

## 7. System Integration 技術規格

### 7.1 API Gateway架構

```typescript
// src/services/integration/api-gateway.ts
export interface ExternalSystemConfig {
  id: string;
  name: string;
  type: 'POLICY' | 'CLAIM' | 'ACCOUNTING' | 'IFRS17';
  protocol: 'REST' | 'SOAP' | 'SFTP' | 'MQ';
  endpoint: string;
  authentication: AuthConfig;
  timeout: number;
  retryPolicy: RetryPolicy;
  isActive: boolean;
}

export interface AuthConfig {
  type: 'OAUTH2' | 'BASIC' | 'API_KEY' | 'CERTIFICATE';
  credentials: Record<string, string>;
  tokenEndpoint?: string;
  refreshToken?: string;
}

export class ApiGateway {
  async callExternalSystem<T>(
    systemId: string,
    endpoint: string,
    method: 'GET' | 'POST' | 'PUT' | 'DELETE',
    data?: any
  ): Promise<T> {
    const config = await this.getSystemConfig(systemId);
    
    // 1. 準備認證
    const authHeaders = await this.prepareAuthentication(config.authentication);
    
    // 2. 發送請求
    const response = await this.sendRequest(config, endpoint, method, data, authHeaders);
    
    // 3. 記錄日誌
    await this.logIntegrationCall(systemId, endpoint, method, response.status);
    
    // 4. 處理回應
    return this.processResponse<T>(response);
  }
  
  async syncPolicyData(policyIds: string[]): Promise<PolicySyncResult> {
    const results: PolicySyncResult = {
      successful: [],
      failed: [],
      totalCount: policyIds.length
    };
    
    for (const policyId of policyIds) {
      try {
        const policyData = await this.callExternalSystem<PolicyData>(
          'POLICY_SYSTEM',
          `/policies/${policyId}`,
          'GET'
        );
        
        // 轉換並儲存
        await this.storePolicyData(policyData);
        results.successful.push(policyId);
        
      } catch (error) {
        results.failed.push({ policyId, error: error.message });
      }
    }
    
    return results;
  }
}
```

### 7.2 健康檢查機制

```typescript
// src/services/health-check/system-health-service.ts
export class SystemHealthService {
  async performHealthCheck(): Promise<HealthCheckResult> {
    const checks = await Promise.allSettled([
      this.checkDatabase(),
      this.checkExternalSystems(),
      this.checkFileStorage(),
      this.checkCalculationEngine(),
      this.checkNotificationService()
    ]);
    
    const results = checks.map((check, index) => ({
      component: this.getComponentName(index),
      status: check.status === 'fulfilled' ? 'HEALTHY' : 'UNHEALTHY',
      message: check.status === 'fulfilled' ? check.value : check.reason,
      timestamp: new Date()
    }));
    
    const overallStatus = results.every(r => r.status === 'HEALTHY') ? 'HEALTHY' : 'UNHEALTHY';
    
    return {
      overallStatus,
      components: results,
      checkedAt: new Date()
    };
  }
  
  private async checkCalculationEngine(): Promise<string> {
    // 執行簡單的計算測試
    const testResult = await cessionEngine.calculate({
      policyData: this.getTestPolicyData(),
      calculationType: 'PREMIUM'
    });
    
    if (!testResult || testResult.cededAmount.isNaN()) {
      throw new Error('Calculation engine test failed');
    }
    
    return 'Calculation engine is working correctly';
  }
}
```

---

## 8. 實作檢查清單 / Implementation Checklist

### 8.1 每個模組必須完成的項目

**資料層 (Repository)**
- [ ] Prisma Schema定義
- [ ] Migration腳本
- [ ] Repository類別實作
- [ ] 資料庫索引優化
- [ ] 種子資料更新

**業務層 (Service)**  
- [ ] Service類別實作
- [ ] 業務規則驗證
- [ ] 錯誤處理機制
- [ ] 單元測試覆蓋
- [ ] 效能優化

**行動層 (Actions)**
- [ ] Server Actions實作
- [ ] Zod驗證Schema
- [ ] 錯誤狀態處理
- [ ] 快取失效策略
- [ ] 稽核事件記錄

**介面層 (UI)**
- [ ] 頁面元件實作
- [ ] 表單驗證
- [ ] 多語言支援
- [ ] 響應式設計
- [ ] 無障礙支援

**測試**
- [ ] 單元測試
- [ ] 整合測試
- [ ] E2E測試
- [ ] 效能測試
- [ ] 安全測試

**文檔**
- [ ] API文檔
- [ ] 使用手冊
- [ ] 故障排除指南
- [ ] 部署指南
- [ ] 維運手冊

---

## 9. 技術標準與規範 / Technical Standards & Guidelines

### 9.1 程式碼品質標準

```typescript
// ESLint規則擴展
module.exports = {
  extends: ['next/core-web-vitals'],
  rules: {
    // 國際化相關
    'no-literal-string': 'error', // 禁止硬編碼字串
    'i18n/no-missing-keys': 'error', // 檢查缺失的翻譯鍵
    
    // 架構相關
    'no-restricted-imports': ['error', {
      patterns: [
        {
          group: ['../../../*'],
          message: '禁止跨層級導入，請遵循ADR-001分層架構'
        }
      ]
    }],
    
    // 安全相關
    'security/detect-sql-injection': 'error',
    'security/detect-object-injection': 'error'
  }
};
```

### 9.2 API設計標準

```typescript
// API回應格式標準
interface StandardApiResponse<T> {
  success: boolean;
  data?: T;
  error?: {
    code: string;
    message: string;
    details?: any;
  };
  meta?: {
    pagination?: PaginationMeta;
    locale?: string;
    timestamp: string;
    requestId: string;
  };
}

// 分頁標準
interface PaginationMeta {
  page: number;
  pageSize: number;
  totalCount: number;
  totalPages: number;
  hasNext: boolean;
  hasPrevious: boolean;
}
```

---

## 10. 監控與告警規格 / Monitoring & Alerting Specification

### 10.1 關鍵指標監控

```typescript
// src/services/monitoring/metrics-collector.ts
export interface SystemMetrics {
  // 業務指標
  treatyCount: number;
  facultativeCount: number;
  dailyCalculations: number;
  monthlyRecoveries: number;
  
  // 技術指標
  apiResponseTime: number;
  databaseConnections: number;
  memoryUsage: number;
  cpuUsage: number;
  
  // 錯誤指標
  errorRate: number;
  failedCalculations: number;
  integrationFailures: number;
}

export class MetricsCollector {
  async collectMetrics(): Promise<SystemMetrics> {
    return {
      treatyCount: await treatyRepository.count({ status: 'ACTIVE' }),
      facultativeCount: await facultativeRepository.count({ status: 'ACTIVE' }),
      dailyCalculations: await cessionRepository.countTodayCalculations(),
      monthlyRecoveries: await claimRecoveryRepository.countMonthlyRecoveries(),
      
      apiResponseTime: await this.measureApiResponseTime(),
      databaseConnections: await this.getDatabaseConnectionCount(),
      memoryUsage: process.memoryUsage().heapUsed,
      cpuUsage: await this.getCpuUsage(),
      
      errorRate: await this.calculateErrorRate(),
      failedCalculations: await this.countFailedCalculations(),
      integrationFailures: await this.countIntegrationFailures()
    };
  }
}
```

### 10.2 告警規則

```typescript
// src/services/monitoring/alert-rules.ts
export const alertRules: AlertRule[] = [
  {
    name: 'High Error Rate',
    condition: 'errorRate > 5',
    severity: 'CRITICAL',
    channels: ['email', 'slack'],
    recipients: ['dev-team@company.com', '#alerts']
  },
  {
    name: 'Slow API Response',
    condition: 'apiResponseTime > 5000',
    severity: 'WARNING', 
    channels: ['slack'],
    recipients: ['#performance']
  },
  {
    name: 'Failed Calculations',
    condition: 'failedCalculations > 10',
    severity: 'HIGH',
    channels: ['email', 'slack'],
    recipients: ['finance-team@company.com', '#finance-alerts']
  },
  {
    name: 'Integration Failure',
    condition: 'integrationFailures > 0',
    severity: 'HIGH',
    channels: ['email'],
    recipients: ['integration-team@company.com']
  }
];
```

---

## 11. 安全性考量 / Security Considerations

### 11.1 資料保護

```typescript
// src/lib/security/data-protection.ts
export class DataProtectionService {
  // 敏感資料遮罩
  maskSensitiveData(data: any, fields: string[]): any {
    const masked = { ...data };
    
    for (const field of fields) {
      if (masked[field]) {
        masked[field] = this.maskValue(masked[field]);
      }
    }
    
    return masked;
  }
  
  // 稽核日誌加密
  async encryptAuditLog(auditEvent: AuditEvent): Promise<EncryptedAuditEvent> {
    const sensitiveFields = ['taxId', 'registrationNumber', 'personalInfo'];
    
    return {
      ...auditEvent,
      changes: auditEvent.changes.map(change => ({
        ...change,
        oldValue: this.encryptIfSensitive(change.oldValue, change.fieldPath, sensitiveFields),
        newValue: this.encryptIfSensitive(change.newValue, change.fieldPath, sensitiveFields)
      }))
    };
  }
}
```

### 11.2 API安全

```typescript
// src/middleware/security-middleware.ts
export function createSecurityMiddleware() {
  return async (req: NextRequest) => {
    // 1. Rate Limiting
    await this.checkRateLimit(req);
    
    // 2. API Key驗證
    await this.validateApiKey(req);
    
    // 3. CORS檢查
    await this.validateCors(req);
    
    // 4. 輸入驗證
    await this.validateInput(req);
    
    // 5. 記錄存取日誌
    await this.logAccess(req);
  };
}
```

---

## 12. 效能優化策略 / Performance Optimization Strategy

### 12.1 資料庫優化

```sql
-- 關鍵索引建議
CREATE INDEX CONCURRENTLY idx_treaty_effective_period 
ON "Treaty" ("lineOfBusiness", "effectiveDate", "expiryDate", "status");

CREATE INDEX CONCURRENTLY idx_cession_calculation_date
ON "CessionDetail" ("calculationDate", "treatyId");

CREATE INDEX CONCURRENTLY idx_audit_entity_timeline
ON "AuditEvent" ("entityType", "entityId", "createdAt");

-- 分區表建議（大量資料時）
CREATE TABLE "AuditEvent_2025" PARTITION OF "AuditEvent"
FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');
```

### 12.2 快取策略

```typescript
// src/lib/cache/cache-strategy.ts
export const cacheConfig = {
  // 靜態資料長期快取
  reinsurers: { ttl: 3600, tags: ['reinsurer'] },
  treatyTypes: { ttl: 86400, tags: ['system-config'] },
  
  // 動態資料短期快取
  treatyList: { ttl: 300, tags: ['treaty'] },
  facultativeList: { ttl: 300, tags: ['facultative'] },
  
  // 計算結果中期快取
  cessionResults: { ttl: 1800, tags: ['calculation'] },
  soaBatches: { ttl: 3600, tags: ['soa'] }
};

export class CacheManager {
  async invalidateByTags(tags: string[]): Promise<void> {
    // 使用Redis或Next.js revalidateTag
    for (const tag of tags) {
      await revalidateTag(tag);
    }
  }
  
  async warmupCache(): Promise<void> {
    // 預熱常用資料
    await Promise.all([
      this.preloadReinsurers(),
      this.preloadActiveTreaties(),
      this.preloadSystemConfig()
    ]);
  }
}
```

---

## 13. 部署腳本與自動化 / Deployment Scripts & Automation

### 13.1 資料庫遷移腳本

```bash
#!/bin/bash
# scripts/deploy-database.sh

set -e

echo "Starting database deployment..."

# 1. 備份現有資料庫
if [ "$ENVIRONMENT" = "production" ]; then
  echo "Creating database backup..."
  pg_dump $DATABASE_URL > "backup_$(date +%Y%m%d_%H%M%S).sql"
fi

# 2. 執行遷移
echo "Running database migrations..."
npx prisma migrate deploy

# 3. 更新種子資料（僅非生產環境）
if [ "$ENVIRONMENT" != "production" ]; then
  echo "Seeding database..."
  npx prisma db seed
fi

# 4. 驗證遷移結果
echo "Validating migration..."
npm run test:migration

echo "Database deployment completed successfully!"
```

### 13.2 應用程式部署腳本

```yaml
# .github/workflows/deploy.yml
name: Deploy Reinsurance System

on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
      - run: npm ci
      - run: npm run lint
      - run: npm run test:unit
      - run: npm run test:integration
      - run: npm run i18n:validate

  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
      - run: npm ci
      - run: npm run build
      - uses: docker/build-push-action@v5
        with:
          push: true
          tags: reinsurance-system:${{ github.sha }}

  deploy-staging:
    needs: build
    runs-on: ubuntu-latest
    environment: staging
    steps:
      - name: Deploy to Staging
        run: |
          kubectl set image deployment/reinsurance-system \
            app=reinsurance-system:${{ github.sha }}
          kubectl rollout status deployment/reinsurance-system

  deploy-production:
    needs: deploy-staging
    runs-on: ubuntu-latest
    environment: production
    if: github.ref == 'refs/heads/main'
    steps:
      - name: Deploy to Production
        run: |
          kubectl set image deployment/reinsurance-system \
            app=reinsurance-system:${{ github.sha }}
          kubectl rollout status deployment/reinsurance-system
```

---

## 14. 故障排除指南 / Troubleshooting Guide

### 14.1 常見問題與解決方案

| 問題類型 | 症狀 | 可能原因 | 解決方案 |
|----------|------|----------|----------|
| 計算錯誤 | 分保金額不正確 | 合約配置錯誤、計算邏輯bug | 檢查合約設定、執行計算測試 |
| 效能問題 | 頁面載入緩慢 | 資料庫查詢未優化、快取失效 | 檢查慢查詢、重建快取 |
| 整合失敗 | 外部API呼叫失敗 | 網路問題、認證過期 | 檢查網路連線、更新認證資訊 |
| 翻譯缺失 | 頁面顯示翻譯鍵 | 翻譯檔案缺失、鍵名錯誤 | 檢查翻譯檔案、修正鍵名 |

### 14.2 診斷工具

```typescript
// src/tools/diagnostic-tools.ts
export class DiagnosticTools {
  async runSystemDiagnostic(): Promise<DiagnosticReport> {
    return {
      database: await this.checkDatabaseHealth(),
      calculations: await this.validateCalculationEngine(),
      integrations: await this.testExternalIntegrations(),
      translations: await this.validateTranslations(),
      performance: await this.measurePerformance()
    };
  }
  
  async validateCalculationEngine(): Promise<CalculationValidationResult> {
    const testCases = await this.loadCalculationTestCases();
    const results = [];
    
    for (const testCase of testCases) {
      const result = await cessionEngine.calculate(testCase.input);
      const isValid = this.compareResults(result, testCase.expectedOutput);
      
      results.push({
        testCase: testCase.name,
        passed: isValid,
        actual: result,
        expected: testCase.expectedOutput
      });
    }
    
    return {
      totalTests: results.length,
      passedTests: results.filter(r => r.passed).length,
      failedTests: results.filter(r => !r.passed),
      overallStatus: results.every(r => r.passed) ? 'PASS' : 'FAIL'
    };
  }
}
```

---

## 15. 修訂記錄 / Revision History

| 版本 | 日期 | 修訂內容 | 作者 |
|------|------|----------|------|
| v1.0 | 2025-11-05 | 初版技術解決方案規格，涵蓋Facultative、Cession Engine、Claim Recovery、SoA、IFRS17等核心模組 | Tao Yu 和他的 GPT 智能助手 |

---

> 本技術規格需與各Squad Tech Lead確認後實施。實作過程中如發現技術難點或需要調整，請及時更新本文檔並通知Architecture Board。所有實作都必須遵循ADR-001~008的架構原則和品質標準。