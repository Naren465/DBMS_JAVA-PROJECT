/**
 * CRUISEBUS - Global UI interactions
 */
document.addEventListener('DOMContentLoaded', () => {
    // Fade in loaded panels smoothly
    document.querySelectorAll('.glass-panel, .reservation-card, .auth-card, .search-glass-card').forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(15px)';
        el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        requestAnimationFrame(() => {
            el.style.opacity = '1';
            el.style.transform = 'translateY(0)';
        });
    });

    // Auto-dismiss flash alerts after 5s
    const flash = document.querySelector('.flash-message');
    if (flash) {
        setTimeout(() => {
            flash.style.opacity = '0';
            flash.style.transform = 'translateY(-10px)';
            flash.style.transition = 'all 0.5s ease';
            setTimeout(() => flash.remove(), 500);
        }, 5000);
    }
});
