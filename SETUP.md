# Macro Ledger: setup

This gets Macro Ledger running at your own web address, with your log synced across every device you sign in on. Everything here uses free plans. It takes about 15 minutes.

You'll set up three things, in this order:

1. **Supabase**: stores your log and handles sign-in. (Free.)
2. **USDA key**: for searching the USDA food database. (Free; optional.)
3. **GitHub Pages**: hosts the app. (Free.)

Files in this folder:

| File | What it is |
|---|---|
| `index.html` | The whole app. |
| `supabase-setup.sql` | Creates your database tables. You paste it into Supabase once. |
| `supabase-weights.sql` | Adds bodyweight syncing to an older setup. |
| `supabase-delete-account.sql` | Adds "Delete my account and data" to an older setup. |
| `SETUP.md` | This guide. |

---

## 1. Supabase (storage and sign-in)

1. Go to **https://supabase.com** and click **Start your project**. Sign up with GitHub or email.
2. Click **New project**.
   - **Name:** `macro-ledger`
   - **Database password:** click **Generate a password**. You won't need it again for this app, but save it somewhere anyway.
   - **Region:** pick the one closest to you (for India, **Mumbai**).
   - Click **Create new project** and wait a minute or two while it sets up.
3. In the left sidebar, open **SQL Editor**, then click **New query**.
4. Open `supabase-setup.sql` from this folder, copy everything in it, paste it into the editor and click **Run**. You should see "Success. No rows returned".
5. Get your two connection settings. Click **Connect** at the top of the project page, or go to **Project Settings → API Keys** (older dashboards call it **Project Settings → API**). Copy:
   - **Project URL**: looks like `https://abcdefghijkl.supabase.co`
   - **anon public key**: a long string starting with `eyJ...`. If your dashboard shows a **publishable key** (starts with `sb_publishable_`) instead, that works too.

   These two are designed to be public; your data is protected by sign-in and the rules the SQL script set up. **Never** use the key labelled `service_role` or `secret`.
6. Turn off email confirmation, so creating your account doesn't need an email. Supabase's free email sender only allows a couple of emails per hour.
   - Go to **Authentication → Sign In / Providers** (older dashboards: **Authentication → Providers**) and open **Email**.
   - Switch off **Confirm email** and click **Save**.
7. You'll come back to Supabase in step 4 to tell it your app's address.

## 2. USDA key (optional)

The app can search the USDA food database with the shared key `DEMO_KEY`, which allows only a few searches per hour. Your own key is free and allows far more.

1. Go to **https://fdc.nal.usda.gov/api-key-signup.html**.
2. Enter your name and email and submit. The key arrives by email within a minute.

Open Food Facts (packaged foods) needs no key.

## 3. Put your settings into the app

1. Open `index.html` in a text editor (Notepad works; VS Code is nicer).
2. Near the top of the `<script>` section, find this block:

   ```js
   const CONFIG = {
     SUPABASE_URL: "",
     SUPABASE_ANON_KEY: "",
     USDA_API_KEY: "DEMO_KEY",
   ```

3. Paste your values between the quotes:

   ```js
   const CONFIG = {
     SUPABASE_URL: "https://abcdefghijkl.supabase.co",
     SUPABASE_ANON_KEY: "eyJhbGciOi...your whole key...",
     USDA_API_KEY: "your USDA key, or leave DEMO_KEY",
   ```

4. Save the file.

## 4. GitHub Pages (hosting)

1. Go to **https://github.com** and create an account if you don't have one. Your username becomes part of the app's address.
2. Click **+** (top right) → **New repository**.
   - **Repository name:** `macro-ledger`
   - Choose **Public**. Free GitHub Pages needs a public repository. Only the app's code is public; your food log stays in Supabase behind your sign-in.
   - Click **Create repository**.
3. On the new repository page, click **uploading an existing file**. Drag in `index.html` (you can add `SETUP.md` and `supabase-setup.sql` too). Click **Commit changes**.
4. Go to **Settings → Pages**.
   - Under **Build and deployment → Source**, choose **Deploy from a branch**.
   - **Branch:** `main`, folder **/ (root)**. Click **Save**.
5. Wait one or two minutes, then refresh the page. It shows your address:
   `https://YOUR-USERNAME.github.io/macro-ledger/`
6. **Back in Supabase**, go to **Authentication → URL Configuration**:
   - **Site URL:** `https://YOUR-USERNAME.github.io/macro-ledger/`
   - Under **Redirect URLs**, click **Add URL** and add the same address.
   - Click **Save**.

   This tells Supabase where to send you after you click the sign-in link in your email.

## 5. Sign in on each device

1. Open your app's address.
2. Click the **gear** (top right), then the **Account** tab.
3. **First device only:** enter your email and a password (6+ characters), then click **Create account**. You're signed in straight away.
4. **Every other device:** enter the same email and password and click **Sign in**.

You stay signed in on each device, so this is a one-time step per device. No emails are sent, so there's no limit.

**Already made an account with an email link?** That account has no password yet. Either:

- On a device where you're **already signed in**, open **Account**, type a new password under your email and click **Set password**; or
- If you aren't signed in anywhere, set one from Supabase. Go to **SQL Editor → New query**, paste this with your own email and password, and click **Run**:

  ```sql
  update auth.users
  set encrypted_password = extensions.crypt('YOUR-NEW-PASSWORD', extensions.gen_salt('bf'))
  where email = 'you@example.com';
  ```

  It should say "1 row affected". Then sign in with that email and password.

Anything you logged on a device before signing in is added to your account the first time you sign in there.

**Add it to your home screen** so it opens like an app:

- **iPhone (Safari):** Share button → **Add to Home Screen**.
- **Android (Chrome):** ⋮ menu → **Add to Home screen** (or **Install app**).

## Bodyweight syncing (one-time step for existing setups)

**WeightLedger** (the 🧍 button next to the gear) saves your morning weigh-ins. To sync them across devices like your food log, Supabase needs one more table:

1. In Supabase, open **SQL Editor → New query**.
2. Open `supabase-weights.sql` from this folder, copy everything, paste it in and click **Run**. You should see "Success. No rows returned".
3. Reopen the app. Any weights you logged before this step are uploaded automatically.

If you're setting up from scratch, `supabase-setup.sql` already includes this table, so you can skip this step.

## Account deletion (one-time step for existing setups)

**Settings → Account → Delete my account and data** lets anyone permanently delete their own account and everything in it. Supabase only allows this through a small database function, so it has to be added once:

1. In Supabase, open **SQL Editor → New query**.
2. Open `supabase-delete-account.sql` from this folder, copy everything, paste it in and click **Run**. You should see "Success. No rows returned".

The function only ever deletes the account of the person who is signed in, so nobody can delete anyone else. If you're setting up from scratch, `supabase-setup.sql` already includes it. Until it's added, the button explains that deletion isn't set up yet and deletes nothing.

People who use the app without an account get **Delete everything on this device** instead, which wipes all the app's data from that browser.

## AI estimates (optional, free)

With a free Google Gemini key, you can describe food in your own words ("a small pizza with a few chicken pieces") and get an estimate, instead of being limited to the built-in list.

1. Go to **https://aistudio.google.com/apikey** and sign in with your Google account.
2. Click **Create API key**. If it asks, let it create a new project. Copy the key.
3. In the app, click the **gear** (top right) → **Account** → **AI estimates**, paste the key and click **Save key**. The app checks the key and picks a Gemini model it can use.
4. On the **Log** page, **Estimate with** now shows **AI (Gemini)** and **Built-in list**. Pick whichever you like; the app remembers your choice.

Good to know:

- The key is saved **on that device only**, not in your account, so add it on each device you use.
- The free tier has per-minute and per-day limits. If you hit one, the app says so; switch to **Built-in list** or try again later.
- On the free tier, Google may use what you send to improve its products. The app only sends the food description you typed, plus the names and numbers of foods you've saved in My foods (so Gemini can use them). Foods the built-in list or My foods already know aren't sent at all.
- Treat the key like a password. If it leaks, delete it in AI Studio and make a new one.

## Updating the app later

When you get a new `index.html`, copy your three `CONFIG` values into it, then in your GitHub repository click `index.html` → the pencil icon (or **Add file → Upload files** to replace it) → **Commit changes**. The site updates within a couple of minutes.

## Moving your log from the claude.ai version

In the claude.ai version, click **Goals → Download backup** and accept the download. Then in the new app open the **gear → Account → Load backup** and choose that file. Loading only adds entries you don't already have, so it's safe to do twice.

## Good to know

- **Supabase pauses free projects after about a week with no activity.** Daily logging keeps it awake. If it does pause, open supabase.com, select the project and click **Restore**; nothing is lost.
- **Sign-in emails:** Supabase's built-in email sender allows only a couple of emails per hour for the whole project, so use a password to sign in. The **Email me a sign-in link instead** option is there as a fallback.
- **Backups:** **gear → Account → Download backup** saves your whole log as a file. Doing this now and then costs nothing.
- **Sign out on shared devices:** signing out removes the log from that browser.

## If something doesn't work

| What you see | What to do |
|---|---|
| Footer says "Set up sync in SETUP.md" | The `CONFIG` values are empty or mistyped. The URL must look exactly like `https://xxxx.supabase.co`, with no trailing path. |
| "Email rate limit exceeded" | You hit Supabase's email limit. Sign in with a password instead (step 5); passwords send no email. |
| "Supabase is still set to confirm new accounts by email" | Switch off **Confirm email** (step 1.6), then press **Sign in**. |
| "That email and password don't match" | Check the password. If the account was made with an email link, set a password first (step 5). |
| The sign-in link opens a page that says the address can't be reached, or goes to `localhost` | Fix **Site URL** and **Redirect URLs** in Supabase (step 4.6). |
| "Couldn't reach your account" | The Supabase project may be paused (see above), or you're offline. Your entries stay on the device and sync once it reconnects and you make a change. |
| Search says a database didn't answer | Try again in a moment. With `DEMO_KEY`, USDA allows only a few searches per hour, so get your own key (step 2). |
| GitHub address shows "404" | Wait a few minutes after turning on Pages, and check the file is named exactly `index.html`. |
