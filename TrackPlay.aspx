<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Dashboard.master"
    AutoEventWireup="true" CodeFile="TrackPlay.aspx.cs" Inherits="TrackPlay" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<!-- =========================
     TRACKPLAY (Option A - Routeye style + Sliding Filter)
========================= -->

<style>

/* ===========================================
   ACCENT LIVE THEME VARIABLES (new)
=========================================== */
:root {
    --tp-accent: var(--accent) !important;
    --tp-accent-dark: var(--accent-dark) !important;
    --tp-blue: var(--accent) !important;
    --tp-blue-dark: var(--accent-dark) !important;
}



/* Select devices button — NOW ACCENTED */
#selectDevicesBtn {
    display:inline-flex;
    align-items:center;
    gap:8px;
    background: linear-gradient(90deg, var(--accent), var(--accent-light));
    color:#fff;
    padding:10px 14px;
    border-radius:8px;
    border:none;
    cursor:pointer;
    font-weight:700;
    box-shadow:0 6px 18px rgba(0,0,0,0.15);
}

/* Global accent bindings */
#selectDevicesBtn {
    background: linear-gradient(90deg, var(--accent), var(--accent-light)) !important;
    color:#fff !important;
}

#btnLoad {
    background: linear-gradient(90deg, var(--accent), var(--accent-light)) !important;
    color:#fff !important;
}

.play-btn {
    background: linear-gradient(135deg, var(--accent-dark), var(--accent)) !important;
}

.detail-title {
    color: var(--accent) !important;
}

.player-progress {
    background: linear-gradient(90deg, var(--accent), var(--accent-light)) !important;
}

.player-handle {
    background: var(--accent) !important;
}

/* Remove TrackPlay's old blue system */


/* Fix Map Polyline */
.leaflet-interactive {
    stroke: var(--accent) !important;
}

/* Fix Start / End Markers */
.marker-start {
    background: var(--accent) !important;
}
.marker-end {
    background: var(--accent-dark) !important;
}

/* Details Button */
#detailsToggleBtn {
    background: var(--accent) !important;
}
#detailsToggleBtn:hover {
    background: var(--accent-dark) !important;
}








/* Map polyline accent */
.leaflet-interactive {
    stroke: var(--accent) !important;
    fill: var(--accent) !important;
}


/* Page wrapper */
.tp-wrapper {
   
    box-sizing: border-box;
    background: var(--tp-bg);
}

/* Select devices small button */
#selectDevicesBtn {
    display:inline-flex;
    align-items:center;
    gap:8px;
    background: linear-gradient(90deg,var(--tp-blue), #38bdf8);
    color:#fff;
    padding:10px 14px;
    border-radius:8px;
    border:none;
    cursor:pointer;
    font-weight:700;
    box-shadow:0 6px 18px rgba(37,99,235,0.18);
}

/* Sliding filter panel */
.filter-wrap {
    overflow: hidden;
    transition: max-height 300ms cubic-bezier(.2,.9,.3,1), opacity 200ms ease, transform 220ms ease;
    max-height: 0;
    opacity: 0;
    transform: translateY(-6px);
    margin-bottom: 12px;
}

.filter-wrap.open {
    max-height: 420px;
    opacity: 1;
    transform: translateY(0);
}

/* Filter card */
.tp-card {
    background: #fff;
    border-radius: 10px;
    padding: 14px;
    display:flex;
    gap:12px;
    align-items:center;
    box-shadow: 0 6px 20px rgba(16,24,40,0.06);
    flex-wrap:wrap;
    position:relative;
}

/* Close X */
#filterCloseBtn {
    position:absolute;
    right:12px;
    top:12px;
    background:transparent;
    border:none;
    color:#475569;
    font-size:18px;
    cursor:pointer;
    padding:6px;
    border-radius:6px;
}
#filterCloseBtn:hover { background:#f1f5f9; }

/* Fields */
.tp-card .field { display:flex; flex-direction:column; gap:6px; min-width:160px; }
.tp-card label { font-weight:600; color:#374151; font-size:13px; }

input[type="datetime-local"], select, .tp-input {
    padding:9px 12px;
    border-radius:8px;
    border:1px solid #d1d5db;
    background:#fff;
    min-width:160px;
    font-size:14px;
}

/* MAP */
#tp-map {
    width:100%;
    height:560px;
    border-radius:10px;
    overflow:hidden;
    box-shadow: var(--tp-shadow-lg);
    position:relative;
}

/* Floating Playback Controller */
.tp-floating-player {
    position:absolute;
    bottom:20px;
    left:20px;
    z-index:9999;
    background:#fff;
    border-radius:50px;
    display:flex;
    align-items:center;
    gap:14px;
    box-shadow: 0 10px 25px rgba(0,0,0,0.18);
    border:1px solid #e6eef9;
    transition: transform 160ms ease, opacity 160ms ease;
}
.tp-floating-player.hidden {
    opacity: 0;
    transform: translateY(8px) scale(.98);
    pointer-events: none;
}

/* Playback Buttons */
.play-btn {
    width:46px; height:46px;
    border-radius:50%;
    border:none;
    color:#fff;
    font-size:18px;
    display:flex;
    align-items:center;
    justify-content:center;
    cursor:pointer;
    background: linear-gradient(135deg,#1d4ed8,#2563eb,#3b82f6);
    box-shadow:0 8px 20px rgba(29,78,216,0.18);
}

/* Speed Controls */
.player-controls { display:flex; flex-direction:column; gap:6px; min-width:160px; }
.player-timeline {
    width:260px; height:8px;
    background:#eef4ff;
    border-radius:6px;
    position:relative;
    cursor:pointer;
}
.player-progress {
    height:100%; width:0%;
    background: linear-gradient(90deg,var(--tp-accent),var(--tp-accent-dark));
    border-radius:6px;
}
.player-handle {
    position:absolute;
    top:50%;
    transform:translate(-50%,-50%);
    left:0%;
    width:14px; height:14px;
    border-radius:50%;
    background:var(--tp-accent);
    box-shadow:0 6px 18px rgba(56,189,248,0.22);
}

/* DETAILS TOGGLE BUTTON */
#detailsToggleBtn {
    position: absolute;
    right: 20px;
    bottom: 20px;
    z-index: 9999;
    background: #2563eb;
    color: #fff;
    padding: 10px 18px;
    border-radius: 8px;
    box-shadow: 0 8px 20px rgba(37,99,235,0.35);
    font-weight: 700;
    cursor:pointer;
}

/* ======================================================
   ROUTEYE ULTRA COMPACT CARD DESIGN (Embedded as asked)
   ====================================================== */
.tp-details {
    margin-top: 14px;
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 12px;

    /* Needed for hide/show functionality */
    max-height: 1000px;
    opacity: 1;
    overflow: hidden;
    transition: max-height 300ms cubic-bezier(.2,.9,.3,1), opacity 200ms ease;
}

.tp-details.collapsed {
    max-height: 0;
    opacity: 0;
    pointer-events: none;
}

/* Clean compact card */
.detail-card {
    background: #ffffff;
    border-radius: 12px;
    padding: 14px 16px;
    border: 1px solid #e7ecf5;
    box-shadow: 0 4px 12px rgba(15,23,42,0.06);
    transition: 0.2s ease;
}

/* Hover lift */
.detail-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 20px rgba(15,23,42,0.12);
}

/* Title */
.detail-title {
    font-size: 15px;
    font-weight: 700;
    color: #2563eb;
    margin-bottom: 6px;
    padding-bottom: 6px;
    border-bottom: 1px solid #e5e7eb;
}

/* Rows */
.detail-row {
    display: flex;
    justify-content: space-between;
    font-size: 13px;
    padding: 6px 0;
    color: #1e293b;
    border-bottom: 1px dashed #eef1f6;
}
.detail-row:last-child { border-bottom:none; }
.detail-row div:first-child { font-weight:600; color:#475569; }
.detail-row div:last-child { font-weight:500; color:#0f172a; }

/* Mobile */
@media (max-width:800px){
    .tp-details { grid-template-columns:1fr; }
}

/* Details-toggle (bottom right inside map) */
#detailsToggleBtn {
    position: absolute;
    right: 20px;
    bottom: 20px;
    z-index: 9999;
    background: #2563eb;
    color: #fff;
    padding: 10px 18px;
    border-radius: 8px;
    box-shadow: 0 8px 20px rgba(37,99,235,0.35);
    font-weight: 700;
    cursor: pointer;
    user-select: none;
    transition: 0.2s ease;
}
#detailsToggleBtn:hover {
    background: #1e4fd1;
}

#tp-map {
    position: relative;
}


/* collapsed details panel - animate height */
.tp-details {
    margin-top:14px;
    display:grid;
    grid-template-columns:repeat(3,1fr);
    gap:14px;
    transition: max-height 300ms cubic-bezier(.2,.9,.3,1), opacity 200ms ease;
    overflow:hidden;
}
.tp-details.collapsed {
    max-height: 0;
    opacity: 0;
    pointer-events: none;
}

/* detail cards */
.detail-card {
    background:#fff; padding:12px; border-radius:10px; border:1px solid #e6eef9;
    box-shadow:0 6px 18px rgba(6,12,30,0.04);
}
.detail-title { font-size:16px; font-weight:700; color:var(--tp-accent); margin-bottom:8px; }
.detail-row { display:flex; justify-content:space-between; padding:8px 0; border-bottom:1px dashed #f1f5f9; color:#334155; }
.detail-row:last-child { border-bottom:none; }

/* ============================================================
   DARK MODE ADAPTATION FOR TRACKPLAY PAGE
   Fully syncs with Dashboard.theme-dark variables
============================================================ */

body.theme-dark .tp-wrapper {
    background: var(--bg);
}

/* --- Sliding Filter Panel --- */
body.theme-dark .tp-card {
    background: var(--card);
    box-shadow: var(--shadow-sm);
    border-color: rgba(255,255,255,0.06);
}

body.theme-dark #filterCloseBtn {
    color: var(--muted);
}
body.theme-dark #filterCloseBtn:hover {
    background: rgba(255,255,255,0.06);
}

/* Input fields & dropdowns */
body.theme-dark input[type="datetime-local"],
body.theme-dark select,
body.theme-dark .tp-input {
    background: var(--card);
    border: 1px solid rgba(255,255,255,0.12);
    color: var(--text);
}

/* Label text */
body.theme-dark label {
    color: var(--text);
}

/* --- "Select Devices" button stays same (gradient) --- */

/* --- MAP CONTAINER --- */
body.theme-dark #tp-map {
    box-shadow: var(--shadow-md);
    background: var(--card);
}

/* Leaflet popup & markers */
body.theme-dark .leaflet-popup-content-wrapper,
body.theme-dark .leaflet-popup-tip {
    background: var(--card);
    color: var(--text);
    box-shadow: var(--shadow-md);
}
body.theme-dark .leaflet-control-zoom a {
    background: var(--card) !important;
    color: var(--text) !important;
}

/* --- Floating Playback Panel --- */
body.theme-dark .tp-floating-player {
    background: var(--card);
    border-color: rgba(255,255,255,0.08);
    box-shadow: var(--shadow-sm);
}

body.theme-dark .player-timeline {
    background: rgba(255,255,255,0.06);
}
body.theme-dark .player-progress {
    background: linear-gradient(90deg, var(--primary), var(--primary-2));
}
body.theme-dark .player-handle {
    background: var(--primary);
}

/* Text inside floating player */
body.theme-dark .tp-floating-player div,
body.theme-dark #speedValue {
    color: var(--text) !important;
}

/* --- Details Panel (bottom cards) --- */
body.theme-dark .detail-card {
    background: var(--card);
    border: 1px solid rgba(255,255,255,0.06);
    box-shadow: var(--shadow-sm);
}

body.theme-dark .detail-title {
    color: var(--primary);
    border-color: rgba(255,255,255,0.08);
}

body.theme-dark .detail-row {
    border-color: rgba(255,255,255,0.06);
    color: var(--text) !important;
}
body.theme-dark .detail-row div:first-child {
    color: var(--muted);
}
body.theme-dark .detail-row div:last-child {
    color: var(--text);
}

/* --- "Hide Details" button --- */
body.theme-dark #detailsToggleBtn {
    background: var(--primary-2);
    color: #fff;
}
body.theme-dark #detailsToggleBtn:hover {
    background: var(--primary);
}

/* --- Filter Panel Search Box --- */
body.theme-dark #searchAssets {
    background: var(--card);
    border: 1px solid rgba(255,255,255,0.12);
    color: var(--text);
}

/* --- Speed slider track (fallback) --- */
body.theme-dark input[type="range"]::-webkit-slider-runnable-track {
    background: rgba(255,255,255,0.1);
}


/* Responsive */
@media (max-width:1100px) {
    #tp-map { height:480px; }
    .tp-details { grid-template-columns:1fr; }
}
@media (max-width:680px) {
    .tp-card { flex-direction:column; align-items:stretch; }
    .tp-floating-player { left:12px; right:12px; bottom:12px; width:calc(100% - 24px); justify-content:space-between; }
    .player-controls { min-width:auto; width:100%; }
    .player-timeline { width:100%; }
    #detailsToggleBtn { right:12px; bottom:12px; }
}

</style>

    <!-- PAGE HEADING (Standard Across All Pages) -->
<div class="page-heading" style="
    display:flex;
    align-items:center;
    gap:14px;
    margin-bottom:18px;
">
    <div class="heading-accent"
         style="width:6px;height:48px;border-radius:4px;
         background:linear-gradient(180deg,var(--accent-light),var(--accent));
         flex-shrink:0;"></div>

    <div>
        <h2 style="margin:0;font-size:26px;font-weight:800;color:var(--text);">
            Track Playback
        </h2>
        <div style="margin-top:0px;font-size:13px;color:var(--muted);">
            Replay historical routes & movement
        </div>
    </div>
</div>


<div class="tp-wrapper">

    <!-- top row: Select devices button (initial) -->
    <div style="display:flex; align-items:center; gap:12px; margin-bottom:8px;">
        <button id="selectDevicesBtn" type="button" aria-expanded="false">Select devices ▾</button>
        <!-- optionally you can show a breadcrumb or title here -->
        <div style="font-weight:700; color:#0f172a;">Track Playback</div>
    </div>

    <!-- Sliding filter panel START -->
    <div class="filter-wrap" id="filterWrap" aria-hidden="true">
        <div class="tp-card" role="region" aria-label="Filter panel">

            <!-- close X -->
            <button id="filterCloseBtn" type="button" aria-label="Close filters">✕</button>

            <div class="field">
                <label>From</label>
                <input id="fromDate" type="datetime-local" />
            </div>

            <div class="field">
                <label>To</label>
                <input id="toDate" type="datetime-local" />
            </div>

            <div class="field">
                <label>Account</label>
                <select id="selectAccount">
                    <option>IMZ DEMO</option>
                    <option>Account 2</option>
                </select>
            </div>

            <div class="field">
                <label>Sub-account</label>
                <select id="selectSubAccount">
                    <option>Sub A</option>
                    <option>Sub B</option>
                </select>
            </div>

            <div class="field">
                <label>Asset (IMEI)</label>
                <select id="selectAsset">
                    <option value="">Select asset</option>
                    <option value="866344053880816">866344053880816</option>
                    <option value="863921037994129">863921037994129</option>
                </select>
            </div>

            <div style="margin-left:auto; display:flex; gap:10px; align-items:flex-end;">
                <div style="display:flex;flex-direction:column;">
                    <label style="font-weight:600;color:#374151;font-size:13px;">Search</label>
                    <input id="searchAssets" class="tp-input" placeholder="Search assets" />
                </div>

                <div style="display:flex;align-items:flex-end;">
                    <button id="btnLoad" type="button" style="padding:10px 14px;border-radius:8px;border:none;background:linear-gradient(90deg,#2563eb,#38bdf8);color:#fff;font-weight:700;cursor:pointer;">Load Track</button>
                </div>
            </div>
        </div>
    </div>
    <!-- Sliding filter panel END -->

    <!-- Map -->
    <div id="tp-map">
    <div id="detailsToggleBtn">Hide Details ⮟</div>
</div>

    <!-- Bottom details -->
    <div class="tp-details" id="detailsPanel" aria-hidden="false">
        <div class="detail-card">
            <div class="detail-title">Asset Details</div>
            <div class="detail-row"><div>Vehicle No.</div><div>N/A</div></div>
            <div class="detail-row"><div>IMEI</div><div id="det-imei">—</div></div>
            <div class="detail-row"><div>Satellites</div><div id="det-sat">—</div></div>
            <div class="detail-row"><div>Operator</div><div id="det-op">—</div></div>
        </div>

        <div class="detail-card">
            <div class="detail-title">Asset Location</div>
            <div class="detail-row"><div>Lat</div><div id="det-lat">—</div></div>
            <div class="detail-row"><div>Long</div><div id="det-lng">—</div></div>
            <div class="detail-row"><div>Altitude</div><div id="det-alt">—</div></div>
            <div class="detail-row"><div>Time</div><div id="det-time">—</div></div>
        </div>

        <div class="detail-card">
            <div class="detail-title">Status</div>
            <div class="detail-row"><div>Engine</div><div id="det-engine">—</div></div>
            <div class="detail-row"><div>GPS</div><div id="det-gps">—</div></div>
            <div class="detail-row"><div>Motion</div><div id="det-motion">—</div></div>
            <div class="detail-row"><div>Speed</div><div id="det-speed">—</div></div>
        </div>
    </div>

</div>

<!-- Leaflet -->
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

<!-- Script: UI toggles + playback logic -->
<script>
    (function () {
        /* ---------------- demo data (replace with API) ---------------- */
        const demoTracks = {
            "866344053880816": [
                [19.082, 72.741, '2025-11-12 10:00:00'],
                [19.09, 72.75, '2025-11-12 10:12:00'],
                [19.10, 72.77, '2025-11-12 10:24:00'],
                [19.12, 72.79, '2025-11-12 10:35:00'],
                [19.15, 72.81, '2025-11-12 10:50:00']
            ],
            "863921037994129": [
                [19.08, 72.86, '2025-11-11 09:00:00'],
                [19.07, 72.87, '2025-11-11 09:15:00'],
                [19.06, 72.88, '2025-11-11 09:30:00']
            ]
        };

        /* ---------------- init map ---------------- */
        // initialize map WITHOUT zoom controls
        const map = L.map('tp-map', { zoomControl: false }).setView([19.07, 72.88], 11);

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 19
        }).addTo(map);

// ❌ remove this to hide zoom buttons
// L.control.zoom({ position: 'bottomright' }).addTo(map);


        /* ---------- floating player markup (insert into map) ---------- */
        const mapEl = document.getElementById('tp-map');
        const floatingHtml = `
        <div class="tp-floating-player hidden" id="floatingPlayer" role="region" aria-label="Playback controls">
            
            <button class="play-btn" id="playPause" type="button" title="Play/Pause">▶</button>
           

            <div class="player-controls" style="margin-left:6px;">
                <div style="display:flex;align-items:center;gap:15px;">
                    <div style="font-size:13px;color:#374151;font-weight:600;">Playback Speed</div>
                    <div id="speedValue" style="font-weight:700;color:#2563eb;">×3</div>
                </div>
                <div style="display:flex;align-items:center;gap:10px;margin-top:6px;">
                    <input id="speedSlider" type="range" min="1" max="8" value="3" style="width:110px" aria-label="speed" />
                    <div style="flex:1"></div>
                </div>

            </div>
        </div>
    `;
        mapEl.insertAdjacentHTML('beforeend', floatingHtml);

        /* ---------- references ---------- */
        const selectDevicesBtn = document.getElementById('selectDevicesBtn');
        const filterWrap = document.getElementById('filterWrap');
        const filterCloseBtn = document.getElementById('filterCloseBtn');

        const detailsToggleBtn = document.getElementById('detailsToggleBtn');
        const detailsPanel = document.getElementById('detailsPanel');

        const playBtn = document.getElementById('playPause');
        const stepBack = document.getElementById('stepBack');
        const stepForward = document.getElementById('stepForward');
        const speedSlider = document.getElementById('speedSlider');
        const speedValue = document.getElementById('speedValue');

        const playerProgress = document.getElementById('playerProgress');
        const playerHandle = document.getElementById('playerHandle');
        const playerTimeline = document.getElementById('playerTimeline');
        const timeStart = document.getElementById('timeStart');
        const timeNow = document.getElementById('timeNow');
        const timeEnd = document.getElementById('timeEnd');

        const selectAsset = document.getElementById('selectAsset');
        const btnLoad = document.getElementById('btnLoad');

        /* ---------- state ---------- */
        let filterOpen = false;
        let detailsVisible = true;

        let currentTrack = [];
        let polyline = null, marker = null, startMarker = null, endMarker = null;
        let playing = false;
        let progress = 0;
        let animFrame = null;
        const baseDuration = 8000;
        let lastNow = null;

        /* ---------- safe UI helpers ---------- */
        function openFilter() {
            filterWrap.classList.add('open');
            filterWrap.setAttribute('aria-hidden', 'false');
            selectDevicesBtn.setAttribute('aria-expanded', 'true');
            selectDevicesBtn.style.display = 'none';
            filterOpen = true;
        }
        function closeFilter() {
            filterWrap.classList.remove('open');
            filterWrap.setAttribute('aria-hidden', 'true');
            selectDevicesBtn.setAttribute('aria-expanded', 'false');
            selectDevicesBtn.style.display = 'inline-flex';
            filterOpen = false;
        }

        /* when user clicks the floating "Select devices" button */
        selectDevicesBtn.addEventListener('click', function (e) {
            openFilter();
        });

        /* close X inside panel */
        filterCloseBtn.addEventListener('click', function (e) {
            closeFilter();
        });

        /* pressing Escape also closes panel for usability */
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') {
                if (filterOpen) closeFilter();
            }
        });

        /* ---------- details panel toggle (no reload) ---------- */
        detailsToggleBtn.addEventListener('click', function (e) {
            detailsVisible = !detailsVisible;
            if (detailsVisible) {
                detailsPanel.classList.remove('collapsed');
                detailsPanel.setAttribute('aria-hidden', 'false');
                detailsToggleBtn.innerText = 'Hide Details ⮟';
                detailsToggleBtn.setAttribute('aria-pressed', 'false');
            } else {
                detailsPanel.classList.add('collapsed');
                detailsPanel.setAttribute('aria-hidden', 'true');
                detailsToggleBtn.innerText = 'View Details ⮝';
                detailsToggleBtn.setAttribute('aria-pressed', 'true');
            }
        });

        /* ---------- map playback logic (smooth) ---------- */
        function clearMapLayers() {
            if (polyline) { map.removeLayer(polyline); polyline = null; }
            if (marker) { map.removeLayer(marker); marker = null; }
            if (startMarker) { map.removeLayer(startMarker); startMarker = null; }
            if (endMarker) { map.removeLayer(endMarker); endMarker = null; }
        }

        function setProgress(t) {
            if (!currentTrack || currentTrack.length === 0) return;
            t = Math.max(0, Math.min(1, t));
            progress = t;
            const pct = (t * 100) + '%';
            if (playerProgress) playerProgress.style.width = pct;
            if (playerHandle) playerHandle.style.left = pct;

            const n = currentTrack.length;
            if (n < 1) return;
            const totalSeg = n - 1;
            const idxFloat = t * totalSeg;
            const i = Math.floor(idxFloat);
            const frac = idxFloat - i;
            const a = currentTrack[i];
            const b = currentTrack[Math.min(i + 1, totalSeg)];
            const lat = a[0] + (b[0] - a[0]) * frac;
            const lng = a[1] + (b[1] - a[1]) * frac;
            const timeText = (frac < 0.5 ? a[2] : b[2]);

            if (marker) marker.setLatLng([lat, lng]);
            const latEl = document.getElementById('det-lat');
            const lngEl = document.getElementById('det-lng');
            const timeEl = document.getElementById('det-time');
            if (latEl) latEl.innerText = lat.toFixed(6);
            if (lngEl) lngEl.innerText = lng.toFixed(6);
            if (timeEl) timeEl.innerText = timeText;
            if (timeNow) timeNow.innerText = timeText;

            if (marker) map.panTo([lat, lng], { animate: true, duration: 0.6 });
        }

        function animatePlayback() {
            if (!playing) return;
            const now = performance.now();
            if (!lastNow) lastNow = now;
            const elapsed = now - lastNow;
            lastNow = now;

            const speed = Number(speedSlider.value) || 1;
            const totalMs = baseDuration / speed;
            const delta = elapsed / totalMs;
            setProgress(progress + delta);

            if (progress >= 1) {
                setProgress(1);
                playing = false;
                updatePlayUI();
                return;
            }
            animFrame = requestAnimationFrame(animatePlayback);
        }

        function updatePlayUI() {
            playBtn.innerText = playing ? '❚❚' : '▶';
        }

        playBtn.addEventListener('click', function () {
            if (!currentTrack || currentTrack.length < 2) return;
            playing = !playing;
            if (playing) {
                lastNow = performance.now();
                animFrame = requestAnimationFrame(animatePlayback);
            } else {
                if (animFrame) cancelAnimationFrame(animFrame);
                animFrame = null;
                lastNow = null;
            }
            updatePlayUI();
        });

        stepForward.addEventListener('click', function () {
            if (!currentTrack || currentTrack.length < 2) return;
            const seg = 1 / (currentTrack.length - 1);
            setProgress(progress + seg);
            playing = false; updatePlayUI();
        });

        stepBack.addEventListener('click', function () {
            if (!currentTrack || currentTrack.length < 2) return;
            const seg = 1 / (currentTrack.length - 1);
            setProgress(progress - seg);
            playing = false; updatePlayUI();
        });

        function updateSpeedLabel() { if (speedValue) speedValue.innerText = '×' + speedSlider.value; }
        speedSlider.addEventListener('input', function () { updateSpeedLabel(); });
        updateSpeedLabel();

        /* timeline interactions (click + drag) */
        (function attachTimeline() {
            let dragging = false;
            if (!playerTimeline) return;
            playerTimeline.addEventListener('pointerdown', function (e) {
                dragging = true;
                playerTimeline.setPointerCapture(e.pointerId);
                handlePointer(e);
                playing = false; updatePlayUI();
            });
            window.addEventListener('pointermove', function (e) {
                if (!dragging) return;
                handlePointer(e);
            });
            window.addEventListener('pointerup', function (e) {
                if (dragging) {
                    dragging = false;
                    try { playerTimeline.releasePointerCapture(e.pointerId); } catch (ex) { }
                }
            });
            function handlePointer(e) {
                const rect = playerTimeline.getBoundingClientRect();
                const x = Math.max(0, Math.min(rect.width, e.clientX - rect.left));
                const t = x / rect.width;
                setProgress(t);
            }
        })();

        if (playerHandle) {
            playerHandle.addEventListener('pointerdown', function (e) {
                playerHandle.setPointerCapture(e.pointerId);
                const evt = new PointerEvent('pointerdown', { clientX: e.clientX, clientY: e.clientY, pointerId: e.pointerId });
                playerTimeline.dispatchEvent(evt);
            });
        }

        /* load track */
        function loadTrack(imei) {
            if (!demoTracks[imei]) { alert('No demo track available for selected asset.'); return; }
            clearMapLayers();
            currentTrack = demoTracks[imei].slice();

            const latlngs = currentTrack.map(p => [p[0], p[1]]);
            polyline = L.polyline(latlngs, {
                color: getComputedStyle(document.documentElement).getPropertyValue("--accent").trim(),
                weight: 4,
                opacity: 0.95
            }).addTo(map);

            startMarker = L.circleMarker(latlngs[0], {
                radius: 6,
                fillColor: getComputedStyle(document.documentElement).getPropertyValue("--accent").trim(),
                color: "#fff",
                weight: 2
            });

            endMarker = L.circleMarker(latlngs[last], {
                radius: 6,
                fillColor: getComputedStyle(document.documentElement).getPropertyValue("--accent-dark").trim(),
                color: "#fff",
                weight: 2
            });


            marker = L.marker(latlngs[0], {
                icon: L.divIcon({
                    className: '',
                    html: `<div style="width:14px;height:14px;border-radius:50%;
                background:var(--accent);
                border:3px solid #fff;"></div>`
                })
            });


            map.fitBounds(polyline.getBounds().pad(0.4));

            timeStart.innerText = currentTrack[0][2];
            timeEnd.innerText = currentTrack[currentTrack.length - 1][2];
            timeNow.innerText = currentTrack[0][2];

            document.getElementById('det-imei').innerText = imei;
            document.getElementById('det-sat').innerText = String(Math.floor(Math.random() * 8) + 5);
            document.getElementById('det-op').innerText = 'Operator X';
            document.getElementById('det-lat').innerText = currentTrack[0][0].toFixed(6);
            document.getElementById('det-lng').innerText = currentTrack[0][1].toFixed(6);
            document.getElementById('det-time').innerText = currentTrack[0][2];

            progress = 0; setProgress(0);
            playing = false; updatePlayUI();
            if (animFrame) cancelAnimationFrame(animFrame);
            animFrame = null;

            // ensure player visible on new load briefly
            const fp = document.getElementById('floatingPlayer');
            if (fp) fp.classList.remove('hidden');
        }

        /* UI bindings */
        btnLoad.addEventListener('click', function () {
            const imei = selectAsset.value;
            if (!imei) { alert('Select an asset to load track'); return; }
            loadTrack(imei);
            closeFilter(); // close filters after load for clean view
        });

        selectAsset.addEventListener('change', function () {
            const imei = this.value;
            if (imei && demoTracks[imei]) {
                loadTrack(imei);
                // demo autoplay shortly after load
                setTimeout(function () {
                    playing = true;
                    lastNow = performance.now();
                    animFrame = requestAnimationFrame(animatePlayback);
                    updatePlayUI();
                }, 300);
            }
        });

        /* ensure buttons won't postback in ASP.NET if inside a form - use type="button" (already set) */
        // No further action required.

        /* initial state */
        // leave filter closed; user clicks selectDevicesBtn to open
    })();
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

            document.addEventListener("accent-changed", function () {
                document.querySelectorAll(".play-btn").forEach(b => {
                    b.style.background = `linear-gradient(135deg, var(--accent-dark), var(--accent))`;
                });

                document.querySelectorAll("#selectDevicesBtn, #btnLoad").forEach(b => {
                    b.style.background = `linear-gradient(90deg, var(--accent), var(--accent-light))`;
                });

                document.querySelectorAll(".detail-title").forEach(t => {
                    t.style.color = getComputedStyle(document.documentElement).getPropertyValue("--accent");
                });
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
