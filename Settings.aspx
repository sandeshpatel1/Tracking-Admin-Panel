<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Dashboard.master" AutoEventWireup="true" CodeFile="Settings.aspx.cs" Inherits="Settings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<!-- =========================
     Settings.aspx — Full updated file
     - Keeps your existing logic & inputs intact
     - Adds persistent accent (3 swatches you asked)
     - Accent persisted in localStorage and applied site-wide via CSS variables
     - Listens to storage events so other open pages update instantly
     - Does NOT remove or clear any input values
     - All tabs use the same two-column layout (A1)
========================= -->

<!-- Scoped styles (keeps original appearance but wired to CSS variables) -->
<style>
  :root{
    --bg: #f4f6f9;
    --card: #ffffff;
    --muted: #6b7280;
    --text: #0f172a;

    /* dynamic accent variables (will be updated by JS) */
    --accent: #2563eb;
    --accent-2: #00c6ff;

    --radius: 12px;
    --shadow-sm: 0 6px 20px rgba(15,23,42,0.06);
  }

  /* Dark theme overrides (toggle .theme-dark on body) */
  body.theme-dark {
    --bg: #071028;
    --card: #0f1724;
    --muted: #9aa6b2;
    --text: #e6eef7;
    --shadow-sm: 0 18px 40px rgba(2,6,23,0.6);
  }

  /* Page wrapper */
  .settings-page {
    background: var(--bg);
    color: var(--text);
    min-height: calc(100vh - 78px);
    transition: background .18s ease, color .18s ease;
  }

  /* Heading style (matching "Devices" style — Heading C) */
  .page-heading {
    display:flex;
    align-items:center;
    gap:14px;
    margin-bottom:18px;
  }
  .page-heading .left {
    flex:1;
  }
  .page-heading h1 {
    margin:0;
    font-size:26px;
    font-weight:800;
    color:var(--text);
  }
  .page-heading p {
    margin:0px 0 0;
    color:var(--muted);
    font-size:13px;
  }
  /* accent bar left of heading */
  .heading-accent {
    width:6px;
    height:48px;
    border-radius:4px;
    background: linear-gradient(180deg,var(--accent-2),var(--accent));
    box-shadow: 0 6px 18px rgba(0,0,0,0.06);
  }

  /* Layout: left nav + right content */
  .settings-grid {
    display:grid;
    grid-template-columns: 320px 1fr;
    gap:20px;
    align-items:start;
  }

  .settings-nav {
    background:var(--card);
    border-radius:12px;
    padding:12px;
    box-shadow:var(--shadow-sm);
    border: 1px solid rgba(15,23,42,0.04);
  }
  .settings-nav .nav-item{
    display:flex;
    gap:12px;
    align-items:center;
    padding:10px 12px;
    border-radius:10px;
    cursor:pointer;
    color:var(--text);
    font-weight:700;
    transition: background .12s ease, border-left-color .12s ease;
  }
  .settings-nav .nav-item + .nav-item { margin-top:8px; }
  .settings-nav .nav-item .ico {
    width:36px;height:36px;border-radius:8px;display:flex;align-items:center;justify-content:center;
    background:linear-gradient(180deg, rgba(0,0,0,0.03), rgba(0,0,0,0.01));
    color:var(--accent);
    font-weight:800;
  }
  .settings-nav .nav-item.active{
    background: linear-gradient(90deg, rgba(0,0,0,0.02), rgba(0,0,0,0.01));
    border-left: 4px solid var(--accent);
  }

  .settings-card {
    background:var(--card);
    border-radius:12px;
    padding:20px;
    box-shadow:var(--shadow-sm);
    border: 1px solid rgba(15,23,42,0.04);
    transition: background .15s ease, color .15s ease;
  }
  .settings-card h4 { margin:0 0 6px 0; font-size:18px; }
  .settings-card p.lead { margin:0 0 16px 0; color:var(--muted); }

  /* New: section grid enforces two-column layout for every tab (A1) */
  .section-grid {
    display:grid;
    grid-template-columns: 1fr 1fr;
    gap:18px;
    align-items:start;
    margin-top:12px;
  }

  .form-block {
    background: transparent;
    padding: 0;
  }

  .form-row {
    display:grid;
    grid-template-columns: 1fr;
    gap:12px;
    margin-bottom:12px;
  }
  /* when inside larger two-column blocks, keep each label+control as single row */
  .form-row .field { display:flex; flex-direction:column; gap:6px; }
  .field label { font-size:13px; color:var(--muted); font-weight:600; }
  .field input, .field select, .field textarea {
    padding:10px 12px; border-radius:8px; border:1px solid rgba(15,23,42,0.06);
    background:transparent; color:var(--text); font-size:14px;
  }
  body:not(.theme-dark) .field input, body:not(.theme-dark) .field select { background:#fff; }
  body.theme-dark .field input, body.theme-dark .field select { background:#07182a; border-color: rgba(255,255,255,0.04); color:var(--text); }

  .save-row { display:flex; justify-content:flex-end; margin-top:12px; }
  .btn {
    display:inline-flex; align-items:center; gap:8px;
    padding:8px 14px; border-radius:10px; border: none; cursor:pointer; font-weight:800;
  }

  /* Primary button uses accent variables */
  .btn-primary {
    background: linear-gradient(90deg,var(--accent-2),var(--accent));
    color:#fff;
    box-shadow: 0 8px 22px rgba(0,0,0,0.08);
    border: none;
  }

  .btn-outline {
    background:transparent; border:1px solid rgba(15,23,42,0.06); color:var(--text);
  }

  .theme-preview { display:flex; gap:10px; align-items:center; }
  .swatch {
    width:40px; height:28px; border-radius:8px; box-shadow: 0 6px 18px rgba(2,6,23,0.06);
    cursor:pointer; border: 2px solid transparent; transition: transform .12s, border-color .12s;
  }
  .swatch:hover { transform: translateY(-4px); }
  .swatch.active { border-color: rgba(0,0,0,0.08); }

  /* Ensure table-like/ device heading look for nav items (as requested) */
  .nav-item .title {
    font-weight:800;
    letter-spacing:0.2px;
    color:var(--text);
  }
  .nav-item .sub {
    font-size:12px;
    color:var(--muted);
    margin-top:2px;
  }

  /* Responsive behavior: on small screens collapse the 2-col to 1 */
  @media (max-width: 980px) {
    .settings-grid { grid-template-columns: 1fr; }
    .section-grid { grid-template-columns: 1fr; }
    .save-row { justify-content:center; margin-top:16px; }
  }
</style>

<!-- MARKUP -->
<div class="settings-page">

  <!-- Heading (Style C — uses accent bar and title like your Devices page) -->
  <div class="page-heading">
    <div class="heading-accent" aria-hidden="true"></div>
    <div class="left">
      <h1>Settings</h1>
      <p>Manage your account, theme and application preferences.</p>
    </div>
    <div>
      <button id="btnSaveTop" class="btn btn-primary" type="button">Save changes</button>
    </div>
  </div>

  <div class="settings-grid">
    <!-- LEFT NAV (keeps Device-like style: title + small subtitle) -->
    <aside class="settings-nav" id="settingsNav" role="navigation" aria-label="Settings navigation">
      <div class="nav-item active" data-tab="general" role="button" tabindex="0">
        <div class="ico">⚙</div>
        <div>
          <div class="title">General</div>
          <div class="sub">Account & profile</div>
        </div>
      </div>

      <div class="nav-item" data-tab="theme" role="button" tabindex="0">
        <div class="ico">🎨</div>
        <div>
          <div class="title">Appearance</div>
          <div class="sub">Theme & accent</div>
        </div>
      </div>

      <div class="nav-item" data-tab="notifications" role="button" tabindex="0">
        <div class="ico">🔔</div>
        <div>
          <div class="title">Notifications</div>
          <div class="sub">Alerts & channels</div>
        </div>
      </div>

      <div class="nav-item" data-tab="devices" role="button" tabindex="0">
        <div class="ico">📟</div>
        <div>
          <div class="title">Devices</div>
          <div class="sub">Defaults & behavior</div>
        </div>
      </div>

      <div class="nav-item" data-tab="security" role="button" tabindex="0">
        <div class="ico">🔒</div>
        <div>
          <div class="title">Security</div>
          <div class="sub">Access & authentication</div>
        </div>
      </div>
    </aside>

    <!-- RIGHT PANEL -->
    <section class="settings-card" id="settingsCard" role="region" aria-labelledby="settings-heading">
      <!-- GENERAL TAB -->
      <div class="tab" id="tab-general">
        <h4>General settings</h4>
        <p class="lead">Basic account information. (All fields preserved.)</p>

        <div class="section-grid">
          <div class="form-block">
            <div class="form-row">
              <div class="field">
                <label>Full name</label>
                <input id="fullName" type="text" value="Admin User" />
              </div>
            </div>

            <div class="form-row">
              <div class="field">
                <label>Timezone</label>
                <select id="timezone">
                  <option>Asia/Kolkata (IST)</option>
                  <option>UTC</option>
                  <option>America/New_York</option>
                </select>
              </div>
            </div>
          </div>

          <div class="form-block">
            <div class="form-row">
              <div class="field">
                <label>Email</label>
                <input id="email" type="email" value="admin@atm.com" />
              </div>
            </div>

            <div class="form-row">
              <div class="field">
                <label>Language</label>
                <select id="language">
                  <option>English</option>
                  <option>Spanish</option>
                </select>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- THEME TAB (the accent swatches you requested are preserved exactly) -->
      <div class="tab" id="tab-theme" style="display:none;">
        <h4>Theme</h4>
        <p class="lead">Choose appearance and accent colors. Accent persists across the whole app.</p>

        <div class="section-grid">
          <div class="form-block">
            <div class="form-row">
              <div class="field">
                <label style="font-weight:700; margin-bottom:6px;">Appearance</label>
                <div style="display:flex; gap:18px; align-items:center;">
                  <label style="display:inline-flex;align-items:center;gap:8px;cursor:pointer;">
                    <input type="radio" name="appearance" value="light" /> Light
                  </label>
                  <label style="display:inline-flex;align-items:center;gap:8px;cursor:pointer;">
                    <input type="radio" name="appearance" value="dark" /> Dark
                  </label>
                  <label style="display:inline-flex;align-items:center;gap:8px;cursor:pointer;">
                    <input type="radio" name="appearance" value="system" /> System
                  </label>
                </div>
              </div>
            </div>

            <div class="form-row" style="margin-top:8px;">
              <div class="field">
                <label style="font-weight:700;">Preview</label>
                <div class="example-preview" style="display:flex;gap:8px;align-items:center;">
                  <div style="width:60px;height:36px;border-radius:8px;background:linear-gradient(90deg,var(--accent-2),var(--accent));box-shadow:var(--shadow-sm)"></div>
                  <div style="font-size:13px;color:var(--muted)">This preview uses the selected accent</div>
                </div>
              </div>
            </div>
          </div>

          <div class="form-block">
            <div class="form-row">
              <div class="field">
                <label style="font-weight:700; display:block; margin-bottom:8px;">Accent</label>

                <div class="theme-preview" aria-label="Accent swatches">
                  <!-- EXACT colors you demanded -->
                  <div>
                    <div class="swatch" id="sw1" data-key="electric" title="Electric Blue" style="background: linear-gradient(90deg,#00c6ff,#2563eb)"></div>
                  </div>
                  <div>
                    <div class="swatch" id="sw2" data-key="purple" title="Purple & Aqua" style="background: linear-gradient(90deg,#7c3aed,#06b6d4)"></div>
                  </div>
                  <div>
                    <div class="swatch" id="sw3" data-key="warm" title="Warm Orange" style="background: linear-gradient(90deg,#f97316,#ef4444)"></div>
                  </div>
                </div>

              </div>
            </div>

            <div class="form-row">
              <div class="field">
                <div style="margin-top:6px;color:var(--muted);font-size:13px">Pick an accent to update the UI. Choice is saved for your browser.</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- NOTIFICATIONS TAB -->
      <div class="tab" id="tab-notifications" style="display:none;">
        <h4>Notifications</h4>
        <p class="lead">Control how you receive alerts.</p>

        <div class="section-grid">
          <div class="form-block">
            <div class="form-row">
              <div class="field">
                <label>Email alerts</label>
                <select id="emailAlerts"><option>Enabled</option><option>Disabled</option></select>
              </div>
            </div>

            <div class="form-row">
              <div class="field">
                <label>Notification frequency</label>
                <select id="emailFreq"><option>Immediate</option><option>Hourly</option><option>Daily</option></select>
              </div>
            </div>
          </div>

          <div class="form-block">
            <div class="form-row">
              <div class="field">
                <label>Push notifications</label>
                <select id="pushAlerts"><option>Enabled</option><option>Disabled</option></select>
              </div>
            </div>

            <div class="form-row">
              <div class="field">
                <label>Do not disturb</label>
                <select id="dnd"><option>Off</option><option>Night (22:00 - 07:00)</option></select>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- DEVICES TAB -->
      <div class="tab" id="tab-devices" style="display:none;">
        <h4>Devices</h4>
        <p class="lead">Defaults for newly added devices.</p>

        <div class="section-grid">
          <div class="form-block">
            <div class="form-row">
              <div class="field">
                <label>Default device type</label>
                <select id="defaultDeviceType"><option>IOT</option><option>LOCK</option></select>
              </div>
            </div>

            <div class="form-row">
              <div class="field">
                <label>Default IP prefix</label>
                <input id="defaultIpPrefix" type="text" placeholder="e.g. 192.168." />
              </div>
            </div>
          </div>

          <div class="form-block">
            <div class="form-row">
              <div class="field">
                <label>Default status</label>
                <select id="defaultDeviceStatus"><option>Active</option><option>Inactive</option></select>
              </div>
            </div>

            <div class="form-row">
              <div class="field">
                <label>Default port</label>
                <input id="defaultPort" type="text" placeholder="e.g. 502" />
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- SECURITY TAB -->
      <div class="tab" id="tab-security" style="display:none;">
        <h4>Security</h4>
        <p class="lead">Access & password settings.</p>

        <div class="section-grid">
          <div class="form-block">
            <div class="form-row">
              <div class="field">
                <label>Change password</label>
                <input id="password" type="password" placeholder="New password" />
              </div>
            </div>

            <div class="form-row">
              <div class="field">
                <label>Password expiry days</label>
                <input id="pwdExpiry" type="number" placeholder="e.g. 90" />
              </div>
            </div>
          </div>

          <div class="form-block">
            <div class="form-row">
              <div class="field">
                <label>2FA</label>
                <select id="twofa"><option>Disabled</option><option>Enabled</option></select>
              </div>
            </div>

            <div class="form-row">
              <div class="field">
                <label>Session timeout (mins)</label>
                <input id="sessionTimeout" type="number" placeholder="e.g. 30" />
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="save-row">
        <button id="saveBtn" class="btn btn-primary" type="button">Save changes</button>
      </div>
    </section>
  </div>
</div>

<!-- SCRIPTS: tab switching, theme & accent persistence, and cross-tab updates -->
<script>
    (function () {
        // -----------------------
        // TAB NAV
        // -----------------------
        const nav = document.getElementById('settingsNav');
        const items = nav.querySelectorAll('.nav-item');
        const tabs = document.querySelectorAll('.tab');

        function showTab(name) {
            tabs.forEach(t => t.style.display = (t.id === 'tab-' + name ? '' : 'none'));
            items.forEach(i => i.classList.toggle('active', i.dataset.tab === name));
            localStorage.setItem('settingsActiveTab', name);
        }
        items.forEach(it => {
            it.addEventListener('click', () => showTab(it.dataset.tab));
            it.addEventListener('keydown', (e) => { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); showTab(it.dataset.tab); } });
        });
        // restore tab
        showTab(localStorage.getItem('settingsActiveTab') || 'general');

        // wire header save
        const headerSave = document.getElementById('btnSaveTop');
        if (headerSave) headerSave.addEventListener('click', () => document.getElementById('saveBtn').click());

        // demo save action
        document.getElementById('saveBtn').addEventListener('click', function () {
            this.disabled = true;
            this.innerText = 'Saving...';
            setTimeout(() => { this.disabled = false; this.innerText = 'Save changes'; alert('Settings saved (demo).'); }, 600);
        });

        // -----------------------
        // THEME (light/dark/system)
        // -----------------------
        function applyThemeFromStorage() {
            const isDark = localStorage.getItem('themeDark') === 'true';
            document.body.classList.toggle('theme-dark', isDark);
            // set radio
            const radios = document.getElementsByName('appearance');
            radios.forEach(r => r.checked = (isDark ? r.value === 'dark' : r.value === 'light'));
        }

        document.querySelectorAll('input[name="appearance"]').forEach(r => {
            r.addEventListener('change', function () {
                if (this.value === 'system') {
                    localStorage.removeItem('themeDark');
                } else {
                    localStorage.setItem('themeDark', this.value === 'dark' ? 'true' : 'false');
                }
                applyThemeFromStorage();
                // notify other tabs
                window.dispatchEvent(new Event('storage'));
            });
        });

        // init
        applyThemeFromStorage();
        window.addEventListener('storage', function (e) {
            // ensure theme update if changed elsewhere
            if (e.key === 'themeDark' || !e.key) applyThemeFromStorage();
            // accent updates handled below
            if (e.key === 'uiAccent' || !e.key) initAccent();
        });

        // -----------------------
        // ACCENT: persistent, global, exact three swatches requested
        // -----------------------
        const ACCENTS = {
            // BLUE (electric)
            electric: {
                a: "#00c6ff",   // light
                b: "#2563eb"    // main
            },

            // CYAN / TURQUOISE (your 2nd accent)
            purple: {           // keep key 'purple' because your swatch ID depends on it
                a: "#06b6d4",   // light cyan
                b: "#0ea5e9"    // main cyan (NOT purple anymore)
            },

            // ORANGE (warm)
            warm: {
                a: "#fb923c",   // light
                b: "#f97316"    // main
            }
        };


        function applyAccentByKey(key) {
            const k = ACCENTS[key] ? key : 'electric';
            const vals = ACCENTS[k];

            /* ---- UPDATE SETTINGS PAGE ---- */
            document.documentElement.style.setProperty('--accent', vals.b);
            document.documentElement.style.setProperty('--accent-2', vals.a);

            document.querySelectorAll('.btn-primary').forEach(el => {
                el.style.background = `linear-gradient(90deg, ${vals.a}, ${vals.b})`;
                el.style.color = '#fff';
            });

            document.querySelectorAll('.heading-accent').forEach(el => {
                el.style.background = `linear-gradient(180deg, ${vals.a}, ${vals.b})`;
            });

            /* ---- UPDATE DASHBOARD.MASTER LIVE (NO REFRESH) ---- */
            // These CSS vars are referenced in Dashboard.master so updating them updates its UI instantly
            document.documentElement.style.setProperty('--primary', vals.a);
            document.documentElement.style.setProperty('--primary-2', vals.b);
            document.documentElement.style.setProperty('--accent-2', vals.a);
            document.documentElement.style.setProperty('--accent-contrast', '#0b1220');

            // inline adjustments for items that read inline styles
            document.querySelectorAll('.logo-icon').forEach(el => el.style.color = vals.a);
            document.querySelectorAll('.search-icon').forEach(el => el.style.color = vals.b);
            document.querySelectorAll('.profile-wrapper i').forEach(el => el.style.color = vals.b);

            // active menu highlight
            document.querySelectorAll('.menu li.active .menu-link').forEach(el => {
                el.style.borderLeft = `4px solid ${vals.b}`;
                el.style.color = vals.a;
            });

            // Settings-side nav icons
            document.querySelectorAll('.settings-nav .ico').forEach(el => el.style.color = vals.b);

            // mark swatch active visually
            document.querySelectorAll('.swatch').forEach(s =>
                s.classList.toggle('active', s.dataset.key === k)
            );
        }

        // Write chosen accent to localStorage and apply
        function setAccent(key) {
            if (!ACCENTS[key]) key = 'electric';
            localStorage.setItem('uiAccent', key);
            applyAccentByKey(key);
            // dispatch storage event for other tabs (some browsers don't trigger storage on same-tab)
            window.dispatchEvent(new Event('storage'));
        }

        // Initialize accent UI and event handlers
        function initAccent() {
            const saved = localStorage.getItem('uiAccent') || 'electric';
            // ensure swatches have correct data-key (in case markup changed)
            document.querySelectorAll('.swatch').forEach(s => {
                if (!s.dataset.key) {
                    if (s.id === 'sw1') s.dataset.key = 'electric';
                    if (s.id === 'sw2') s.dataset.key = 'purple';
                    if (s.id === 'sw3') s.dataset.key = 'warm';
                }
            });
            applyAccentByKey(saved);
        }

        // Hook up click handlers for swatches (exact swatch IDs you wanted preserved)
        const sw1 = document.getElementById('sw1');
        const sw2 = document.getElementById('sw2');
        const sw3 = document.getElementById('sw3');
        if (sw1) sw1.addEventListener('click', function () { setAccent('electric'); });
        if (sw2) sw2.addEventListener('click', function () { setAccent('purple'); });
        if (sw3) sw3.addEventListener('click', function () { setAccent('warm'); });

        // Init accent now
        initAccent();

        // Also ensure when page first loads the CSS variables are injected for the rest of the site:
        (function ensureRootVars() {
            const cur = localStorage.getItem('uiAccent') || 'electric';
            const vals = ACCENTS[cur] || ACCENTS['electric'];
            // apply to :root
            document.documentElement.style.setProperty('--accent', vals.b);
            document.documentElement.style.setProperty('--accent-2', vals.a);
            // also update Dashboard.master's variables (if present) without waiting for navigation
            document.documentElement.style.setProperty('--primary', vals.a);
            document.documentElement.style.setProperty('--primary-2', vals.b);
        })();

        // Provide a storage listener so other tabs react to accent/theme change
        window.addEventListener('storage', function (e) {
            if (e.key === 'uiAccent' || !e.key) {
                // small delay to allow localStorage to update on some browsers
                setTimeout(initAccent, 20);
            }
            if (e.key === 'themeDark' || !e.key) {
                setTimeout(applyThemeFromStorage, 20);
            }
        });

        // accessibility: ensure radio reflects stored theme on load
        (function restoreAppearanceRadios() {
            const radios = document.getElementsByName('appearance');
            const isDark = localStorage.getItem('themeDark') === 'true';
            radios.forEach(r => r.checked = (isDark ? r.value === 'dark' : r.value === 'light'));
        })();

    })();
</script>

</asp:Content>
