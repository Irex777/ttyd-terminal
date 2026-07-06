(function(){
  if(window.__mtbInit)return;window.__mtbInit=true;

  function createToolbar(){
    if(document.getElementById('mtb'))return;

    var tb=document.createElement('div');
    tb.id='mtb';
    tb.style.cssText='position:fixed;bottom:0;left:0;right:0;background:#1a1a2e;border-top:1px solid #333;z-index:999999;padding:4px 4px 6px;';

    var mod=null;

    function mk(label,handler,color){
      var b=document.createElement('button');
      b.textContent=label;
      b.style.cssText='flex:1;min-width:36px;height:34px;border:1px solid #333;border-radius:5px;font-size:11px;font-family:monospace;cursor:pointer;-webkit-tap-highlight-color:transparent;touch-action:manipulation;'+(color||'background:#16213e;color:#0f0;');
      b.addEventListener('click',function(e){e.preventDefault();e.stopPropagation();handler(b);b.blur();});
      return b;
    }
    function send(d){try{if(window.term&&window.term.paste)window.term.paste(d);}catch(e){}}
    function flash(b){var o=b.style.background,c=b.style.color;b.style.background='#e94560';b.style.color='#fff';setTimeout(function(){b.style.background=o;b.style.color=c;},150);}

    var escSeq={escape:'\x1b',tab:'\t',arrowup:'\x1b[A',arrowdown:'\x1b[B',arrowright:'\x1b[C',arrowleft:'\x1b[D'};
    var ctrlSeq={c:'\x03',z:'\x1a',d:'\x04',l:'\x0c',r:'\x12',w:'\x17',a:'\x01',e:'\x05',u:'\x15',k:'\x0b'};

    // Toggle button (show/hide toolbar)
    var toggle=document.createElement('button');
    toggle.textContent='\u25BC';
    toggle.style.cssText='position:fixed;bottom:0;right:0;width:32px;height:28px;background:#0f3460;color:#e94560;border:1px solid #333;border-radius:5px 0 0 0;font-size:12px;z-index:1000000;cursor:pointer;-webkit-tap-highlight-color:transparent;touch-action:manipulation;';

    var r1=document.createElement('div');
    r1.style.cssText='display:flex;gap:3px;justify-content:center;flex-wrap:nowrap;';
    var r2=document.createElement('div');
    r2.style.cssText='display:flex;gap:3px;justify-content:center;flex-wrap:nowrap;margin-top:3px;';

    r1.appendChild(mk('ESC',function(b){send(escSeq.escape);flash(b);}));
    r1.appendChild(mk('TAB',function(b){send(escSeq.tab);flash(b);}));

    var cb=mk('CTRL',function(b){
      mod=(mod==='ctrl')?null:'ctrl';
      b.style.background=mod==='ctrl'?'#e94560':'#0f3460';
      b.style.color=mod==='ctrl'?'#fff':'#e94560';
    },'background:#0f3460;color:#e94560;');
    r1.appendChild(cb);

    var ab=mk('ALT',function(b){
      mod=(mod==='alt')?null:'alt';
      b.style.background=mod==='alt'?'#e94560':'#0f3460';
      b.style.color=mod==='alt'?'#fff':'#e94560';
    },'background:#0f3460;color:#e94560;');
    r1.appendChild(ab);

    ['arrowup','arrowdown','arrowleft','arrowright'].forEach(function(k){
      var icons={arrowup:'\u2191',arrowdown:'\u2193',arrowleft:'\u2190',arrowright:'\u2192'};
      var b=mk(icons[k],function(btn){
        var d=escSeq[k];
        if(mod==='ctrl'){var cm={arrowup:'\x1b[1;5A',arrowdown:'\x1b[1;5B',arrowright:'\x1b[1;5C',arrowleft:'\x1b[1;5D'};d=cm[k];mod=null;cb.style.background='#0f3460';cb.style.color='#e94560';}
        else if(mod==='alt'){var am={arrowup:'\x1b[1;3A',arrowdown:'\x1b[1;3B',arrowright:'\x1b[1;3C',arrowleft:'\x1b[1;3D'};d=am[k];mod=null;ab.style.background='#0f3460';ab.style.color='#e94560';}
        send(d);flash(btn);
      });
      b.style.fontSize='15px';
      r1.appendChild(b);
    });

    Object.keys(ctrlSeq).forEach(function(k){
      r2.appendChild(mk('\u2303'+k.toUpperCase(),function(b){send(ctrlSeq[k]);flash(b);},'background:#0f3460;color:#e94560;'));
    });
    r2.appendChild(mk('~',function(b){send('~');flash(b);}));
    r2.appendChild(mk('|',function(b){send('|');flash(b);}));
    r2.appendChild(mk('/',function(b){send('/');flash(b);}));
    r2.appendChild(mk('"',function(b){send('"');flash(b);}));

    tb.appendChild(r1);
    tb.appendChild(r2);

    toggle.addEventListener('click',function(e){
      e.preventDefault();e.stopPropagation();
      if(tb.style.display==='none'){tb.style.display='block';toggle.textContent='\u25BC';}
      else{tb.style.display='none';toggle.textContent='\u25B2';}
      toggle.blur();
    });

    document.body.appendChild(tb);
    document.body.appendChild(toggle);
  }

  // Create immediately
  createToolbar();

  // Re-create if ttyd's React removes it (MutationObserver)
  var obs=new MutationObserver(function(){
    if(!document.getElementById('mtb')&&document.body){
      createToolbar();
    }
  });
  if(document.body){
    obs.observe(document.body,{childList:true});
  }

  // Also retry after delays (in case body wasn't ready)
  setTimeout(createToolbar,500);
  setTimeout(createToolbar,2000);
})();
