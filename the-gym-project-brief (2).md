# PROJECT BRIEF: "The Gym" mobile app

> Paste or upload this file at the start of a new chat. It contains everything decided so far. Read it fully before answering.

## 0. Instructions for Claude (read first)
- The user is **George**. Reply in **Egyptian Arabic** (technical terms can stay in English).
- **Explain step by step.** George wants each step explained clearly before moving to the next one. Do not dump the whole implementation at once. Do one step, explain what it does and why, then wait for confirmation.
- Stay inside the scope below. If George asks for something in the "Out of scope" list, remind him it was excluded on purpose and ask whether he wants to change the scope.
- If something is unclear, ask at most 3 questions.
- For any UI work (screens, components, code), **follow the visual design direction in section 11** so every screen matches George's Stitch mockups. Do not implement the features listed under "Open decisions" in section 11 until George confirms them.

## 1. What the project is
A mobile app named **The Gym**, built for a gym owner. It shows the gym's offers and news, gives members accounts to follow their subscriptions, and lets people from outside the gym create an account and request a subscription.

## 2. Decisions already made
- **Platform:** mobile app, Android + iOS.
- **Payment:** NO online payment. The customer requests a subscription in the app, **pays cash at the gym**, and the **gym owner activates it** from an admin panel.
- **Deliverable chosen so far:** a comprehensive plan (screens + database + tech stack). Implementation has NOT started.

## 3. Out of scope (excluded on purpose)
- Chat between users
- Ratings / reviews
- Commission
- Online payment

## 4. Roles
- **Visitor** (not a member): sees offers and news, creates an account.
- **Member:** sees current subscription (plan, end date, days left) and subscription history.
- **Admin (gym owner):** manages everything from an admin panel.

## 5. Subscription flow
1. User creates an account, picks a plan, taps "Request subscription".
2. Request is saved with status `pending`.
3. User pays cash at the gym.
4. Admin opens the request and taps "Activate", sets the start date.
5. Status becomes `active`; the member sees a countdown.
6. After end date status becomes `expired`. A notification is sent ~3 days before expiry.
- Statuses: `pending`, `active`, `expired`, `cancelled` (admin rejects).

## 6. Screens
**User app:** login/signup, home (latest offers + news), offers list/details, news list/details, plans + "request subscription", my subscription (current + history), profile, notifications.

**Admin panel:** pending requests (activate/reject), members list + search + details, manage plans (name, duration, price), manage offers and news (add/edit/delete + image), subscriptions about to expire.

## 7. Database (core tables/collections)
| Table | Main fields |
|---|---|
| users | id, name, phone, email, role (member/admin), created_at |
| plans | id, name, duration_days, price, description, is_active |
| subscriptions | id, user_id, plan_id, status, requested_at, start_date, end_date, activated_by |
| offers | id, title, description, image_url, price (EGP), old_price (EGP, optional, shown crossed out), valid_until, is_published |
| news | id, title, body, image_url, published_at |
| notifications | id, user_id, title, body, is_read, created_at |

Only admins can write to offers, news, plans, and activate subscriptions (enforce in database security rules, not only in the UI).

## 8. Proposed tech stack
- **App:** Flutter (one codebase for Android + iOS)
- **Backend:** Firebase (Auth, Firestore, Storage, Cloud Messaging)
- **Auth:** phone number with OTP is probably best for Egyptian users (email is the alternative)
- **Alternative if more control is needed:** Supabase, or Node.js + PostgreSQL (needs a server)
- **Store accounts:** Apple Developer ~$99/year, Google Play ~$25 one-time

## 9. Rough timeline
1. Week 1: screen design, project setup, auth
2. Week 2: offers + news, admin management of them
3. Week 3: plans, subscription request, activation, "my subscription" screen
4. Week 4: notifications, testing, publishing

## 10. Error cases and how the app handles them (top 5)

**1. Internet drops**
- Problem: user taps "Request subscription" while offline and thinks it was sent.
- Handling: show last loaded data (offers, news, subscription) with an "You are offline" banner. Submit buttons (request, activate, publish) are disabled or show "No connection, try again". Never show "Sent" until the server confirms.

**2. Empty lists**
- Problem: no offers, news, plans, or pending requests, so the screen looks broken.
- Handling: every list has a clear empty message ("No offers right now, check back soon"). If there are no plans, show "Subscriptions are not available right now" and hide the "Request subscription" button. For the admin, the empty state has a direct button ("Add your first plan" / "Add your first offer").

**3. Wrong or duplicate data**
- Problem: incomplete phone number, email without @, short password, a phone number that already has an account; for the admin, a negative price or zero duration.
- Handling: validate before submitting and show the error under the field itself (e.g. "Phone number must be 11 digits"). If the phone is already registered: "This number already has an account, log in instead". Price and duration must be greater than zero. Validation is also enforced in the database rules, not only in the UI.

**4. Admin activates the subscription for the wrong member**
- Problem: similar names, admin working fast at the counter.
- Handling: before activating, show a confirmation with name, phone, plan, and price ("Activate 3-month plan for Mohamed Ahmed (0100...)?"). Allow undo / "Cancel subscription" from the member details screen. Log every activation and cancellation (who did it, when) so disputes can be traced.

**5. Wrong device date / time zone issues**
- Problem: if days remaining are computed from the phone clock, changing the device date can make an expired subscription look active; time zone differences can end a subscription a day early or late.
- Handling: subscription status (active/expired) is decided by **server time**, never the phone. A subscription stays valid through the whole end date and expires at the start of the next day. The "about to expire" notification is sent from the server so it arrives even if the app is closed.

**Optional sixth (if time allows):** "Forgot password" must exist from the first version, otherwise members create duplicate accounts with different numbers.

## 11. Visual design direction (from George's Stitch mockups: Home and My Subscription)

Follow this for all UI work so every screen matches. Colors below are approximate; take exact values from the Stitch project.

**Overall feel:** clean, calm, modern, friendly but premium. Lots of white space, uncluttered, big photos, prices clearly visible.

**Colors**
- Page background: very light lavender-tinted off-white.
- Cards: white.
- Primary accent: deep teal green. Used for primary buttons, round "+" buttons, progress bars, the active bottom-nav tab, the logo in the QR center, and big highlight numbers (e.g. "42 days left").
- Secondary tiles and buttons: light lavender-blue fill (small stat tiles, "Save to Wallet" style buttons).
- "Active" status: soft light-green pill with a small dot and green text.
- Text: near-black for headings, mid-grey for secondary text. Old prices in grey with strikethrough.

**Typography**
- Modern geometric sans-serif.
- Big bold headings ("Hello, Ahmed 👋", "My Subscription", "3-Month Tier 1 Access").
- Small uppercase, letter-spaced labels above sections ("CURRENT MEMBERSHIP", "THE GYM MEMBER").
- Short grey subtitle under section titles ("Special upgrades & packages").

**Shapes and depth**
- Large rounded corners on cards (about 20 to 24 px), pill shapes for badges and chips.
- Very soft shadows and thin light borders. No harsh lines.
- Full-width rounded buttons; circular icon buttons.

**Layout patterns**
- Top bar: gym logo on the left, small "THE GYM" label above the screen title, notification bell, round profile photo on the right.
- Bottom navigation: 4 tabs (Home, Plans, My Subscription, Profile) with simple line icons; the active tab is teal with a light highlight.
- Subscription card: plan name and tier, Active badge, two stat tiles side by side (Time Remaining, Valid Until), progress bar with "% elapsed", and a "Manage >" link.
- Offers: section title, grey subtitle, "View all →"; horizontally scrolling large photo cards; a small pill label on the photo (e.g. "Limited spots"); title and short subtitle; price in bold with the old price crossed out; round teal "+" button.
- Photos: large, bright, real gym and people photos with warm natural light.
- Text style: short, friendly English; prices in EGP with a thousands separator ("2,100 EGP").

**Open decisions (these appear in the mockups but are NOT in the current scope; do not build until George confirms)**
1. **QR entry pass** ("Hold near reader screen", "Save to Wallet", turnstiles/lockers, the "Pass" button on Home). Needs a scanner or reader at the gym, so it is a new feature.
2. **"Auto-renews" and "Next Renewal ... 1,500 EGP / Quarter".** This conflicts with the cash-only flow, where renewal means a new request, cash payment, and admin activation. Suggested alternative: a "Renew" button that creates a new request.
3. **Member ID ("#GYM-882491") and tiers ("Tier 1 Full Facility").** Would need a member_id field on users and a tier concept on plans (neither exists in the database yet).
4. **Offers such as "12 PT Sessions" and the "Limited spots" label.** PT packages are just a kind of offer, but a real seat counter needs extra rules (not in scope).
5. **"Manage >" link on the subscription card.** Its destination is not defined yet.
6. **Mockup placeholders to fix:** the gym logo image is broken (shows alt text "The Gym Logo"), and sample dates still show 2025.

**Reference images (source of truth for the look)**

Two Stitch mockups go with this file. If George attaches them in the chat, look at them before doing any UI work.

1. `the-gym-home-mockup.png`: Home screen. Greeting "Hello, Ahmed", "Pass" chip, subscription card (3-Month Plan, Active, 42 days left, Valid Until, progress bar 53%, "Unlimited gym & pool", "Manage >"), Offers section with a large photo card ("Limited spots", "12 PT Sessions", 2,100 EGP with 2,600 EGP crossed out, round teal "+").
2. `the-gym-my-subscription-mockup.png`: My Subscription screen. Member ID line, Active badge, QR pass card with "Save to Wallet" and a download button, "Current membership" card (3-Month Tier 1 Access, Time Remaining 42 days, Next Renewal 1,500 EGP / Quarter).

![Home mockup](the-gym-home-mockup.png)
![My Subscription mockup](the-gym-my-subscription-mockup.png)

Note: some elements in these images are still open decisions (see the list above).

## 12. Status and next step
- Plan is done. George has **not yet chosen** what to do next.
- Options offered: (a) interactive screen design/prototype, (b) detailed database structure + security rules, (c) start Flutter code.
- Ask George which one he wants, then proceed **step by step** with explanations.
