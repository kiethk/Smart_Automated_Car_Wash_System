<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="qrModal"
     class="fixed inset-0 bg-black/50 z-50 hidden flex items-center justify-center">
    <div class="bg-white p-6 rounded-2xl shadow-xl max-w-sm w-full text-center flex flex-col items-center gap-4">
        <h3 class="text-base font-bold text-slate-900">Scan QR Code to Pay</h3>
        <p class="text-xs text-slate-400">Open your Mobile Banking or E-Wallet app to scan</p>
        
            <img id="qrImageElement" src="" alt="QR Code" class="w-full"/>

        <p id="qrTotalText" class="font-mono font-bold text-indigo-950 text-sm">0 VND</p>
        <div class="flex gap-2 w-full">
            <button type="button"
                    onclick="closeQrModal()"
                    class="flex-1 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 text-xs font-bold rounded-xl transition-colors">
                Cancel
            </button>
            <button type="button"
                    onclick="confirmPaidQr()"
                    class="flex-1 py-2 bg-indigo-950 hover:bg-indigo-900 text-white text-xs font-bold rounded-xl transition-colors">
                I have paid
            </button>
        </div>
    </div>
</div>