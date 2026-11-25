/**
 * CRUISEBUS - Interactive Seat Selection Engine
 */
let selectedSeats = []; // array of { seatId, seatNumber, fare }
let baseFare = 0;

function initSeatSelection(fare) {
    baseFare = fare;
    const seatNodes = document.querySelectorAll('.seat-node.available');
    seatNodes.forEach(node => {
        node.addEventListener('click', () => {
            const seatId = parseInt(node.getAttribute('data-seat-id'));
            const seatNum = node.getAttribute('data-seat-number');

            const index = selectedSeats.findIndex(s => s.seatId === seatId);
            if (index > -1) {
                // Deselect
                selectedSeats.splice(index, 1);
                node.classList.remove('selected');
            } else {
                // Maximum 6 seats per booking
                if (selectedSeats.length >= 6) {
                    alert('You can select a maximum of 6 seats per reservation.');
                    return;
                }
                selectedSeats.push({ seatId, seatNumber: seatNum, fare: baseFare });
                node.classList.add('selected');
            }
            updateSummary();
        });
    });

    // Deck toggle
    const deckTabs = document.querySelectorAll('.btn-deck-tab');
    deckTabs.forEach(tab => {
        tab.addEventListener('click', () => {
            deckTabs.forEach(t => t.classList.remove('active'));
            tab.classList.add('active');
            const targetDeck = tab.getAttribute('data-deck');
            document.querySelectorAll('.seat-node').forEach(node => {
                if (targetDeck === 'ALL' || node.getAttribute('data-deck') === targetDeck) {
                    node.style.display = 'flex';
                } else {
                    node.style.display = 'none';
                }
            });
        });
    });
}

function updateSummary() {
    const listEl = document.getElementById('selected-seats-badges');
    const totalEl = document.getElementById('summary-total-amount');
    const inputSeatIds = document.getElementById('input-seat-ids');
    const btnSubmit = document.getElementById('btn-confirm-booking');
    const passengerFormList = document.getElementById('passenger-form-list');

    if (!listEl) return;

    if (selectedSeats.length === 0) {
        listEl.innerHTML = '<span class="text-muted" style="font-size: 0.85rem;">No seats selected yet</span>';
        totalEl.textContent = '₹ 0.00';
        inputSeatIds.value = '';
        btnSubmit.disabled = true;
        btnSubmit.style.opacity = '0.5';
        passengerFormList.innerHTML = '<p class="text-muted" style="font-size: 0.85rem;">Please pick seats to enter passenger details.</p>';
        return;
    }

    btnSubmit.disabled = false;
    btnSubmit.style.opacity = '1';

    // Update Seat badges
    listEl.innerHTML = selectedSeats.map(s => 
        `<span class="badge-pill badge-blue" style="font-size:0.85rem;">Seat ${s.seatNumber}</span>`
    ).join(' ');

    // Update total
    const total = selectedSeats.length * baseFare;
    totalEl.textContent = '₹ ' + total.toLocaleString('en-IN', { minimumFractionDigits: 2 });

    // Hidden input with comma-separated seat IDs
    inputSeatIds.value = selectedSeats.map(s => s.seatId).join(',');

    // Dynamically render passenger detail inputs
    passengerFormList.innerHTML = selectedSeats.map((s, idx) => `
        <div class="passenger-entry-box">
            <div style="font-size: 0.8rem; font-weight: 700; color: #38bdf8; margin-bottom: 0.5rem;">
                Passenger ${idx + 1} (Seat ${s.seatNumber})
            </div>
            <div style="display: grid; grid-template-columns: 2fr 1fr 1fr; gap: 0.75rem;">
                <input type="text" name="passengerName_${idx}" class="form-control" placeholder="Full Name" required style="padding: 0.5rem 0.75rem; font-size: 0.85rem;" />
                <input type="number" name="passengerAge_${idx}" class="form-control" placeholder="Age" min="1" max="120" value="28" required style="padding: 0.5rem 0.75rem; font-size: 0.85rem;" />
                <select name="passengerGender_${idx}" class="form-control" style="padding: 0.5rem 0.75rem; font-size: 0.85rem;">
                    <option value="MALE">Male</option>
                    <option value="FEMALE">Female</option>
                    <option value="OTHER">Other</option>
                </select>
            </div>
        </div>
    `).join('');
}
