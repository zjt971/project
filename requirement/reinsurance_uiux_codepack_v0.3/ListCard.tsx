import React from "react";

export function ListCard({ children }: { children: React.ReactNode }) {
  return (
    <div className="bg-surface shadow-card rounded-lg p-6 w-[1184px] mx-auto mb-6">
      {children}
    </div>
  );
}
