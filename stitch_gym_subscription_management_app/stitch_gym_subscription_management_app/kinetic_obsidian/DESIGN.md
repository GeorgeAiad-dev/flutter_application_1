---
name: Kinetic Obsidian
colors:
  surface: '#0f131c'
  surface-dim: '#0f131c'
  surface-bright: '#353942'
  surface-container-lowest: '#0a0e16'
  surface-container-low: '#181c24'
  surface-container: '#1c2028'
  surface-container-high: '#262a33'
  surface-container-highest: '#31353e'
  on-surface: '#dfe2ee'
  on-surface-variant: '#c1cab0'
  inverse-surface: '#dfe2ee'
  inverse-on-surface: '#2c3039'
  outline: '#8b947d'
  outline-variant: '#424936'
  surface-tint: '#91db2a'
  primary: '#9ee939'
  on-primary: '#1f3700'
  primary-container: '#84cc16'
  on-primary-container: '#315200'
  inverse-primary: '#416900'
  secondary: '#4edea3'
  on-secondary: '#003824'
  secondary-container: '#00a572'
  on-secondary-container: '#00311f'
  tertiary: '#74e3ff'
  on-tertiary: '#003640'
  tertiary-container: '#37c9e7'
  on-tertiary-container: '#00515f'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#acf847'
  primary-fixed-dim: '#91db2a'
  on-primary-fixed: '#102000'
  on-primary-fixed-variant: '#304f00'
  secondary-fixed: '#6ffbbe'
  secondary-fixed-dim: '#4edea3'
  on-secondary-fixed: '#002113'
  on-secondary-fixed-variant: '#005236'
  tertiary-fixed: '#acedff'
  tertiary-fixed-dim: '#4cd7f6'
  on-tertiary-fixed: '#001f26'
  on-tertiary-fixed-variant: '#004e5c'
  background: '#0f131c'
  on-background: '#dfe2ee'
  surface-variant: '#31353e'
typography:
  display-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 40px
    fontWeight: '800'
    lineHeight: 48px
    letterSpacing: -0.03em
  display-lg-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '800'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-xl:
    fontFamily: Plus Jakarta Sans
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 22px
    fontWeight: '700'
    lineHeight: 28px
    letterSpacing: -0.01em
  title-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
    letterSpacing: 0em
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: 0em
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: 0.01em
  stat-metric:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '800'
    lineHeight: 28px
    letterSpacing: -0.02em
  label-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.04em
  label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 11px
    fontWeight: '700'
    lineHeight: 14px
    letterSpacing: 0.06em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1.25rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

This design system targets high-performance athletes, boutique gym goers, and modern fitness club operators. The aesthetic balances deep focus and raw kinetic vitality. It combines dark, architectural minimalism with focused, high-voltage bioluminescent accents.

### Visual Style
- **Aesthetic Movement:** Technical Dark Mode with Precision Glassmorphism and High-Contrast Bioluminescent Highlights.
- **Atmosphere:** Deep charcoal and volcanic obsidian foundational surfaces overlaid with thin translucent surfaces, illuminated by sharp lime/emerald signals and cyan telemetric accents.
- **Emotional Signature:** Elite, focused, empowering, and surgically precise. It eliminates visual noise to prioritize biometric tracking, access control, and performance analytics.

## Colors

The palette establishes high hierarchy in low-light environments, meeting WCAG 2.1 AAA contrast targets against deeply saturated dark bases.

### Palette Architecture
- **Primary (`#84CC16` - Kinetic Lime):** The core motivational engine. Used for primary calls-to-action, active workout triggers, progress ring fills, and interactive focal points.
- **Secondary (`#10B981` - Emerald Surge):** High-trust vitality color. Dedicated to positive operational states, successful check-ins, active memberships, and confirmed bookings.
- **Tertiary (`#06B6D4` - Cyber Cyan):** Biometric and informational telemetry. Used for metric readouts (heart rate zones, velocity metrics, timestamps) and secondary visual cues.
- **Base Surfaces (`#0B0F17` to `#1E293B`):**
  - **Canvas Deep:** `#0B0F17` (Void Black)
  - **Surface Lower:** `#111827` (Charcoal Slate)
  - **Surface Elevated (Glass Card Base):** `#1E293B` applied at 60%–75% opacity with backdrop blur.
  - **Surface Stroke / Division:** `#334155` at 40%–60% opacity.

### Status Indicators
- **Active / Check-In Success:** `#10B981` (Emerald)
- **Pending / In Review:** `#F59E0B` (Amber Orange)
- **Expired / Inactive:** `#64748B` (Muted Slate)
- **Cancelled / Critical Alert:** `#EF4444` (Laser Red)

## Typography

Plus Jakarta Sans provides geometric legibility with modern athletic structure.

- **Display & Headlines:** Tightly tracked (`-0.02em` to `-0.03em`) with heavy font weights (700 and 800) to emulate physical force and high momentum.
- **Telemetry & Stats (`stat-metric`):** Rendered bold with tabular numerical alignments to avoid layout shift during real-time rep counting, timers, and telemetry updates.
- **Labels & Overlines (`label-sm`, `label-md`):** Uppercase tracking (+0.04em to +0.06em) for technical badges, micro-indicators, and pill tabs.

## Layout & Spacing

The layout is built for thumb-driven mobile workflows, one-handed grip zones, and dense, glanceable workout data.

### Structural Framework
- **Base Grid:** Strictly calculated on an 8px base rhythm with 4px sub-steps for micro-components.
- **Mobile Canvas Margins:** 1.25rem (`20px`) horizontally ensures safe edge zones on edge-to-edge curved mobile screens.
- **Gutter:** 1rem (`16px`) grid column separation for double-column metric layouts (e.g., Heart Rate vs. Calories Burned).
- **Safe Area Insets:** Fixed top spacing of 48px to accommodate native hardware dynamic islands/notches, and bottom spacing of 34px for native gesture home bars below the tab bar.

## Elevation & Depth

Visual depth is achieved through translucent structural planes and luminescent proximity instead of traditional muddy dropshadows.

### Layer Tiers
- **Tier 0 (Canvas Base):** Solid `#0B0F17`. Non-interactive background plane.
- **Tier 1 (Glass Panes & Cards):** Background `rgba(30, 41, 59, 0.65)` backed with `backdrop-filter: blur(16px) saturate(180%)`. Border: 1px solid `rgba(255, 255, 255, 0.08)`.
- **Tier 2 (Floating Overlays & Bottom Sheets):** Background `rgba(17, 24, 39, 0.88)` backed with `backdrop-filter: blur(24px)`. Border: 1px solid `rgba(255, 255, 255, 0.12)`.
- **Tier 3 (Active Glow Elevation):** Interactive elements (selected pills, active timers, trigger buttons) emit a tight, colored ambient aura: `0px 4px 20px rgba(132, 204, 22, 0.25)` or `0px 4px 20px rgba(16, 185, 129, 0.25)`.

## Shapes

The design uses a controlled rounded aesthetic (`roundedness: 2`, where standard containers feature 0.5rem / 8px and cards use 1rem / 16px).

- **Buttons & Segmented Controls:** 0.75rem (12px) for tactical touch ergonomics.
- **Stat Cards & Glass Surfaces:** 1rem (16px) matching contemporary mobile hardware corners.
- **Badges & Pill Toggles:** Fully rounded capsule/pill (`9999px`) to create clear shape differentiation against square metric cards.

## Components

### Buttons
- **Primary (Action):** Background `#84CC16`, text `#0B0F17` (bold weight). Active state applies a scale transform (0.98) with an ambient lime aura.
- **Secondary Glass:** Background `rgba(255, 255, 255, 0.06)`, border `1px solid rgba(255, 255, 255, 0.12)`, text `#F8FAFC`.
- **Ghost / Tertiary:** Transparent background, text `#06B6D4` or `#84CC16`, no border.

### Status Pill Badges
Capsule-shaped containers (`border-radius: 9999px`), padding `4px 10px`, typography `label-sm`.
- **Active:** Background `rgba(16, 185, 129, 0.15)`, text `#10B981`, border `1px solid rgba(16, 185, 129, 0.4)`. Accompanied by a pulsing 6px circular indicator.
- **Expired:** Background `rgba(100, 116, 139, 0.15)`, text `#94A3B8`, border `1px solid rgba(100, 116, 139, 0.3)`.
- **Pending:** Background `rgba(245, 158, 11, 0.15)`, text `#F59E0B`, border `1px solid rgba(245, 158, 11, 0.4)`.
- **Cancelled:** Background `rgba(239, 68, 68, 0.15)`, text `#EF4444`, border `1px solid rgba(239, 68, 68, 0.4)`.

### Stat Cards
- Enclosed within Tier 1 glass panels (16px radius, subtle top-highlight border).
- Top row: Overline label (`label-md`, `#94A3B8`) paired with an icon tinted with Tertiary Cyan (`#06B6D4`).
- Middle row: Large numerical output (`stat-metric`, `#FFFFFF`).
- Footer: Micro trend indicator (e.g., `+12% vs last week` in `#10B981` or `#64748B`).

### Segmented Controls (Period & Mode Selectors)
- Container: Background `#111827`, border `1px solid rgba(255, 255, 255, 0.06)`, padding `4px`.
- Inactive Segments: Text `#94A3B8`, typography `label-md`.
- Active Segment: Background `rgba(255, 255, 255, 0.12)`, text `#FFFFFF`, subtle inner glow.

### Form Inputs
- Base Container: Height 52px, background `rgba(17, 24, 39, 0.8)`, border `1px solid rgba(255, 255, 255, 0.1)`.
- Text: Typography `body-md`, input value `#FFFFFF`, placeholder `#64748B`.
- Focused State: Border becomes `1px solid #84CC16` with a soft lime glow (`rgba(132, 204, 22, 0.2)`).

### Dual-Role Bottom Tab Navigation
Anchored bottom floating glass bar, height 68px, margin `0 16px 20px 16px`, corner radius 24px.
- **Member Mode Navigation:**
  - 4 destinations: **Home (Dashboard)**, **Classes (Booking)**, **QR Pass (Central Elevated Button)**, **Progress (Metrics)**, **Profile**.
  - Central Check-in Action: Highlighted with an emerald-to-lime gradient button floating slightly above the bar.
- **Gym Owner Admin Mode:**
  - 4 destinations: **Pulse (Live Capacity)**, **Members (Directory & Status)**, **Scan (Terminal Barcode)**, **Revenue (Analytics)**.
  - Active Tab Accent: Switches from Lime (`#84CC16`) to Cyan (`#06B6D4`) to signify administrative privileges visually.