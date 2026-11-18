# The Gym

A cross-platform Flutter mobile application for gym members and administrators to browse membership plans, explore special offers, read gym announcements, and manage cash-at-reception subscription requests.

## Who It Is For
- **Gym Members & Visitors:** Browse membership plans, save favorite offers, submit subscription requests, and track active membership countdowns.
- **Gym Owners & Admins:** Review and approve/reject pending cash subscription requests, view registered members, and publish or delete plans, offers, and gym news with real photos.

## Key Features
- **Public & Member Browsing:** Live feed of active promotions, membership plans, and gym announcements.
- **Search & Wishlist:** Search special offers by keyword, filter by badge or saved items, and bookmark favorite offers per user account.
- **Cash Subscription Flow:** Members request plans with duplicate-pending protection and cancel pending requests anytime; admins activate or reject requests with automatic membership duration calculation.
- **Authentication & Account Management:** Email/password login and registration, inline validation alerts, password recovery via email, and profile editing.
- **Integrated Admin Dashboard:** Role-protected management panel for handling requests, viewing members, and creating/deleting plans, offers, and news with gallery image uploads.

## Tech Stack
- **Frontend:** Flutter & Dart (Material 3 UI)
- **Backend & Database:** Supabase (PostgreSQL with Row Level Security)
- **Authentication & Storage:** Supabase Auth & Supabase Storage (`gym-images` bucket)

## Project Scope & Limitations
- Payments are handled offline (cash at gym reception) rather than through an online payment gateway.
- Built as a training and portfolio project (`v1.0.0`) and has not undergone a formal third-party penetration or security audit.