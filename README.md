# Macro Ledger

**A free calorie and macro tracker that understands Indian food, including hostel mess food.**

Generic fitness apps don't know what's in a bowl of mess dal or a plate of chhole bhature, and the good ones charge a yearly fee. Macro Ledger is a free alternative built around how students in India actually eat.

**Try it:** https://macroledger-iota.vercel.app/

---

## What it does

**Logging food**
- Type what you ate in plain words ("2 rotis, a bowl of dal and 100 g paneer") and it splits it into items with calories, protein, carbs, fat and fiber.
- A built-in list of Indian home dishes, North and South, estimated the way they're cooked at home (about 5 g oil per serving, no cream finish) rather than restaurant-style.
- The **IIIT Allahabad BH1/BH4 mess menu** built in, with real mess portions and oil habits (fried breads blotted, floating oil skimmed off).
- Combination plates such as pav bhaji or chhole bhature split into countable parts, so you choose how many pav or bhature you had.
- Small / Medium / Large sizes for breads (roti, puri, bhatura, paratha, dosa and more).
- Understands spelling variants: bhatura, bhature and bhatoora; puri, poori and pudi.
- **My foods**: save anything you eat often with your own numbers.
- Optional AI estimates with your own free Google Gemini key, for dishes that aren't on the list.
- USDA and Open Food Facts search for packaged and raw foods.

**Planning**
- Diet plans: Fat loss, Body recomposition, Lean bulk or Custom, with safe rate limits.
- Maintenance calories from the Mifflin-St Jeor equation and FAO/WHO activity levels.
- **Adaptive maintenance**: after a few weeks of weigh-ins, it learns your real maintenance from what you ate and how your weight changed, and updates your targets.
- Notifications when your targets change.

**Bodyweight (WeightLedger)**
- Morning weigh-ins with weekly averages and progress toward your goal weight.

**Everything else**
- Four meal blocks (breakfast, lunch, snacks, dinner) with per-meal macros.
- 15 colour themes designed with colour theory, with macro colours checked for colour-blind readability.
- Works on phone and desktop; add it to your home screen like an app.
- Sign in to sync across devices, or use it without an account.

## Privacy

- Your log is stored in your own account, protected by Supabase row-level security, so nobody else can read it.
- No ads and no tracking.
- **Delete my account and data** removes everything permanently.
- If you use AI estimates, only the food description you type is sent to Gemini. Your key stays on your device.

## Built with

- Plain HTML, CSS and JavaScript in a single file, with no build step
- [Supabase](https://supabase.com) for sign-in and sync
- Vercel for hosting
- USDA FoodData Central, Open Food Facts and Google Gemini (optional) for food data

This app was built with **[Claude Code](https://claude.com/claude-code)**, an AI coding agent. I designed the product, made the decisions about what it should do and how, and directed and tested every change. Claude Code wrote most of the code.

## Run your own copy

The whole app is `index.html`. To host your own version with sync, follow **[SETUP.md](SETUP.md)**. It takes about 15 minutes and every service it uses has a free plan.

| File | What it is |
|---|---|
| `index.html` | The whole app |
| `SETUP.md` | Step-by-step setup guide |
| `supabase-setup.sql` | Creates the database tables (for a new setup) |
| `supabase-weights.sql` | Adds bodyweight syncing to an older setup |
| `supabase-delete-account.sql` | Adds account deletion to an older setup |

## Status

This is a work in progress. Calorie estimates for some dishes still need to be more accurate, and I'm working to make it simpler to use. Feedback and suggestions are welcome: open an issue.

> Estimates are approximate and this app is not medical advice. Talk to a doctor or dietitian before major diet changes.
