import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./app/**/*.{ts,tsx}",
    "./components/**/*.{ts,tsx}",
    "./node_modules/@shadcn/ui/dist/**/*.js"
  ],
  theme: {
    extend: {
      colors: {
        page: "var(--color-page)",
        surface: "var(--color-surface)",
        surfaceMuted: "var(--color-surface-muted)",
        border: "var(--color-border)",
        borderSoft: "var(--color-border-soft)",
        textPrimary: "var(--color-text-primary)",
        textSecondary: "var(--color-text-secondary)",
        textTertiary: "var(--color-text-tertiary)",
        textDisabled: "var(--color-text-disabled)",
        brand: "var(--color-brand)",
        brandHover: "var(--color-brand-hover)",
        danger: "var(--color-danger)",
        onBrand: "var(--color-on-brand)",
      },
      boxShadow: {
        card: "var(--shadow-card)",
        overlay: "var(--shadow-overlay)",
      },
      spacing: {
        field: "var(--field-width)",
      },
    },
  },
  plugins: [],
};
export default config;
