# Salesforce Tampermonkey Scripts 🚀

> A collection of productivity userscripts for Salesforce Lightning, maintained by **TWProject**.

These scripts are designed to improve your experience when working with Salesforce dashboards or login pages.

---

## 🔐 `autologin.user.js`

### 📋 Description
Automatically clicks the **Login** button on Salesforce when both the `username` and `password` fields are filled in.

### ⚙️ Features
- No credentials are stored or hardcoded
- Works only if both fields are filled
- Delayed execution for safety (1s)
- Compatible with Salesforce Classic login pages

### 🎯 Match URL
```
https://*.salesforce.com/*
```

---

## 📊 `autorefresh.user.js`

### 📋 Description
Automatically clicks the **"Refresh"** button in Salesforce Lightning dashboards every 5 minutes.  
Includes a floating badge showing a real-time countdown (`mm:ss` format).

### ⚙️ Features
- Runs only inside active dashboard iframe (avoids top-level frame)
- Uses MutationObserver to wait for the "Refresh" button to appear
- Displays a countdown badge at the top center of the screen
- Refreshes only when the button is visible and enabled

### 🎯 Match URL
```
https://*.lightning.force.com/*
```

### 🖼 Example badge:
```
⏳ Next refresh in 4:28
✅ Refreshed at 15:00:00 | ⏳ Next in 5:00
```

---

## 🛠 Installation

1. Install the [Tampermonkey](https://www.tampermonkey.net/) browser extension
2. Install each script via raw file or direct link:
   - [`autologin.user.js`](./autologin.user.js)
   - [`autorefresh.user.js`](./autorefresh.user.js)

---

## 🧩 Optional Improvements

- [ ] Add pause/resume toggle on the badge
- [ ] Manual refresh trigger via badge click
- [ ] Username save via `GM_setValue()` (optional)
- [ ] Custom refresh interval

---

## 📜 License

MIT License – use freely, modify safely, contribute optionally 😊

Made with ☕ and 🔧 by **TWProject**
