const express = require('express');
const app = express();
app.use(express.json());

let users = { "user123": { remainingDataMB: 12500, active: true } };

app.get('/api/get-config', (req, res) => {
    const { userId, mode } = req.query; 
    
    if(!users[userId] || users[userId].remainingDataMB <= 0) {
        return res.status(403).json({ error: "حجم شما به پایان رسیده است." });
    }

    if (mode === 'xray') {
        res.json({ type: "vmess", config: "vmess://YOUR_XRAY_OUTBOUND_CONFIG_STRING" });
    } else if (mode === 'wireguard') {
        res.json({ type: "wireguard", privateKey: "USER_PRIVATE_KEY", endpoint: "SERVER_IP:PORT" });
    }
});

app.post('/api/deduct-data', (req, res) => {
    const { userId, usedDataMB } = req.body;
    users[userId].remainingDataMB -= usedDataMB;
    res.json({ status: "success", remaining: users[userId].remainingDataMB });
});

app.listen(3000, () => console.log('VPNSOPRWG Backend Running on port 3000'));
