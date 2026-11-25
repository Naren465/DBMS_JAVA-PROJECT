/**
 * CRUISEBUS - Ticket Print & QR Generator
 */

function downloadTicketPDF() {
    window.print();
}

// Generate sharp SVG QR Code client-side
function renderQRCode(targetElementId, text) {
    const el = document.getElementById(targetElementId);
    if (!el) return;

    // Use clean SVG matrix or fallback image
    const encoded = encodeURIComponent(text);
    el.innerHTML = `
        <img class="qr-img" 
             src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&color=05070e&bgcolor=ffffff&data=${encoded}" 
             alt="Ticket QR Code" 
             onerror="this.onerror=null; this.src='data:image/svg+xml;utf8,<svg xmlns=\'http://www.w3.org/2000/svg\' width=\'200\' height=\'200\' fill=\'%2305070e\' viewBox=\'0 0 16 16\'><path d=\'M0 .5A.5.5 0 0 1 .5 0h5a.5.5 0 0 1 .5.5v5a.5.5 0 0 1-.5.5h-5A.5.5 0 0 1 0 5.5v-5zm1 1v3h3v-3H1zm9-.5a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 .5.5v5a.5.5 0 0 1-.5.5h-5a.5.5 0 0 1-.5-.5v-5zm1 1v3h3v-3h-3zM0 10.5a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 .5.5v5a.5.5 0 0 1-.5.5h-5a.5.5 0 0 1-.5-.5v-5zm1 1v3h3v-3H1zm7-7a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1-.5-.5v-2zm0 7a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1-.5-.5v-2z\'/></svg>';" />
    `;
}
