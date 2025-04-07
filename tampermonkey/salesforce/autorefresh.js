// ==UserScript==
// @name         Salesforce Auto Refresh (Reliable DOM Observer)
// @namespace    https://www.salesforce.com/
// @version      1.7
// @description  Auto-clicks "Refresh" every 5min in Salesforce dashboards with smart badge and MutationObserver – Public Release 💼⏳
// @author       TwProject (https://github.com/twproject/)
// @match        https://*.lightning.force.com/*
// @grant        none
// ==/UserScript==

(function () {
    'use strict';

    // 🛑 Prevent execution in outer shell to avoid duplication
    if (window.top === window.self) {
        console.warn('[AutoRefresh] ⛔ Top-level frame detected – skipping script to prevent duplication.');
        return;
    }

    const REFRESH_INTERVAL_SEC = 5 * 60; // 5 minutes
    let countdown = REFRESH_INTERVAL_SEC;

    // 🟢 Create status badge
    const badge = document.createElement('div');
    badge.id = 'auto-refresh-badge';
    badge.style.position = 'fixed';
    badge.style.top = '10px';
    badge.style.left = '50%';
    badge.style.transform = 'translateX(-50%)';
    badge.style.zIndex = '99999';
    badge.style.padding = '10px 15px';
    badge.style.backgroundColor = '#007bff';
    badge.style.color = 'white';
    badge.style.borderRadius = '8px';
    badge.style.boxShadow = '0 2px 6px rgba(0,0,0,0.2)';
    badge.style.fontFamily = 'monospace';
    badge.style.fontSize = '13px';
    badge.textContent = `⏳ Waiting for Refresh button...`;
    document.body.appendChild(badge);

    function updateBadge(text) {
        badge.textContent = text;
    }

    function findButton() {
        return [...document.querySelectorAll('button')]
            .find(b => b.classList.contains('refresh') || b.innerText.trim().toLowerCase() === 'refresh');
    }

    function tryClickRefresh() {
        const btn = findButton();

        if (btn) {
            const isVisible = btn.offsetParent !== null;
            const isEnabled = !btn.disabled;
            console.log(`[AutoRefresh] 🧐 Found button → visible: ${isVisible}, enabled: ${isEnabled}`);

            if (isVisible && isEnabled) {
                const time = new Date().toLocaleTimeString();
                btn.click();
                console.log(`[AutoRefresh] ✅ Clicked at ${time}`);
                updateBadge(`✅ Refreshed at ${time} | ⏳ Next in 5:00`);
                countdown = REFRESH_INTERVAL_SEC;
                return;
            }
        }

        console.warn('[AutoRefresh] 🔍 Refresh button not found or not ready.');
        updateBadge(`⚠️ Button not found – retrying in ${formatCountdown(countdown)}`);
    }

    function formatCountdown(seconds) {
        const mins = Math.floor(seconds / 60);
        const secs = seconds % 60;
        return `${mins}:${secs.toString().padStart(2, '0')}`;
    }

    // 👁️ Listen for DOM mutations
    const observer = new MutationObserver(() => {
        const btn = findButton();
        if (btn) {
            console.log('[AutoRefresh] 🎯 Refresh button detected via MutationObserver');
        }
    });

    observer.observe(document.body, {
        childList: true,
        subtree: true
    });

    // ⏱ Start countdown loop
    console.log('[AutoRefresh] 🟢 Script running. Countdown started...');
    setInterval(() => {
        if (countdown <= 0) {
            tryClickRefresh();
        } else {
            updateBadge(`⏳ Next refresh in ${formatCountdown(countdown)}`);
            countdown--;
        }
    }, 1000);
})();
