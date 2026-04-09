/**
 * BNK Digital - Client Side Security Logic
 * Authorized Access Only
 */

// Pesan peringatan di Console
console.log("%c STOP! ", "color: red; font-size: 40px; font-weight: bold;");
console.log("%cBNK Digital Security: Perangkat ini memantau aktivitas mencurigakan.", "color: blue; font-size: 14px;");

// FLAG 1: Console Log (Akan diganti otomatis oleh set_flags.sh)
// Placeholder: {{FLAG_CONSOLE}}
console.log("DEBUG_SYSTEM_INFO: Current Session Token is {{FLAG_CONSOLE}}");

// FLAG 2: Comment (Pancingan buat yang rajin 'View Source')
// {{FLAG_JS_COMMENT}}

function initBankSecurity() {
    // FLAG 3: Base64 (Tetap biarkan manual atau gunakan placeholder)
    // Hint: Decode string di bawah ini untuk mendapatkan flag rahasia
    // Di sini kita pakai placeholder agar script.js tetap bersih di GitHub
    const enc_flag = "{{FLAG_JS_BASE64}}";
    
    let isSecure = true;
    if(isSecure) {
        return "System Secure";
    }
}

document.addEventListener("DOMContentLoaded", function() {
    initBankSecurity();
});