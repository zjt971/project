import React from "react";

export default function Layout({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex min-h-screen bg-page text-textPrimary">
      <aside className="w-[var(--sidebar-width)] border-r border-border bg-surface">
        <div className="flex h-[var(--header-height)] items-center justify-center border-b border-border font-semibold">
          EIS 再保系統
        </div>
        {/* Sidebar 菜單 */}
      </aside>
      <main className="flex flex-1 flex-col bg-page">
        <header className="flex h-[var(--header-height)] items-center justify-end border-b border-border bg-surface px-6 shadow-card">
          {/* User & 通知 */}
        </header>
        <div className="flex flex-1 flex-col gap-6 overflow-y-auto px-6 py-6 lg:px-10">
          {children}
        </div>
      </main>
    </div>
  );
}
