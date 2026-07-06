// Mobile toolbar for ttyd/xterm.js
(function() {
  if (window.__mtbInit) return;
  window.__mtbInit = true;

  // Always show toolbar (not just mobile) — will use media query later
  var bar = document.createElement('div');
  bar.id = 'mtb-bar';
  bar.innerHTML = 
    '<button onclick="document.execCommand(\'selectAll\')" title="Select All">⊞</button>' +
    '<button onclick="document.execCommand(\'cut\')" title="Cut">✂</button>' +
    '<button onclick="document.execCommand(\'paste\')" title="Paste">📋</button>' +
    '<button id="mtb-tab" onclick="document.querySelector(\'#terminal\').focus(); document.execCommand(\'insertText\', false, \'\\t\')" title="Tab">⇥</button>' +
    '<button id="mtb-esc" onclick="document.execCommand(\'insertText\', false, \'\\x1b\')" title="Esc">⎋</button>' +
    '<button id="mtb-ctrl" onclick="document.execCommand(\'insertText\', false, \'\\x03\')" title="Ctrl+C">⌃</button>';
  document.body.appendChild(bar);

  var css = document.createElement('style');
  css.textContent = 
    '#mtb-bar {' +
    '  position: fixed; bottom: 0; left: 0; right: 0; z-index: 10000; ' +
    '  background: #1e1e2e; display: flex; justify-content: center; gap: 8px; ' +
    '  padding: 6px 10px; box-shadow: 0 -2px 10px rgba(0,0,0,0.3); ' +
    '  -webkit-app-region: drag;' +
    '}' +
    '#mtb-bar button {' +
    '  background: #313244; border: 1px solid #45475a; color: #cdd6f4; ' +
    '  padding: 8px 14px; border-radius: 6px; font-size: 14px; cursor: pointer; ' +
    '  -webkit-app-region: no-drag; min-width: 42px; text-align: center;' +
    '}' +
    '#mtb-bar button:active { background: #585b70; }' +
    '@media (min-width: 768px) { #mtb-bar { display: none; } }';
  document.head.appendChild(css);
})();
