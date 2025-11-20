<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Dashboard.master" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="TrackingSystem.index" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<!--
  index.aspx — Updated:
  - Devices-style heading + Summary (option C)
  - Accent persistence: reads 'uiAccent' OR 'accent' for compatibility
  - Accent applied to :root CSS variables and inline fallbacks
  - Removed theme control block (as requested)
  - Chart / Leaflet integrations preserved and recolored on accent change
-->

<!-- CDNs -->
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
  /* -------------------------
     CSS VARIABLES & THEME
     ------------------------- */
  :root{
    --accent: #2563eb;           /* main accent */
    --accent-light: #00c6ff;     /* accent gradient start */
    --accent-strong: #0b1220;    /* contrast color */
    --bg: #f4f7fb;
    --card: rgba(255,255,255,0.85);
    --glass-blur: 10px;
    --muted: #6b7280;
    --text: #0f1724;
    --shadow-sm: 0 8px 28px rgba(15,23,42,0.06);
    --shadow-lg: 0 18px 48px rgba(2,6,23,0.09);
    --radius: 16px;
  }

  body.theme-dark{
    --bg: #071028;
    --card: rgba(16,24,36,0.6);
    --muted: #9aa6b2;
    --text: #e6eef7;
    --shadow-sm: 0 10px 30px rgba(0,0,0,0.6);
    --shadow-lg: 0 20px 60px rgba(0,0,0,0.6);
  }

  /* ---------- Base ---------- */
  :root, body { transition: background .28s ease, color .28s ease; }
  body {
    margin: 0;
    font-family: "Poppins", system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial;
    background: radial-gradient(1200px 400px at 10% 10%, rgba(37,99,235,0.06), transparent 12%),
                linear-gradient(180deg, var(--bg), var(--bg));
    color: var(--text);
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
  }

 /* Remove extra space above heading */


/* Card accent strip should match accent */
.accent-strip {
    position:absolute; 
    left:0; top:0; bottom:0;
    width:6px;
    border-top-left-radius:var(--radius);
    border-bottom-left-radius:var(--radius);
    background: linear-gradient(180deg, var(--accent-light), var(--accent)) !important;
    transition: background .25s ease;
}

.glass-card .accent-strip {
    background: linear-gradient(180deg, var(--accent-light), var(--accent)) !important;
}



/* Icons inside cards should tint automatically */
.glass-icon {
    position:absolute;
    right:18px;
    bottom:14px;
    font-size:44px;
    opacity:.13;
    color: var(--accent); /* updated */
    transition: opacity .2s ease, transform .2s ease, color .25s ease;
}


  /* ===== Devices-style heading (option C) ===== */
  .page-heading {
    display:flex;
    align-items:center;
    gap:14px;
    margin-bottom: 18px;
  }
  .heading-accent {
    width:6px;
    height:48px;
    border-radius:4px;
    background: linear-gradient(180deg,var(--accent-light),var(--accent));
    box-shadow: 0 6px 18px rgba(0,0,0,0.06);
    flex-shrink:0;
  }
  .heading-left { flex:1; }
  .page-title { margin:0; font-size:26px; font-weight:800; color:var(--text); }
  .page-sub { margin:0px 0 0; color:var(--muted); font-size:13px; }

  /* Summary title style (like Devices screenshot) */
  .summary-row { margin: 18px 0 12px; display:flex; align-items:center; gap:12px; }
  .summary-title {
    font-weight:800;
    font-size:18px;
    color:var(--accent-strong);
    margin:0;
  }
  .summary-sub {
    color:var(--muted);
    font-size:13px;
    margin-left:8px;
  }

  /* Dashboard Grid */
  .dashboard-grid {
    display: grid;
    gap: 20px;
    grid-template-columns: repeat(4, 1fr);
    margin-bottom: 20px;
  }
  @media (max-width:1100px) { .dashboard-grid { grid-template-columns: repeat(2, 1fr); } }
  @media (max-width:640px) { .dashboard-grid { grid-template-columns: 1fr; } }

  .glass-card {
    position: relative;
    border-radius: var(--radius);
    padding: 18px;
    min-height: 130px;
    background: linear-gradient(180deg, rgba(255,255,255,0.6), rgba(255,255,255,0.35));
    backdrop-filter: blur(var(--glass-blur));
    box-shadow: var(--shadow-sm);
    border: 1px solid rgba(255,255,255,0.6);
    overflow: hidden;
    transition: transform .22s ease, box-shadow .22s ease, background .22s ease;
  }
  body.theme-dark .glass-card {
    background: linear-gradient(180deg, rgba(255,255,255,0.02), rgba(255,255,255,0.01));
    border: 1px solid rgba(255,255,255,0.04);
  }
  .glass-card:hover { transform: translateY(-6px); box-shadow: var(--shadow-lg); }
  .stat-label { color: var(--muted); font-weight:700; font-size:13px; margin-bottom: 8px; }
  .stat-value { font-size:34px; font-weight:900; color:var(--text); }

  
  .glass-card:hover .glass-icon { opacity: .28; transform: scale(1.06); }

  

  .spark { width:100%; height:52px; margin-top:10px; }

  .main-row { display:grid; grid-template-columns: 2fr 1fr; gap:20px; }
  @media (max-width:960px){ .main-row { grid-template-columns: 1fr; } }

  .map-card { border-radius: var(--radius); padding:12px; background: var(--card); box-shadow: var(--shadow-sm); border: 1px solid rgba(15,23,42,0.04); min-height: 420px; overflow: hidden; }
  #map { height: 360px; width: 100%; border-radius: 10px; }

  .activity-card { border-radius: var(--radius); padding:14px; background: var(--card); box-shadow: var(--shadow-sm); border: 1px solid rgba(15,23,42,0.04); min-height: 420px; }
  .activity-list { list-style:none; padding:0; margin: 8px 0 0; color:var(--muted); }
  .activity-list li { display:flex; gap:12px; align-items:flex-start; padding:10px 0; border-bottom:1px dashed rgba(15,23,42,0.04); }
  .dot { width:10px; height:10px; border-radius:50%; margin-top:6px; flex-shrink:0; }

  .controls { display:flex; gap:10px; align-items:center; }
  .btn {
    display:inline-flex; align-items:center; gap:8px;
    padding:8px 12px; border-radius:10px; border:none; cursor:pointer; font-weight:700;
    background: linear-gradient(90deg, var(--accent-light), var(--accent));
    color: white; box-shadow: 0 8px 20px rgba(37,99,235,0.12);
  }
  .btn.ghost { background: transparent; color: var(--muted); border:1px solid rgba(15,23,42,0.04); box-shadow:none; }

  .muted { color: var(--muted); font-size:13px; }

</style>

<div class="page-wrap">

  <!-- Devices-style heading (option C) -->
  <div class="page-heading" role="banner" aria-label="Page heading">
    <div class="heading-accent" aria-hidden="true"></div>
    <div class="heading-left">
      <h2 class="page-title">Dashboard</h2>
      <div class="page-sub">Overview & live monitoring</div>
    </div>
    <div><!-- right side empty (keeps spacing like devices screenshot) --></div>
  </div>

  <!-- Summary title that matches Devices layout -->
  <div class="summary-row" aria-hidden="false">
    <h3 class="summary-title">Summary</h3>
    <div class="summary-sub">Key metrics and quick glance statistics.</div>
  </div>

  <!-- Stats grid -->
  <div class="dashboard-grid" role="region" aria-label="Key metrics">
    <div class="glass-card" aria-hidden="false">
      <div class="accent-strip" aria-hidden="true"></div>
      <div class="stat-label">Total Vehicles</div>
      <div class="stat-value" id="totalVehicles">18</div>
      <canvas id="spark1" class="spark" aria-hidden="true"></canvas>
      <i class="fa-solid fa-truck-fast glass-icon" aria-hidden="true"></i>
    </div>

    <div class="glass-card">
      <div class="accent-strip"></div>
      <div class="stat-label">Active Trips</div>
      <div class="stat-value" id="activeTrips">7</div>
      <canvas id="spark2" class="spark" aria-hidden="true"></canvas>
      <i class="fa-solid fa-route glass-icon"></i>
    </div>

    <div class="glass-card">
      <div class="accent-strip"></div>
      <div class="stat-label">Online Devices</div>
      <div class="stat-value" id="onlineDevices">14</div>
      <canvas id="spark3" class="spark" aria-hidden="true"></canvas>
      <i class="fa-solid fa-wifi glass-icon"></i>
    </div>

    <div class="glass-card">
      <div class="accent-strip"></div>
      <div class="stat-label">Alerts</div>
      <div class="stat-value" id="alertsCount">3</div>
      <canvas id="spark4" class="spark" aria-hidden="true"></canvas>
      <i class="fa-solid fa-bell glass-icon"></i>
    </div>
  </div>

  <!-- Map + activity -->
  <div class="main-row">
    <div class="map-card" role="region" aria-label="Live map">
      <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;">
        <div style="font-weight:800">Live Location Overview</div>
        <div class="muted">Updated just now</div>
      </div>
      <div id="map"></div>
    </div>

    <aside class="activity-card" role="complementary" aria-label="Recent activity">
      <div style="display:flex;justify-content:space-between;align-items:center;">
        <div style="font-weight:800">Recent Activity</div>
        <div class="muted">Timeline</div>
      </div>

      <ul class="activity-list" id="activityList" aria-live="polite">
        <li><span class="dot" style="background:#10b981"></span><div><strong>MH12AB1234</strong><div class="muted">started a new trip • 5m ago</div></div></li>
        <li><span class="dot" style="background:#3b82f6"></span><div><strong>MH14XY5678</strong><div class="muted">arrived at destination • 22m ago</div></div></li>
        <li><span class="dot" style="background:#f59e0b"></span><div><strong>MH10PQ4567</strong><div class="muted">speed alert • 40m ago</div></div></li>
        <li><span class="dot" style="background:#ef4444"></span><div><strong>MH20CD9999</strong><div class="muted">device offline • 2h ago</div></div></li>
      </ul>
    </aside>
  </div>

</div>

<script>
  

        // helper: hex to rgba
        function hexToRgba(hex, alpha) {
            const h = hex.replace('#', '');
            const r = parseInt(h.substring(0, 2), 16);
            const g = parseInt(h.substring(2, 4), 16);
            const b = parseInt(h.substring(4, 6), 16);
            return `rgba(${r},${g},${b},${alpha})`;
        }

        // apply theme if stored
        function applyThemeFromStorage() {
            const isDark = localStorage.getItem(THEME_KEY) === 'true';
            document.body.classList.toggle('theme-dark', isDark);
        }

        // initialize accent from storage; default electric
        const initial = readSavedAccent() || 'electric';
        applyAccent(initial);
        applyThemeFromStorage();

        // react to storage changes (other tabs/pages)
        window.addEventListener('storage', function (e) {
            if (!e.key || e.key === 'uiAccent' || e.key === 'accent') {
                const newVal = readSavedAccent() || 'electric';
                applyAccent(newVal);
            }
            if (e.key === THEME_KEY) applyThemeFromStorage();
        });

        // Expose a helper for dev console
        window.__applyAccent = applyAccent;

        // Optional: make heading accent clickable to cycle (DEV convenience)
        // document.querySelector('.heading-accent')?.addEventListener('click', ()=> {
        //   const keys = Object.keys(ACCENTS);
        //   const cur = readSavedAccent() || 'electric';
        //   const idx = (keys.indexOf(cur) + 1) % keys.length;
        //   applyAccent(keys[idx]);
        // });

    })();


    /* -----------------------------
       Mini spark charts (Chart.js)
       Use CSS variables for colors
    ----------------------------- */
    let sparks = [];
    function hexToRgb(hex) {
        const h = hex.replace('#', '');
        return { r: parseInt(h.slice(0, 2), 16), g: parseInt(h.slice(2, 4), 16), b: parseInt(h.slice(4, 6), 16) };
    }

    function createSpark(ctx, data, color) {
        return new Chart(ctx, {
            type: 'line',
            data: { labels: data.map((_, i) => i + 1), datasets: [{ data, fill: true, tension: .4, borderWidth: 1.5, pointRadius: 0 }] },
            options: {
                responsive: true, maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: { x: { display: false }, y: { display: false } },
                elements: {
                    line: { borderColor: color, backgroundColor: color.replace('rgb', 'rgba').replace(')', ',0.10)'}
                }
            }
        });
    }

    function refreshSparks() {
        const accent = getComputedStyle(document.documentElement).getPropertyValue('--accent').trim() || '#2563eb';
        const accentRgb = hexToRgb(accent);
        const color = `rgb(${accentRgb.r}, ${accentRgb.g}, ${accentRgb.b})`;
        // destroy existing
        sparks.forEach(s => s.destroy && s.destroy());
        sparks = [];
        // sample data
        const ds = [
            [3, 5, 6, 7, 9, 8, 10],
            [2, 3, 4, 6, 5, 6, 7],
            [4, 3, 3, 4, 6, 7, 8],
            [1, 2, 3, 2, 4, 3, 5]
        ];
        const ids = ['spark1', 'spark2', 'spark3', 'spark4'];
        ids.forEach((id, i) => {
            const el = document.getElementById(id);
            if (!el) return;
            const ctx = el.getContext('2d');
            sparks.push(createSpark(ctx, ds[i], color));
        });
    }

    document.addEventListener('DOMContentLoaded', function () {
        // small delay to ensure CSS var updates applied
        setTimeout(refreshSparks, 60);
    });




    /* -----------------------------
       Leaflet Map Init & dynamic recolor on accent change
    ----------------------------- */
    (function () {
        const map = L.map('map', { zoomControl: false }).setView([19.0760, 72.8777], 10);
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { maxZoom: 18 }).addTo(map);

        // demo markers
        const sample = [
            { lat: 19.0760, lng: 72.8777, label: 'MH12AB1234', color: getComputedStyle(document.documentElement).getPropertyValue('--accent').trim() },
            { lat: 19.16, lng: 72.97, label: 'MH14XY5678', color: '#10b981' },
            { lat: 19.03, lng: 72.90, label: 'MH10PQ4567', color: '#f59e0b' }
        ];

        const markers = sample.map(s => {
            const m = L.circleMarker([s.lat, s.lng], { radius: 7, color: s.color, fillColor: s.color, fillOpacity: 0.9 }).addTo(map);
            m.bindPopup(`<b>${s.label}</b>`);
            return m;
        });

        if (markers.length) {
            const group = L.featureGroup(markers);
            map.fitBounds(group.getBounds().pad(0.4));
        }

        // listen for accent changes (both keys)
        window.addEventListener('storage', function (e) {
            if (!e.key || e.key === 'uiAccent' || e.key === 'accent') {
                const accent = getComputedStyle(document.documentElement).getPropertyValue('--accent').trim();
                // recolor the first marker (assumed to be the fleet highlight)
                if (markers[0]) markers[0].setStyle({ color: accent, fillColor: accent });
            }
        });

        // also support same-tab changes (some pages dispatch a custom event)
        document.addEventListener('accent-changed', function () {
            const accent = getComputedStyle(document.documentElement).getPropertyValue('--accent').trim();
            if (markers[0]) markers[0].setStyle({ color: accent, fillColor: accent });
        });

        // responsive map redraw
        window.addEventListener('resize', () => setTimeout(() => map.invalidateSize(), 200));
        document.addEventListener('visibilitychange', () => { if (!document.hidden) setTimeout(() => map.invalidateSize(), 200); });
    })();


    /* -----------------------------
       small utility wrapper (used above)
    ----------------------------- */
    function getCssVar(name) { return getComputedStyle(document.documentElement).getPropertyValue(name).trim(); }

</script>

    <script>
        /* ===============================================
           UNIVERSAL ACCENT ENGINE (MASTER + ALL PAGES)
           =============================================== */

        const ACCENT_PRESETS = {
            /* BLUE (Electric) */
            electric: {
                primary: "#00c6ff",       // light blue
                primary2: "#2563eb",      // main blue
                accentLight: "#00c6ff",
                accent: "#2563eb",
                contrast: "#0b1220"
            },

            /* CYAN / TURQUOISE (Your 2nd accent) */
            purple: {                     // keep key 'purple' because your swatches use it
                primary: "#06b6d4",       // light cyan
                primary2: "#0ea5e9",      // main cyan (NO PURPLE ANYMORE)
                accentLight: "#06b6d4",
                accent: "#0ea5e9",
                contrast: "#0b1220"
            },

            /* ORANGE (Warm) */
            warm: {
                primary: "#fb923c",       // light orange
                primary2: "#f97316",      // main orange
                accentLight: "#fb923c",
                accent: "#f97316",
                contrast: "#0b1220"
            }
        };


        function applyGlobalAccent() {
            const key = localStorage.getItem("uiAccent") || "electric";
            const a = ACCENT_PRESETS[key] || ACCENT_PRESETS.electric;

            /* SET ALL GLOBAL VARIABLES */
            document.documentElement.style.setProperty("--primary", a.primary);
            document.documentElement.style.setProperty("--primary-2", a.primary2);
            document.documentElement.style.setProperty("--accent-light", a.accentLight);
            document.documentElement.style.setProperty("--accent", a.accent);
            document.documentElement.style.setProperty("--accent-contrast", a.contrast);

            /* UPDATE SIDEBAR GRADIENT */
            document.querySelector(".sidebar").style.background =
                `linear-gradient(180deg, ${a.primary2}, ${a.contrast} 80%)`;

            /* UPDATE ACTIVE MENU */
            document.querySelectorAll(".menu li.active .menu-link").forEach(el => {
                el.style.borderLeft = `4px solid ${a.primary2}`;
                el.style.color = a.primary2;
            });

            /* UPDATE ICONS */
            document.querySelectorAll(".menu-link i").forEach(el => {
                if (el.closest("li").classList.contains("active")) {
                    el.style.color = a.primary2;
                }
            });

            /* UPDATE BUTTONS */
            document.querySelectorAll(".btn-primary").forEach(b => {
                b.style.background =
                    `linear-gradient(90deg, ${a.primary}, ${a.primary2})`;
            });

            /* UPDATE PROFILE ICONS */
            document.querySelectorAll(".profile-wrapper i").forEach(el => {
                el.style.color = a.primary2;
            });

            /* UPDATE SEARCH ICON */
            document.querySelectorAll(".search-icon").forEach(el => {
                el.style.color = a.primary2;
            });
        }

        /* run on load */
        applyGlobalAccent();

        /* sync across pages */
        window.addEventListener("storage", function (e) {
            if (e.key === "uiAccent") applyGlobalAccent();
        });
    </script>


</asp:Content>
