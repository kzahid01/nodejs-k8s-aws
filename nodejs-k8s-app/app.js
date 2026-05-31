const express = require('express');
const os = require('os');

const app = express();
const PORT = process.env.PORT || 3000;
const APP_VERSION = process.env.APP_VERSION || '1.0.0';

let visitorCount = 0;

app.get('/', (req, res) => {
  visitorCount++;
  const hostname   = os.hostname();
  const platform   = os.platform();
  const nodeVer    = process.version;
  const uptime     = Math.floor(process.uptime());
  const timestamp  = new Date().toISOString();
  const memMB      = (process.memoryUsage().rss / 1024 / 1024).toFixed(2);

  res.send(`<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
  <title>K8s Node.js Demo</title>
  <style>
    *{box-sizing:border-box;margin:0;padding:0}
    body{font-family:'Segoe UI',Arial,sans-serif;background:linear-gradient(135deg,#1a1a2e 0%,#16213e 50%,#0f3460 100%);min-height:100vh;display:flex;align-items:center;justify-content:center;padding:20px;color:#e0e0e0}
    .card{background:rgba(255,255,255,0.05);border:1px solid rgba(255,255,255,0.1);border-radius:16px;padding:40px;max-width:680px;width:100%}
    .badge{display:inline-block;background:#00d4aa;color:#0a0a1a;font-size:12px;font-weight:700;padding:4px 12px;border-radius:20px;margin-bottom:16px;letter-spacing:1px;text-transform:uppercase}
    h1{font-size:28px;font-weight:700;color:#fff;margin-bottom:8px}
    .subtitle{color:#90a0b7;font-size:14px;margin-bottom:32px}
    .grid{display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-bottom:24px}
    @media(max-width:500px){.grid{grid-template-columns:1fr}}
    .stat-card{background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.08);border-radius:10px;padding:16px}
    .stat-label{font-size:11px;text-transform:uppercase;letter-spacing:1px;color:#6a7d93;margin-bottom:6px}
    .stat-value{font-size:16px;font-weight:600;color:#e0f0ff;word-break:break-all}
    .stat-value.highlight{color:#00d4aa;font-size:22px}
    .stat-value.warn{color:#f59e0b}
    .footer{border-top:1px solid rgba(255,255,255,0.08);padding-top:20px;font-size:12px;color:#4a5568;display:flex;justify-content:space-between;flex-wrap:wrap;gap:8px}
    a{color:#00d4aa;text-decoration:none}
    a:hover{text-decoration:underline}
  </style>
</head>
<body>
 
  <div class="card">
    <div class="badge">&#9654; Running on Kubernetes</div>
    <h1>Node.js Cloud Demo</h1>

<p style="margin-top:6px;color:#00d4aa;font-weight:bold;font-size:16px;">
  👤 Zahid Bashir - 55428
</p>
    <p class="subtitle">AWS EC2 + Docker + Minikube &mdash; University Project v${APP_VERSION}</p>
    <div class="grid">
      <div class="stat-card">
        <div class="stat-label">&#128336; Current Timestamp</div>
        <div class="stat-value">${timestamp}</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">&#128101; Visitor Count</div>
        <div class="stat-value highlight">${visitorCount}</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">&#128268; Container / Pod ID</div>
        <div class="stat-value warn">${hostname}</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">&#9881; Node.js Version</div>
        <div class="stat-value">${nodeVer}</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">&#128202; Memory Usage</div>
        <div class="stat-value">${memMB} MB RSS</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">&#9201; App Uptime</div>
        <div class="stat-value">${uptime} seconds</div>
      </div>
    </div>
    <div class="footer">
      <span>Platform: ${platform}</span>
      <span><a href="/health">&#9679; Health Check</a></span>
      <span>Port: ${PORT}</span>
    </div>
  </div>
</body>
</html>`);
});

app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: Math.floor(process.uptime()),
    hostname: os.hostname(),
    version: APP_VERSION,
    memory: {
      rss: `${(process.memoryUsage().rss/1024/1024).toFixed(2)} MB`,
      heapUsed: `${(process.memoryUsage().heapUsed/1024/1024).toFixed(2)} MB`
    },
    visitors: visitorCount
  });
});

app.use((req, res) => {
  res.status(404).json({ error: 'Not Found', path: req.path, hint: 'Try / or /health' });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log('========================================');
  console.log(`  Node.js K8s Demo App`);
  console.log(`  Port    : ${PORT}`);
  console.log(`  Version : ${APP_VERSION}`);
  console.log(`  Host    : ${os.hostname()}`);
  console.log(`  Started : ${new Date().toISOString()}`);
  console.log('========================================');
});
