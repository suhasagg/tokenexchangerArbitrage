"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getBridgeUrl = exports.selectRandomBridgeUrl = exports.randomBridgeIndex = void 0;
const mainBridge = "https://bridge.walletconnect.org";
const bridges = [
    "https://a.bridge.walletconnect.org",
    "https://b.bridge.walletconnect.org",
    "https://c.bridge.walletconnect.org",
    "https://d.bridge.walletconnect.org",
    "https://e.bridge.walletconnect.org",
    "https://f.bridge.walletconnect.org",
    "https://g.bridge.walletconnect.org",
    "https://h.bridge.walletconnect.org",
    "https://i.bridge.walletconnect.org",
    "https://j.bridge.walletconnect.org",
    "https://k.bridge.walletconnect.org",
    "https://l.bridge.walletconnect.org",
];
function randomBridgeIndex() {
    return Math.floor(Math.random() * bridges.length);
}
exports.randomBridgeIndex = randomBridgeIndex;
function selectRandomBridgeUrl() {
    return bridges[randomBridgeIndex()];
}
exports.selectRandomBridgeUrl = selectRandomBridgeUrl;
function getBridgeUrl(bridge) {
    if (bridge === mainBridge || bridges.includes(bridge)) {
        return selectRandomBridgeUrl();
    }
    return bridge;
}
exports.getBridgeUrl = getBridgeUrl;
//# sourceMappingURL=url.js.map