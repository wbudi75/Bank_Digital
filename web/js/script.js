// script.js
document.addEventListener('DOMContentLoaded', () => {
    const loginForm = document.querySelector('.login-form');
    loginForm.addEventListener('submit', (e) => {
        const id = document.getElementById('id').value;
        if(!id) {
            e.preventDefault();
            alert('Sistem: Silakan masukkan User ID Anda terlebih dahulu.');
        }
    });
});
