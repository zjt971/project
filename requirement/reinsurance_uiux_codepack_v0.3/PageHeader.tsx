import { Button } from "@/components/ui/button";

export function PageHeader({ title, onSave, onCancel }: { title: string; onSave?: () => void; onCancel?: () => void }) {
  return (
    <div className="bg-surface border-b border-borderSubtle px-6 py-4 flex justify-between items-center">
      <div>
        <div className="text-xs text-textMuted mb-1">首頁 / {title}</div>
        <h1 className="text-2xl font-semibold">{title}</h1>
      </div>
      <div className="flex gap-3">
        {onCancel && <Button variant="outline" onClick={onCancel}>取消</Button>}
        {onSave && <Button onClick={onSave}>儲存</Button>}
      </div>
    </div>
  );
}
