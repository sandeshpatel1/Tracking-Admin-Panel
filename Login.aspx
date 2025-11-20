<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
<meta charset="utf-8" />
<title>Login | ATM</title>

<!-- VANTA.JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r134/three.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/vanta@latest/dist/vanta.net.min.js"></script>

<style>

/* GLOBAL FIX */
*, *::before, *::after { box-sizing: border-box !important; }

body, html {
    margin: 0; padding: 0;
    height: 100%; width: 100%;
    font-family: 'Segoe UI', sans-serif;
    overflow: hidden;
}

#vanta-bg {
    position: fixed;
    inset: 0;
    width: 100%; height: 100%;
    z-index: -1;
}

/* MAIN WRAPPER */
.main-wrapper {
    display: flex;
    justify-content: flex-end;
    align-items: center;
    height: 100vh;
    width: 100%;
    padding-right: 120px;
    padding-left: 60px;
}

/* LOGIN CONTAINER */
.login-container {
    width: 380px;
    padding: 26px;
    border-radius: 20px;

    background: rgba(15,23,42,0.50);
    backdrop-filter: blur(20px);

    border: 1px solid rgba(255,255,255,0.09);
    box-shadow: 0 8px 38px rgba(0,0,0,0.48);

    color: #e2e8f0;
    position: relative;
    overflow: hidden;

    opacity: 0;
    transform: translateY(12px);
    animation: fadeIn .6s ease-out forwards;

    transition: transform .18s ease-out;
}

/* Border animation */
.login-container::before {
    content: "";
    position: absolute;
    inset: 0;
    padding: 1.6px;
    border-radius: 20px;
    background: linear-gradient(140deg,#38bdf8,#0ea5e9,#38bdf8);
    background-size: 300% 300%;
    animation: borderMove 6s ease infinite;

    pointer-events: none;
    -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
    -webkit-mask-composite: xor;
    mask-composite: exclude;
}

@keyframes fadeIn { to { opacity:1; transform:translateY(0); } }
@keyframes borderMove {
    0% { background-position:0% 50%; }
    50% { background-position:100% 50%; }
    100% { background-position:0% 50%; }
}

/* HEADINGS */
h2 { font-size: 20px; font-weight: 600; margin: 0; }
h2 span { color:#38bdf8; }
h3 { font-size: 22px; margin: 10px 0 18px; color:#38bdf8; }

/* FORM */
.form-group { margin-bottom: 15px; }
label { font-size: 13px; color:#cbd5e1; margin-bottom: 5px; display:block; }
.input-wrapper { width:100%; position:relative; }

/* FIXED INPUT + EYE TOGGLE */
.inputbox {
    width: 100% !important;
    padding: 11px 45px 11px 14px;  /* right padded for eye */
    font-size: 14px;
    border-radius: 10px;
    border: 2px solid #d0d7e3;
    background:#eef4ff;
    color:#1e293b;
}

.inputbox:focus {
    border-color:#38bdf8;
    box-shadow:0 0 8px rgba(56,189,248,0.32);
    outline:none;
}

/* Eye icon PERFECTLY aligned */
.eye-toggle {
    position:absolute;
    right:14px;
    top:50%;
    transform: translateY(-50%);
    cursor:pointer;
    opacity:0.75;
    z-index: 5;
}
.eye-toggle:hover { opacity:1; }

/* REMEMBER + FORGOT FIXED */
.remember-row {
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin: 5px 0 14px;
}

.remember-row label {
    font-size: 13px;
    margin-left: 4px;
}

.remember-row a {
    font-size: 13px;
    color:#38bdf8;
    text-decoration:none;
}
.remember-row a:hover { text-decoration:underline; }

/* BUTTON */
.login-btn {
    width:100%;
    padding:11px;
    background:linear-gradient(90deg,#2563eb,#38bdf8);
    border-radius:10px;
    border:none;
    color:white;
    font-size:14px;
    font-weight:600;
    transition:.18s ease;
}

.login-btn:hover {
    transform: translateY(-1px);
    box-shadow: 0 5px 15px rgba(56,189,248,0.30);
}

/* Bottom text */
.bottom-text {
    text-align:center;
    margin-top:14px;
    font-size:13px;
}

.bottom-text a {
    color:#38bdf8;
    text-decoration:none;
}
.bottom-text a:hover { text-decoration:underline; }

/* FLOATING PARTICLES */
.login-particles {
    position:absolute;
    inset:0;
    overflow:hidden;
    border-radius:inherit;
    z-index:1;
}

#particleCanvas {
    width:100%;
    height:100%;
    display:block;
    opacity:0.22;
}

/* Content always stays ABOVE particles */
.login-container > * {
    position:relative;
    z-index:3;
}

/* RESPONSIVE */
@media (max-width:1024px){
    .main-wrapper { justify-content:center !important; padding:0 !important; }
}

@media (max-width:600px){
    .login-container { width:88% !important; padding:22px !important; border-radius:18px !important; }
    h2 { font-size:18px !important; }
    h3 { font-size:20px !important; }
}

</style>
</head>

<body>

<div id="vanta-bg"></div>
<div id="pageFade"></div>

<form id="form1" runat="server">

<div class="main-wrapper">

    <div class="login-container" id="loginCard">

        <!-- PARTICLES -->
       <%-- <div class="login-particles"><canvas id="particleCanvas"></canvas></div>--%>

        <h2>Welcome to <span>ATM</span></h2>
        <h3>Sign in</h3>

        <!-- USERNAME -->
        <div class="form-group">
            <label>Username or Email Address *</label>
            <div class="input-wrapper">
                <asp:TextBox ID="txtUsername" runat="server" CssClass="inputbox"
                             placeholder="Enter username"></asp:TextBox>
            </div>
        </div>

        <!-- PASSWORD -->
        <div class="form-group">
            <label>Password *</label>
            <div class="input-wrapper">

                <asp:TextBox ID="txtPassword" runat="server" CssClass="inputbox"
                             TextMode="Password" placeholder="Enter password"></asp:TextBox>

                <span class="eye-toggle" onclick="togglePassword()">
                    <svg id="eyeShow" width="20" height="20" stroke="#475569"
                         viewBox="0 0 24 24" fill="none" stroke-width="2">
                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8Z"/>
                        <circle cx="12" cy="12" r="3"/>
                    </svg>

                    <svg id="eyeHide" width="20" height="20" stroke="#475569"
                         viewBox="0 0 24 24" fill="none" stroke-width="2" style="display:none;">
                        <path d="M1 1l22 22"/>
                    </svg>
                </span>

            </div>
        </div>

        <!-- REMEMBER + FORGOT -->
        <div class="remember-row">
            <div style="display:flex;align-items:center;">
                <asp:CheckBox ID="chkRemember" runat="server" />
                <label for="chkRemember">Remember Me</label>
            </div>
            <a href="#">Forgot Password?</a>
        </div>

        <!-- BUTTON -->
        <asp:Button ID="btnLogin" runat="server" CssClass="login-btn"
                    Text="Sign In" OnClick="btnLogin_Click" />

        <!-- BOTTOM TEXT -->
        <div class="bottom-text">
            Don’t have an account yet? <a href="#">Get Demo</a>
        </div>

    </div>

</div>

</form>

<!-- SCRIPT: Eye Toggle -->
<script>
    function togglePassword() {
        var pass = document.getElementById("<%= txtPassword.ClientID %>");
        var show = document.getElementById("eyeShow");
        var hide = document.getElementById("eyeHide");

        if (pass.type === "password") {
            pass.type = "text";
            show.style.display = "none";
            hide.style.display = "block";
        } else {
            pass.type = "password";
            show.style.display = "block";
            hide.style.display = "none";
        }
    }
</script>

<!-- FLOATING PARTICLES -->
<script>
    const canvas = document.getElementById("particleCanvas");
    const ctx = canvas.getContext("2d");

    let particles = [];
    let w, h;

    function resizeCanvas() {
        w = canvas.width = canvas.offsetWidth;
        h = canvas.height = canvas.offsetHeight;
    }
    window.addEventListener("resize", resizeCanvas);
    resizeCanvas();

    function createParticles(count) {
        particles = [];
        for (let i = 0; i < count; i++) {
            particles.push({
                x: Math.random() * w,
                y: Math.random() * h,
                size: Math.random() * 2 + 1,
                speedX: (Math.random() - 0.5) * 0.4,
                speedY: (Math.random() - 0.5) * 0.4,
                glow: Math.random() * 6 + 4
            });
        }
    }
    createParticles(35);

    function animateParticles() {
        ctx.clearRect(0, 0, w, h);

        particles.forEach(p => {
            p.x += p.speedX; p.y += p.speedY;
            if (p.x < 0) p.x = w; if (p.x > w) p.x = 0;
            if (p.y < 0) p.y = h; if (p.y > h) p.y = 0;

            ctx.beginPath();
            ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
            ctx.fillStyle = "rgba(56,189,248,0.7)";
            ctx.shadowColor = "#38bdf8";
            ctx.shadowBlur = p.glow;
            ctx.fill();
        });

        requestAnimationFrame(animateParticles);
    }
    animateParticles();
</script>

<!-- VANTA BG -->
<script>
    VANTA.NET({
        el: "#vanta-bg",
        mouseControls: true,
        touchControls: true,
        gyroControls: false,
        minHeight: 200,
        minWidth: 200,
        color: 0x38bdf8,
        backgroundColor: 0x0f172a,
        points: 9,
        maxDistance: 22,
        spacing: 16
    });
</script>

</body>
</html>
