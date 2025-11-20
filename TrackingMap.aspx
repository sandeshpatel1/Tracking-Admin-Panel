<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Dashboard.Master" AutoEventWireup="true" CodeBehind="TrackingMap.aspx.cs" Inherits="TrackingSystem.WebForm1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<!--
  TrackingMap.aspx - accent + theme aware
  Option A1: "View Asset List" appears ONLY when the panel is collapsed.
-->

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

<style>
  /* ------------------------------
     CSS Variables (will be overwritten by JS)
     ------------------------------ */
  :root{
    --accent: #2563eb;
    --accent-light: #00c6ff;
    --accent-contrast: #0b1220;

    --bg: #f4f6f9;
    --card: #ffffff;
    --muted: #6b7280;
    --text: #0f172a;
    --shadow: 0 6px 20px rgba(15,23,42,0.06);
    --radius: 12px;
  }

  body.theme-dark{
    --bg: #071028;
    --card: #0f1724;
    --muted: #9aa6b2;
    --text: #e6eef7;
    --shadow: 0 12px 36px rgba(2,6,23,0.6);
  }

  /* Container */
  .tracking-container {
    display:flex;
    gap:16px;
    height: calc(100vh - 140px);
    transition: all .32s ease;
    align-items:stretch;
  }

  /* Filters row */
  .device-status-bar {
    width:100%;
    display:flex;
    gap:8px;
    align-items:center;
    flex-wrap:wrap;
    margin-bottom:8px;
  }
  .device-filter {
    display:inline-flex; align-items:center; gap:8px;
    padding:8px 12px; border-radius:999px;
    background:var(--card);
    box-shadow:var(--shadow);
    border:1px solid rgba(15,23,42,0.04);
    color:var(--text); font-weight:700; cursor:pointer;
  }
  .device-filter .count {
    background: rgba(0,0,0,0.04);
    padding:2px 8px; border-radius:12px; font-weight:800; font-size:12px;
  }
  body.theme-dark .device-filter { background: rgba(255,255,255,0.02); border-color: rgba(255,255,255,0.04); color:var(--text); }
  body.theme-dark .device-filter .count { background: rgba(255,255,255,0.04); color:var(--accent); }

  /* Assets panel */
  .assets-panel {
    width: 320px;
    min-width: 280px;
    background: var(--card);
    border-radius:12px;
    box-shadow: var(--shadow);
    padding:14px;
    overflow-y:auto;
    transition: all .32s ease;
    position: relative;
    z-index: 20;
    border: 1px solid rgba(15,23,42,0.04);
  }
  .assets-panel.collapsed {
    width:0; min-width:0; padding:0; opacity:0; overflow:hidden; border:none;
  }

  /* Header controls */
  .assets-header { display:flex; justify-content:space-between; align-items:center; gap:8px; margin-bottom:10px; }
  .assets-header .left { display:flex; flex-direction:column; }
  .assets-header h5 { margin:0; font-size:16px; font-weight:800; color:var(--text); }
  .assets-header p { margin:0; color:var(--muted); font-size:13px; }

  .assets-controls { display:flex; gap:8px; align-items:center; }
  .assets-controls .btn-icon {
    width:36px; height:36px; display:flex; align-items:center; justify-content:center; border-radius:8px;
    background: linear-gradient(180deg, rgba(0,0,0,0.02), rgba(0,0,0,0.01));
    box-shadow: var(--shadow); border:none; cursor:pointer;
  }
  body.theme-dark .assets-controls .btn-icon { background: rgba(255,255,255,0.02); }

  /* Assets list */
  .assets-body { display:flex; flex-direction:column; gap:12px; margin-top:6px; }

  .asset-card {
    display:flex; align-items:center; gap:12px;
    background: var(--card); border-radius:12px; padding:12px;
    border-left:6px solid transparent; /* changed dynamically */
    box-shadow: 0 6px 18px rgba(15,23,42,0.04);
    transition: transform .18s ease, box-shadow .18s ease, border-left-color .18s ease;
    cursor:pointer;
  }
  .asset-card:hover { transform: translateY(-4px); box-shadow: 0 16px 40px rgba(2,6,23,0.09); }

  .asset-icon {
    width:48px; height:48px; border-radius:50%; display:flex; align-items:center; justify-content:center;
    background: linear-gradient(180deg, rgba(0,0,0,0.03), rgba(0,0,0,0.01));
    box-shadow: 0 6px 16px rgba(2,6,23,0.06); color:#111; font-size:18px; flex-shrink:0;
  }

  .asset-info { flex:1; min-width:0; }
  .asset-info h6 { margin:0; font-size:14px; font-weight:800; color:var(--text); white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
  .asset-info p { margin:4px 0 0; color:var(--muted); font-size:13px; line-height:1.1; }
  .asset-meta { font-size:12px; color:var(--muted); margin-top:4px; }

  .asset-status { display:flex; flex-direction:column; gap:6px; align-items:flex-end; flex-shrink:0; }
  .asset-status i { font-size:16px; color:var(--muted); }
  .asset-status .signal { color:#22c55e; }
  .asset-status .power { color:#ef4444; }
  .asset-status .battery { color:#f59e0b; }

  /* Map area */
  .map-area { flex:1; border-radius:12px; overflow:hidden; position:relative; background:var(--bg); border:1px solid rgba(15,23,42,0.04); }
  #trackingMap { height:100%; width:100%; }

  /* Expand button (ONLY visible when panel is collapsed) */
  #expandBtn {
    position:absolute;
    top:18px;
    left:18px;
    z-index:9999;                     /* very high so it's on top of map controls */
    padding:8px 12px;
    border-radius:8px;
    background: linear-gradient(90deg,var(--accent-light),var(--accent));
    color:#fff; border:none;
    box-shadow: 0 8px 22px rgba(37,99,235,0.12);
    cursor:pointer;
    display:none;                     /* default hidden; shown only when collapsed */
    align-items:center;
    gap:8px;
  }

  /* Accent-driven helper classes (not strictly required, kept for compat) */
  .accent-left { border-left-color: var(--accent); }
  .accent-gradient { background: linear-gradient(90deg,var(--accent-light),var(--accent)); color:#fff; }

  /* Dark tweaks */
  body.theme-dark .assets-panel { border:1px solid rgba(255,255,255,0.04); }
  body.theme-dark .asset-card { background: var(--card); box-shadow: none; border-left-color: transparent; }
  body.theme-dark .asset-icon { box-shadow: 0 6px 16px rgba(0,0,0,0.2); background: rgba(255,255,255,0.03); color: var(--text); }
  body.theme-dark .asset-card:hover { box-shadow: var(--shadow); }

  /* Responsive */
  @media (max-width:900px){
    .assets-panel { display:none; } /* optional: mobile UI may differ */
    #expandBtn { display:block; left:12px; top:12px; }
  }
</style>

    <!-- PAGE HEADING (same as Settings & Dashboard) -->
<div class="page-heading" style="display:flex;align-items:center;gap:14px;margin-bottom:18px;">
    <div class="heading-accent"
         style="width:6px;height:48px;border-radius:4px;
         background:linear-gradient(180deg,var(--accent-light),var(--accent));
         flex-shrink:0;"></div>

    <div>
        <h2 style="margin:0;font-size:26px;font-weight:800;color:var(--text);">
            Tracking Map
        </h2>
        <div style="margin-top:0px;font-size:13px;color:var(--muted);">
            Live tracking & asset overview
        </div>
    </div>
</div>


<!-- Page content -->
<div class="device-status-bar">
  <button class="device-filter active"><i class="fa-solid fa-globe"></i> All Devices <span class="count">3</span></button>
  <button class="device-filter"><i class="fa-solid fa-signal"></i> Online <span class="count">1</span></button>
  <button class="device-filter"><i class="fa-solid fa-power-off"></i> Offline <span class="count">2</span></button>
</div>

<div class="tracking-container" id="trackingContainer">
  <!-- Assets panel -->
  <div class="assets-panel" id="assetsPanel" role="region" aria-label="Assets list">
    <div class="assets-header">
      <div class="left">
        <h5>Assets</h5>
        <p>Showing all devices</p>
      </div>

      <div class="assets-controls">
        <button class="btn-icon search" title="Search"><i class="fa-solid fa-magnifying-glass"></i></button>
        <button class="btn-icon download" title="Export"><i class="fa-solid fa-download"></i></button>
        <button id="collapseBtn" class="btn-icon" title="Hide asset list"><i class="fa-solid fa-angle-left"></i></button>
      </div>
    </div>

    <div class="assets-body" id="assetsBody">
      <!-- Sample assets (repeat the markup for real data) -->
      <div class="asset-card" data-lat="19.0760" data-lng="72.8777" data-status="online">
        <div class="asset-icon"><i class="fa-solid fa-truck"></i></div>
        <div class="asset-info">
          <h6>863921037994129</h6>
          <p>ID: 863921037994129</p>
          <div class="asset-meta">~ Just now</div>
        </div>
        <div class="asset-status">
          <i class="fa-solid fa-power-off power" title="Power"></i>
          <i class="fa-solid fa-signal signal" title="Signal"></i>
        </div>
      </div>

      <div class="asset-card" data-lat="19.1900" data-lng="73.0150" data-status="offline">
        <div class="asset-icon"><i class="fa-solid fa-truck"></i></div>
        <div class="asset-info">
          <h6>866344053880816</h6>
          <p>ID: 866344053880816</p>
          <div class="asset-meta">~ 19 minutes ago</div>
        </div>
        <div class="asset-status">
          <i class="fa-solid fa-power-off power" title="Power"></i>
          <i class="fa-solid fa-signal signal" title="Signal"></i>
        </div>
      </div>

      <div class="asset-card" data-lat="19.00" data-lng="73.20" data-status="offline">
        <div class="asset-icon"><i class="fa-solid fa-truck"></i></div>
        <div class="asset-info">
          <h6>180718916</h6>
          <p>ID: 180718916</p>
          <div class="asset-meta">~ 3 days ago</div>
        </div>
        <div class="asset-status">
          <i class="fa-solid fa-power-off power" title="Power"></i>
          <i class="fa-solid fa-signal signal" title="Signal"></i>
        </div>
      </div>
    </div>
  </div>

  <!-- Map area -->
  <div class="map-area" id="mapArea">
    <!-- Expand button is ONLY shown when panel collapsed (A1) -->
    <button id="expandBtn" aria-controls="assetsPanel" aria-expanded="false"><i class="fa-solid fa-list"></i> View Asset List</button>
    <div id="trackingMap"></div>
  </div>
</div>

<!-- Leaflet -->
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

<script>
 

        // ====== Map init ======
        const map = L.map('trackingMap', {
            center: [19.0760, 72.8777],
            zoom: 8,
            zoomControl: false,
            scrollWheelZoom: false
        });

        map.on('focus', () => map.scrollWheelZoom.enable());
        map.on('blur', () => map.scrollWheelZoom.disable());

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { maxZoom: 18 }).addTo(map);

        // ====== Assets -> markers ======
        const assetNodes = document.querySelectorAll('.asset-card');
        const markers = [];

        function getAccent() {
            return getComputedStyle(document.documentElement).getPropertyValue('--accent').trim() || '#2563eb';
        }

        function colorForStatus(status) {
            if (status === 'online') return { left: getAccent(), iconBgGradient: `linear-gradient(180deg, ${getComputedStyle(document.documentElement).getPropertyValue('--accent-light').trim()}, ${getAccent()})`, iconColor: '#fff' };
            if (status === 'offline') return { left: '#ef4444', iconBgGradient: 'linear-gradient(180deg,#fee2e2,#fef3f2)', iconColor: '#7f1d1d' };
            return { left: '#f59e0b', iconBgGradient: 'linear-gradient(180deg,#fff7ed,#fff1d6)', iconColor: '#713f12' };
        }

        assetNodes.forEach(node => {
            const lat = parseFloat(node.dataset.lat);
            const lng = parseFloat(node.dataset.lng);
            const label = node.querySelector('h6') ? node.querySelector('h6').textContent.trim() : 'Asset';
            const status = node.dataset.status || 'offline';
            const color = colorForStatus(status);

            // style card left border
            node.style.borderLeftColor = color.left;

            // style icon bubble
            const icon = node.querySelector('.asset-icon');
            if (icon) {
                icon.style.background = color.iconBgGradient || color.iconBgGradient;
                icon.style.color = color.iconColor || '#111';
            }

            // add marker
            const marker = L.circleMarker([lat, lng], {
                color: (status === 'online' ? getAccent() : '#ef4444'),
                radius: 7,
                fillOpacity: 0.9
            }).addTo(map).bindPopup(`<b>${label}</b>`);

            markers.push(marker);

            // clicking card centers map
            node.addEventListener('click', () => {
                map.setView([lat, lng], 13, { animate: true });
                marker.openPopup();
            });
        });

        if (markers.length) {
            const group = L.featureGroup(markers);
            map.fitBounds(group.getBounds().pad(0.35));
        }

        // ====== Panel collapse/expand (A1 behavior) ======
        const panel = document.getElementById('assetsPanel');
        const collapseBtn = document.getElementById('collapseBtn');
        const expandBtn = document.getElementById('expandBtn');

        function savePanelState(state) { localStorage.setItem('assetsPanelState', state); }
        function loadPanelState() {
            const state = localStorage.getItem('assetsPanelState') || 'expanded';
            if (state === 'collapsed') {
                panel.classList.add('collapsed');
                expandBtn.style.display = 'flex';          // show expand button only when collapsed (A1)
                expandBtn.setAttribute('aria-expanded', 'false');
            } else {
                panel.classList.remove('collapsed');
                expandBtn.style.display = 'none';          // hide when expanded
                expandBtn.setAttribute('aria-expanded', 'true');
            }
            // ensure map recalculation after transition
            setTimeout(() => map.invalidateSize(), 320);
        }

        loadPanelState();

        collapseBtn.addEventListener('click', function (e) {
            e.preventDefault();
            panel.classList.add('collapsed');
            expandBtn.style.display = 'flex';            // show expand button after collapse
            expandBtn.setAttribute('aria-expanded', 'false');
            savePanelState('collapsed');
            setTimeout(() => map.invalidateSize(), 320);
        });

        expandBtn.addEventListener('click', function () {
            panel.classList.remove('collapsed');
            expandBtn.style.display = 'none';            // hide button after expanding (A1)
            expandBtn.setAttribute('aria-expanded', 'true');
            savePanelState('expanded');
            setTimeout(() => map.invalidateSize(), 320);
        });

        // Re-apply accent visuals on storage change (live update)
        window.addEventListener('storage', function (e) {
            if (e.key === ACCENT_KEY) {
                // update card borders/icons for online assets
                const accentName = e.newValue || 'blue';
                const preset = PRESETS[accentName] || PRESETS.blue;
                document.querySelectorAll('.asset-card').forEach(card => {
                    if (card.dataset.status === 'online') card.style.borderLeftColor = preset.accent;
                    const icon = card.querySelector('.asset-icon');
                    if (card.dataset.status === 'online' && icon) {
                        icon.style.background = `linear-gradient(180deg, ${preset.accentLight}, ${preset.accent})`;
                        icon.style.color = '#fff';
                    }
                });
                document.querySelectorAll('#expandBtn').forEach(b => {
                    b.style.background = `linear-gradient(90deg, ${preset.accentLight}, ${preset.accent})`;
                });
            }

            if (e.key === THEME_KEY) {
                document.body.classList.toggle('theme-dark', e.newValue === 'true');
            }
        });

        // Ensure map invalidates size when tab is visible again
        document.addEventListener('visibilitychange', () => {
            if (!document.hidden) setTimeout(() => map.invalidateSize(), 200);
        });
  
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
